//
//  CocoaWindow.swift
//  Palico
//
//  Created by Junhao Wang on 12/25/21.
//

import Cocoa
import MetalKit

@available(OSX 10.11, *)
class CocoaWindow: Window {
    var title:          String { nsWindow.title }
    var width:          UInt32 { view.width }
    var height:         UInt32 { view.height }
    var isMinimized:    Bool   { nsWindow.isMiniaturized }
    var view:           View
    
    weak var windowDelegate: WindowDelegate? = nil
    
    private var lastFrameTime: Timestep = Time.currentTime
    
    private let nsWindow: NSWindow
    
    required init(descriptor: WindowDescriptor) {
        Log.info("Initializing Cocoa window: \(descriptor.title) \(descriptor.width) x \(descriptor.height)")
        
        // View
        view = CocoaView()
        defer { view.viewDelegate = self }
        let mtkView: MTKView = (view as! CocoaView).nativeView
        
        // NSWindow
        nsWindow = NSWindow(contentRect: NSRect(x: 0, y: 0, width: Int(descriptor.width), height: Int(descriptor.height)),
                            styleMask: [.miniaturizable, .closable, .resizable, .titled],
                            backing: .buffered,
                            defer: false)
        nsWindow.title = descriptor.title
        nsWindow.center()
        nsWindow.contentView = mtkView
        nsWindow.acceptsMouseMovedEvents = true
        nsWindow.makeKeyAndOrderFront(nil)
        nsWindow.makeMain()
        
        // Add a tracking area to capture move events within the window;
        // otherwise, location would become screen coord when mouse is outside.
        let trackingArea = NSTrackingArea(rect: .zero, options: [.mouseMoved, .inVisibleRect, .activeAlways],
                                          owner: mtkView, userInfo: nil)
        mtkView.addTrackingArea(trackingArea)
        
        // Add locao monitor for NSEvent
        NSEvent.addLocalMonitorForEvents(matching: [.any], handler: handleNSEvents)
    }
}

// View Delegate
@available(OSX 10.11, *)
extension CocoaWindow: ViewDelegate {
    func viewShouldStartDrawing(in view: View) {
        let currentTime = Time.currentTime
        let deltaTime = currentTime - lastFrameTime
        lastFrameTime = currentTime
        windowDelegate?.onUpdate(deltaTime: deltaTime, in: view)
    }
    
    func onViewResize(width: UInt32, height: UInt32) {
        // NSWindowDelegate.WindowDidResize includes the status bar height, use this method instead.
        let event = WindowViewResizeEvent(width: width, height: height)
        windowDelegate?.onEvent(event: event)
    }
}

// Event Publish
@available(OSX 10.11, *)
extension CocoaWindow {
    private func handleNSEvents(nsEvent: NSEvent) -> NSEvent? {
        let wantsCapture: Bool = ImGui_ImplOSX_HandleEvent(nsEvent, (view as! CocoaView).nativeView)
        
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
@available(OSX 10.11, *)
extension CocoaWindow {
    private func keyEventCallback(nsEvent: NSEvent) {
        switch nsEvent.type {
        case .keyDown:
            Input.updateKeyMap(with: true, on: nsEvent.keyCode)
            let event = KeyPressedEvent(keyCode: nsEvent.keyCode, repeat: nsEvent.isARepeat ? 1 : 0)
            publishEvent(event)
        case .keyUp:
            Input.updateKeyMap(with: false, on: nsEvent.keyCode)
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
        Input.updateKeyMap(with: flags.contains(.command), on: Key.command.rawValue)
        Input.updateKeyMap(with: flags.contains(.shift), on: Key.shift.rawValue)
        Input.updateKeyMap(with: flags.contains(.option), on: Key.option.rawValue)
        Input.updateKeyMap(with: flags.contains(.control), on: Key.control.rawValue)
        Input.updateKeyMap(with: flags.contains(.function), on: Key.function.rawValue)
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
            Input.updateMouseMap(with: true, on: MouseCode(nsEvent.buttonNumber))
            let event = MouseButtonPressedEvent(mouseCode: MouseCode(nsEvent.buttonNumber))
            publishEvent(event)
        case .leftMouseUp, .rightMouseUp, .otherMouseUp:
            Input.updateMouseMap(with: false, on: MouseCode(nsEvent.buttonNumber))
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
