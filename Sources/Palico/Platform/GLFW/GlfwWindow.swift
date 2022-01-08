//
//  GlfwWindow.swift
//  Palico
//
//  Created by Junhao Wang on 12/26/21.
//

import CGLFW3
import Cocoa  // Is it possible not to use Cocoa?
import MathLib

fileprivate struct WindowData {
    var windowDelegate: WindowDelegate? = nil
    var title: String = ""
    var width: UInt32 = 0
    var height: UInt32 = 0
}

fileprivate enum WindowDataOffsets {
    static let windowDelegateOffset = MemoryLayout<WindowData>.offset(of: \.windowDelegate)!
    static let titleOffset = MemoryLayout<WindowData>.offset(of: \.title)!
    static let widthOffset = MemoryLayout<WindowData>.offset(of: \.width)!
    static let heightOffset = MemoryLayout<WindowData>.offset(of: \.height)!
}

class GlfwWindow: Window {
    var title: String { data.title }
    var width: Int { Int(data.width) }
    var height: Int { Int(data.height) }
    var isMinimized: Bool { nsWindow.isMiniaturized }
    
    private var data: WindowData = WindowData()
    
    weak var windowDelegate: WindowDelegate? {
        get { data.windowDelegate }
        set { data.windowDelegate = newValue }
    }
    
    private var lastFrameTime: Double = Time.currentTime
    
    private let nativeWindow: OpaquePointer!
    private let nsWindow: NSWindow
    private let swapchain: CAMetalLayer!
    
    required init(descriptor: WindowDescriptor) {
        Log.info("Initializing GLFW window: \(descriptor.title) \(descriptor.width) x \(descriptor.height)")
        
        // Create Window
        guard let window = glfwCreateWindow(Int32(data.width), Int32(data.height), data.title, nil, nil) else {
            fatalError("Failed to create GLFW window!")
        }
        self.nativeWindow = window
        
        guard let nsWindow = glfwGetCocoaWindow(window) as? NSWindow else {
            fatalError("Failed to get Cocoa window!")
        }
        nsWindow.center()
        nsWindow.makeMain()
        self.nsWindow = nsWindow
        
        // Swapchain
        swapchain = CAMetalLayer()
        swapchain.device = MTLCreateSystemDefaultDevice()
        swapchain.pixelFormat = .bgra8Unorm

        nsWindow.contentView?.layer = swapchain
        nsWindow.contentView?.wantsLayer = true
        
        // Set Window Data
        glfwSetWindowUserPointer(nativeWindow, &data)
        
        // Set GLFW Callbacks
        glfwSetWindowSizeCallback(nativeWindow, glfwWindowResizeCallback)
        glfwSetWindowCloseCallback(nativeWindow, glfwWindowCloseCallback)
        glfwSetKeyCallback(nativeWindow, glfwKeyCallback)
        glfwSetCharCallback(nativeWindow, glfwCharCallback)
        glfwSetMouseButtonCallback(nativeWindow, glfwMouseButtonCallback)
        glfwSetScrollCallback(nativeWindow, glfwScrollCallback)
        glfwSetCursorPosCallback(nativeWindow, glfwCursorPosCallback)
        
        // TODO: Create a runloop that publish onUpdate back to application
    }
}

// Event Callbacks
private func glfwWindowResizeCallback(window: OpaquePointer?, width: Int32, height: Int32) {
    guard let dataPointer = glfwGetWindowUserPointer(window) else {
        Log.warn("WindowResizeCallback::Not able to get window data!")
        return
    }
    
    let w = UInt32(width), h = UInt32(height)
    dataPointer.storeBytes(of: w, toByteOffset: WindowDataOffsets.widthOffset, as: UInt32.self)
    dataPointer.storeBytes(of: h, toByteOffset: WindowDataOffsets.heightOffset, as: UInt32.self)
    
    let event = WindowViewResizeEvent(size: Int2(Int(w), Int(h)))
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
    
    switch action {
    case 0:
        let event = KeyReleasedEvent(keyCode: KeyCode(key))
        publishEvent(dataPointer: dataPointer, event: event)
    case 1:
        let event = KeyPressedEvent(keyCode: KeyCode(key), repeat: 0)  // KeyCode is wrong, which is Cocoa version
        publishEvent(dataPointer: dataPointer, event: event)
    case 2:
        let event = KeyPressedEvent(keyCode: KeyCode(key), repeat: 1)
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
    
    let event = CharTypedEvent(char: String())  // not properly set up yet
    publishEvent(dataPointer: dataPointer, event: event)
}

private func glfwMouseButtonCallback(window: OpaquePointer?, button: Int32, action: Int32, mods: Int32) {
    guard let dataPointer = glfwGetWindowUserPointer(window) else {
        Log.warn("MouseButtonCallback::Not able to get window data!")
        return
    }
    
    switch action {
    case 0:
        let event = MouseButtonReleasedEvent(mouseCode: MouseCode(button))
        publishEvent(dataPointer: dataPointer, event: event)
    case 1:
        let event = MouseButtonPressedEvent(mouseCode: MouseCode(button))
        publishEvent(dataPointer: dataPointer, event: event)
    case 2:
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
    dataPointer.load(as: WindowData.self).windowDelegate?.onEvent(event: event)
}
