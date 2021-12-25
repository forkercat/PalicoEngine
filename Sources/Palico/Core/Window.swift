//
//  Window.swift
//  Palico
//
//  Created by Junhao Wang on 12/15/21.
//

import MetalKit
import MathLib

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

protocol WindowDelegate {
    func onUpdate(deltaTime: Timestep)
    func onEvent(event: Event)
}

// Window
class Window: NSObject {
    var title: String { get { nsWindow.title } }
    var width: UInt32 { get { UInt32(nsWindow.contentView?.frame.width ?? 0) } }
    var height: UInt32 { get { UInt32(nsWindow.contentView?.frame.height ?? 0) } }
    var windowDelegate: WindowDelegate? = nil
    
    static var mainMTKView: MTKView! = nil
    
    private var lastFrameTime: Timestep = Time.currentTime
    
    let viewController = ViewController()
    let nsWindow: NSWindow
    
    init(descriptor: WindowDescriptor) {
        Log.info("Creating window: \(descriptor.title) \(descriptor.width) x \(descriptor.height)")
        
        nsWindow = NSWindow(contentRect: NSRect(x: 0, y: 0, width: Int(descriptor.width), height: Int(descriptor.height)),
                            styleMask: [.miniaturizable, .closable, .resizable, .titled],
                            backing: .buffered,
                            defer: false)
        nsWindow.title = descriptor.title
        nsWindow.center()
        nsWindow.contentView = viewController.mtkView
        nsWindow.acceptsMouseMovedEvents = true
        nsWindow.makeKeyAndOrderFront(nil)
        
        super.init()
        
        viewController.mtkView.delegate = self
        mtkView(viewController.mtkView, drawableSizeWillChange: viewController.mtkView.drawableSize)
        
        // Add a tracking area to capture move events within the window;
        // otherwise, location would become screen coord when mouse is outside.
        let trackingArea = NSTrackingArea(rect: .zero, options: [.mouseMoved, .inVisibleRect, .activeAlways],
                                          owner: viewController.mtkView, userInfo: nil)
        viewController.mtkView.addTrackingArea(trackingArea)
        
        NSEvent.addLocalMonitorForEvents(matching: [.any], handler: onNSEventPublished)
    }
    
    func makeMain() {
        nsWindow.makeMain()
        Self.mainMTKView = viewController.mtkView
    }
}

// Event Publish
extension Window {
    private func onNSEventPublished(nsEvent: NSEvent) -> NSEvent? {
//        let wantsCapture: Bool = ImGui_ImplOSX_HandleEvent(nsEvent, viewController.view)
        let wantsCapture = false
        
        if nsEvent.type == .keyDown && wantsCapture {
            return nil  // do not dispatch keydown event when ImGUi wants to capture
        }
        
        // Handled by us
        switch nsEvent.type {
            
        // key
        case .keyDown:
            keyEventCallback(nsEvent: nsEvent)
            charTypedEventCallback(nsEvent: nsEvent)
            return nil  // do not dispatch key event (alarm sound issue)
        case .keyUp:
            keyEventCallback(nsEvent: nsEvent)
            return nil  // same
        case .flagsChanged:
            modifierChangedEventCallback(nsEvent: nsEvent)
            
        // mouse button
        case .leftMouseDown, .leftMouseUp, .rightMouseDown, .rightMouseUp, .otherMouseDown, .otherMouseUp:
            mouseButtonEventCallback(nsEvent: nsEvent)
            
        // mouse moved
        case .mouseMoved, .leftMouseDragged, .rightMouseDragged, .otherMouseDragged:
            mouseMovedEventCallback(nsEvent: nsEvent)
            
        // scroll wheel
        case .scrollWheel:  // ScrollWheel
            mouseScrollWheelEventCallback(nsEvent: nsEvent)
            // dispatch other events
            return nil  // same
        
        default:
            return nsEvent
        }
        
        return nsEvent
    }
    
    private func publishEvent(_ event: Event) {
        windowDelegate?.onEvent(event: event)
    }
}
    
// Event Callbacks
extension Window {
    private func keyEventCallback(nsEvent: NSEvent) {
        switch nsEvent.type {
        case .keyDown:
            Input.keyMap[Int(nsEvent.keyCode)] = true
            let event = KeyPressedEvent(keyCode: nsEvent.keyCode, repeat: nsEvent.isARepeat ? 1 : 0)
            publishEvent(event)
        case .keyUp:
            Input.keyMap[Int(nsEvent.keyCode)] = false
            let event = KeyReleasedEvent(keyCode: nsEvent.keyCode)
            publishEvent(event)
        default:
            return
        }
    }
    
    private func modifierChangedEventCallback(nsEvent: NSEvent) {
        let flags = nsEvent.modifierFlags
        
        // For debugging
        // print("Command: \(flags.contains(.command)), Shift: \(flags.contains(.shift)), Option: \(flags.contains(.option)), Fn: \(flags.contains(.function))")
        
        // Does not support distinguishing from right modifier keys yet
        Input.keyMap[Int(Key.command.rawValue)]  = flags.contains(.command)
        Input.keyMap[Int(Key.shift.rawValue)]    = flags.contains(.shift)
        Input.keyMap[Int(Key.option.rawValue)]   = flags.contains(.option)
        Input.keyMap[Int(Key.function.rawValue)] = flags.contains(.function)
    }
    
    private func charTypedEventCallback(nsEvent: NSEvent) {
        switch nsEvent.type {
        case .keyDown:
            guard let string = nsEvent.characters else {
                return
            }
            let event = CharTypedEvent(char: string)
            publishEvent(event)
        default:
            return
        }
    }
    
    private func mouseButtonEventCallback(nsEvent: NSEvent) {
        switch nsEvent.type {
        case .leftMouseDown, .rightMouseDown, .otherMouseDown:
            Input.mouseMap[nsEvent.buttonNumber] = true
            let event = MouseButtonPressedEvent(mouseCode: MouseCode(nsEvent.buttonNumber))
            publishEvent(event)
        case .leftMouseUp, .rightMouseUp, .otherMouseUp:
            Input.mouseMap[nsEvent.buttonNumber] = false
            let event = MouseButtonReleasedEvent(mouseCode: MouseCode(nsEvent.buttonNumber))
            publishEvent(event)
        default:
            return
        }
    }
    
    private func mouseMovedEventCallback(nsEvent: NSEvent) {
        let cursorLocation = nsEvent.locationInWindow
        let event = MouseMovedEvent(x: Float(cursorLocation.x), y: Float(cursorLocation.y))
        publishEvent(event)
    }
    
    private func mouseScrollWheelEventCallback(nsEvent: NSEvent) {
        let event = MouseScrolledEvent(x: Float(nsEvent.scrollingDeltaX), y: Float(nsEvent.scrollingDeltaY))
        publishEvent(event)
    }
}

extension Window: MTKViewDelegate {
    func draw(in view: MTKView) {
        let currentTime = Time.currentTime
        let deltaTime = currentTime - lastFrameTime
        lastFrameTime = currentTime
        
        windowDelegate?.onUpdate(deltaTime: deltaTime)
    }
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        // NSWindowDelegate::WindowDidResize includes the status bar height, use this method instead
        let event = WindowViewResizeEvent(width: UInt32(size.width), height: UInt32(size.height))
        publishEvent(event)
    }
}
