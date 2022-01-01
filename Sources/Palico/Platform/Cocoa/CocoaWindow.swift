//
//  CocoaWindow.swift
//  Palico
//
//  Created by Junhao Wang on 12/25/21.
//

import Cocoa

@available(OSX 10.11, *)
class CocoaWindow: Window {
    var title: String { nsWindow.title }
    var width: UInt32 { UInt32(nsWindow.contentView?.bounds.width ?? 0) }
    var height: UInt32 { UInt32(nsWindow.contentView?.bounds.height ?? 0) }
    var isMinimized: Bool { nsWindow.isMiniaturized }
    
    weak var windowDelegate: WindowDelegate? = nil
    
    private let nsWindow: NSWindow
    
    private let vc: ViewController
    
    required init(descriptor: WindowDescriptor) {
        Log.info("Initializing Cocoa window: \(descriptor.title) \(descriptor.width) x \(descriptor.height)")
        
        // View
        let nativeView: NSView = GraphicsContext.view as! NSView
        vc = ViewController()
        vc.view = nativeView
        defer {
            vc.setMouseEventCallback(onMouseEvent)
        }

        // NSWindow
        nsWindow = NSWindow(contentRect: NSRect(x: 0, y: 0, width: Int(descriptor.width), height: Int(descriptor.height)),
                            styleMask: [.miniaturizable, .closable, .resizable, .titled],
                            backing: .buffered,
                            defer: false)
        nsWindow.title = descriptor.title
        nsWindow.center()
        nsWindow.contentView = nativeView
        nsWindow.acceptsMouseMovedEvents = true
        nsWindow.makeKeyAndOrderFront(nil)
        nsWindow.makeMain()
        
        // Add a tracking area to capture move events within the window;
        // otherwise, location would become screen coord when mouse is outside.
        let trackingArea = NSTrackingArea(rect: .zero, options: [.mouseMoved, .inVisibleRect, .activeAlways],
                                          owner: nativeView, userInfo: nil)
        nativeView.addTrackingArea(trackingArea)
        
        // If we want to receive key events, we either need to be in the responder chain of the key view,
        // or else we can install a local monitor. The consequence of this heavy-handed approach is that
        // we receive events for all controls, not just Dear ImGui widgets. If we had native controls in our
        // window, we'd want to be much more careful than just ingesting the complete event stream, though we
        // do make an effort to be good citizens by passing along events when Dear ImGui doesn't want to capture.
        let eventMask: NSEvent.EventTypeMask = [.keyDown, .keyUp, .flagsChanged]
        NSEvent.addLocalMonitorForEvents(matching: eventMask) { [unowned self](event) -> NSEvent? in
            onKeyEvent(event: event)
            return event
        }
    }
}

// Event Publish
@available(OSX 10.11, *)
extension CocoaWindow {
    private func onMouseEvent(event: NSEvent) {
        ImGui_ImplOSX_HandleEvent(event, vc.view)
        
        switch event.type {
            // mouse button
        case .leftMouseDown, .leftMouseUp, .rightMouseDown, .rightMouseUp, .otherMouseDown, .otherMouseUp:
            mouseButtonEventCallback(nsEvent: event)
            
            // mouse moved
        case .mouseMoved, .leftMouseDragged, .rightMouseDragged, .otherMouseDragged:
            mouseMovedEventCallback(nsEvent: event)
            
            // scroll wheel
        case .scrollWheel:  // ScrollWheel
            mouseScrollWheelEventCallback(nsEvent: event)
            
        default:
            Log.warn("Unknown mouse event! - \(event)")
        }
    }
    
    private func onKeyEvent(event: NSEvent) {
        ImGui_ImplOSX_HandleEvent(event, vc.view)
        
        /*
        // Just handle the events. This will then dispatch to ImGuiLayer.onEvent,
        // in which events will be decided to dispatch or not to our application.
        // Original code:
        let wantsCapture: Bool = ImGui_ImplOSX_HandleEvent(nsEvent, nativeView)
        if nsEvent.type == .keyDown && wantsCapture {
            return nil  // do not dispatch keydown event when ImGUi wants to capture
        }
         */
        
        // Handled by us
        switch event.type {
        case .keyDown:
            keyEventCallback(nsEvent: event)
            charTypedEventCallback(nsEvent: event)
        case .keyUp:
            keyEventCallback(nsEvent: event)
        case .flagsChanged:
            modifierChangedEventCallback(nsEvent: event)
        default:
            Log.warn("Unknown mouse event! - \(event)")
        }
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

// ViewController (handle mouse events)
fileprivate typealias MouseEventCallback = (NSEvent) -> Void

@available(OSX 10.11, *)
fileprivate class ViewController: NSViewController {
    var mouseEventCallback: MouseEventCallback? = nil
    
    func setMouseEventCallback(_ callback: @escaping MouseEventCallback) {
        mouseEventCallback = callback
    }
    
    override func mouseMoved(with event: NSEvent) {
        mouseEventCallback?(event)
    }
    
    override func mouseDown(with event: NSEvent) {
        mouseEventCallback?(event)
    }
    
    override func mouseUp(with event: NSEvent) {
        mouseEventCallback?(event)
    }
    
    override func mouseDragged(with event: NSEvent) {
        mouseEventCallback?(event)
    }
    
    override func scrollWheel(with event: NSEvent) {
        mouseEventCallback?(event)
    }
}
