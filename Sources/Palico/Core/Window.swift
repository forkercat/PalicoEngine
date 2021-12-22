//
//  Window.swift
//  Palico
//
//  Created by Junhao Wang on 12/15/21.
//

import CGLFW3
import MathLib

fileprivate struct GLFWInt32 {
    static var FALSE: Int32 = 0
    static var TRUE: Int32 = 1
}

struct WindowDescriptor {
    var title: String
    var width: UInt32
    var height: UInt32
    
    init(title: String = "Palico Engine", width: UInt32 = 1280, height: UInt32 = 720) {
        self.title = title
        self.width = width
        self.height = height
    }
}

// Window
typealias WindowEventCallback = (Event) -> Void

class Window {
    fileprivate struct WindowData {
        var eventCallback: WindowEventCallback? = nil
        var title: String = ""
        var width: UInt32 = 0
        var height: UInt32 = 0
        var vSync: Bool = false
    }
    
    fileprivate enum DataOffsets {
        static let eventCallbackOffset = MemoryLayout<WindowData>.offset(of: \.eventCallback)!
        static let titleOffset = MemoryLayout<WindowData>.offset(of: \.title)!
        static let widthOffset = MemoryLayout<WindowData>.offset(of: \.width)!
        static let heightOffset = MemoryLayout<WindowData>.offset(of: \.height)!
        static let vSyncOffset = MemoryLayout<WindowData>.offset(of: \.vSync)!
    }
    
    fileprivate var data: WindowData = WindowData()
    
    private(set) var rawWindow: OpaquePointer!
    private(set) var nsWindow: NSWindow!
    private(set) var swapchain: CAMetalLayer!
    
    private static var windowCount: UInt8 = 0
    
    init(descriptor: WindowDescriptor) {
        data.title = descriptor.title
        data.width = descriptor.width
        data.height = descriptor.height
        
        Log.info("Creating window: \(data.title) \(data.width) x \(data.height)")
        
        if Window.windowCount == 0 {
            Log.debug("Initializing GLFW")
            let success = glfwInit()
            assert(success != 0, "Could not initialize GLFW!")
            glfwSetErrorCallback(glfwErrorCallback)
        }
        
        // Hint
        glfwWindowHint(GLFW_CLIENT_API, GLFW_NO_API)
        glfwWindowHint(GLFW_RESIZABLE, GLFWInt32.TRUE)  // by default
        
        // Create Window
        guard let window = glfwCreateWindow(Int32(data.width), Int32(data.height), data.title, nil, nil) else {
            assertionFailure("Failed to create GLFW window!")
            return
        }
        rawWindow = window
        guard let nsWindow = glfwGetCocoaWindow(window) as? NSWindow else {
            assertionFailure("Failed to get Cocoa window!")
            return
        }
        self.nsWindow = nsWindow
        
        // Swap Chain
        swapchain = CAMetalLayer()
        swapchain.device = MetalContext.device
        swapchain.pixelFormat = .bgra8Unorm
        swapchain.displaySyncEnabled = true  // not working w/ GLFW
        
        nsWindow.contentView?.layer = swapchain
        nsWindow.contentView?.wantsLayer = true
        
        // Set Window Data
        glfwSetWindowUserPointer(rawWindow, &data)
        
        // Set GLFW Callbacks
        glfwSetWindowSizeCallback(rawWindow, glfwWindowResizeCallback)
        glfwSetWindowCloseCallback(rawWindow, glfwWindowCloseCallback)
        glfwSetKeyCallback(rawWindow, glfwKeyCallback)
        glfwSetCharCallback(rawWindow, glfwCharCallback)
        glfwSetMouseButtonCallback(rawWindow, glfwMouseButtonCallback)
        glfwSetScrollCallback(rawWindow, glfwScrollCallback)
        glfwSetCursorPosCallback(rawWindow, glfwCursorPosCallback)
    }
    
    deinit {
        shutdown()
    }
    
    private func shutdown() {
        glfwDestroyWindow(rawWindow)
        Window.windowCount -= 1
        if Window.windowCount == 0 {
            Log.debug("Window::Terminating GLFW!")
            glfwTerminate()
        }
    }
    
    func onUpdate() {
        glfwPollEvents()  // handle events
        MetalContext.updateDrawable(drawable: swapchain.nextDrawable())
    }
    
    func setEventCallback(callback:@escaping WindowEventCallback) {
        data.eventCallback = callback
    }
    
    func setVSync(enabled: Bool) {
        glfwSwapInterval(enabled ? GLFWInt32.TRUE : GLFWInt32.FALSE)
        data.vSync = enabled
    }
    
    func lookupKeyState(key: Key) -> ButtonState {
        let keyCode = key.rawValue
        let state = glfwGetKey(rawWindow, Int32(keyCode))
        return ButtonState(rawValue: State(state)) ?? .unknown
    }
    
    func lookupMouseButtonState(mouse: Mouse) -> ButtonState {
        let mouseCode = mouse.rawValue
        let state = glfwGetMouseButton(rawWindow, Int32(mouseCode))
        return ButtonState(rawValue: State(state)) ?? .unknown
    }
    
    func lookupMousePosition() -> Float2 {
        var xpos: Double = 0
        var ypos: Double = 0
        glfwGetCursorPos(rawWindow, &xpos, &ypos)
        return Float2(x: Float(xpos), y: Float(ypos))
    }
}

// Callbacks
private func glfwErrorCallback(error: Int32, description: UnsafePointer<CChar>?) {
    let str = String(cString: description!)
    Log.error("GLFW::Error \(error): \(str)")
}

private func glfwWindowResizeCallback(window: OpaquePointer?, width: Int32, height: Int32) {
    guard let dataPointer = glfwGetWindowUserPointer(window) else {
        Log.warn("WindowResizeCallback::Not able to get window data!")
        return
    }
    
    let w = UInt32(width), h = UInt32(height)
    dataPointer.storeBytes(of: w, toByteOffset: Window.DataOffsets.widthOffset, as: UInt32.self)
    dataPointer.storeBytes(of: h, toByteOffset: Window.DataOffsets.heightOffset, as: UInt32.self)
    
    let event = WindowResizeEvent(width: w, height: h)
    publishEvent(dataPointer: dataPointer, event: event)
}

private func glfwWindowCloseCallback(window: OpaquePointer?) {
    guard let dataPointer = glfwGetWindowUserPointer(window) else {
        Log.warn("WindowCloseCallback::Not able to get window data!")
        return
    }
    
    let event = WindowCloseEvent()
    publishEvent(dataPointer: dataPointer, event: event)
}

private func glfwKeyCallback(window: OpaquePointer?, key: Int32, scancode: Int32, action: Int32, mods: Int32) {
    guard let dataPointer = glfwGetWindowUserPointer(window) else {
        Log.warn("KeyCallback::Not able to get window data!")
        return
    }
    
    let state = ButtonState(rawValue: State(action))
    switch state {
    case .pressed:
        let event = KeyPressedEvent(keyCode: KeyCode(key), repeatCount: 0)
        publishEvent(dataPointer: dataPointer, event: event)
    case .released:
        let event = KeyReleasedEvent(keyCode: KeyCode(key))
        publishEvent(dataPointer: dataPointer, event: event)
    case .repeated:
        let event = KeyPressedEvent(keyCode: KeyCode(key), repeatCount: 1)
        publishEvent(dataPointer: dataPointer, event: event)
    default:
        assertionFailure("KeyCallback::Unsupported button state!")
    }
}

private func glfwCharCallback(window: OpaquePointer?, keycode: UInt32) {
    guard let dataPointer = glfwGetWindowUserPointer(window) else {
        Log.warn("CharCallback::Not able to get window data!")
        return
    }
    
    let event = CharTypedEvent(char: KeyCode(keycode))
    publishEvent(dataPointer: dataPointer, event: event)
}

private func glfwMouseButtonCallback(window: OpaquePointer?, button: Int32, action: Int32, mods: Int32) {
    guard let dataPointer = glfwGetWindowUserPointer(window) else {
        Log.warn("MouseButtonCallback::Not able to get window data!")
        return
    }
    
    let state = ButtonState(rawValue: State(action))
    switch state {
    case .pressed:
        let event = MouseButtonPressedEvent(mouseCode: MouseCode(button))
        publishEvent(dataPointer: dataPointer, event: event)
    case .released:
        let event = MouseButtonReleasedEvent(mouseCode: MouseCode(button))
        publishEvent(dataPointer: dataPointer, event: event)
    case .repeated:
        assertionFailure("MouseButtonCallback::Released is not supported yet!")
    default:
        assertionFailure("MouseButtonCallback::Unsupported button state!")
    }
}

private func glfwScrollCallback(window: OpaquePointer?, xoffset: Double, yoffset: Double) {
    guard let dataPointer = glfwGetWindowUserPointer(window) else {
        Log.warn("ScrollCallback::Not able to get window data!")
        return
    }
    
    let event = MouseScrolledEvent(x: Float(xoffset), y: Float(yoffset))
    publishEvent(dataPointer: dataPointer, event: event)
}

private func glfwCursorPosCallback(window: OpaquePointer?, xpos: Double, ypos: Double) {
    guard let dataPointer = glfwGetWindowUserPointer(window) else {
        Log.warn("CursorPosCallback::Not able to get window data!")
        return
    }
    
    let event = MouseMovedEvent(x: Float(xpos), y: Float(ypos))
    publishEvent(dataPointer: dataPointer, event: event)
}

private func publishEvent(dataPointer: UnsafeMutableRawPointer, event: Event) {
    dataPointer.load(as: Window.WindowData.self).eventCallback?(event)
}
