//
//  CocoaWindow.swift
//  Palico
//
//  Created by Junhao Wang on 12/25/21.
//

import Cocoa

class CocoaWindow: Window {
    var title: String { nsWindow.title }
    var width: Int { Int(nsWindow.contentView?.bounds.width ?? 0) }
    var height: Int { Int(nsWindow.contentView?.bounds.height ?? 0) }
    var isMinimized: Bool { nsWindow.isMiniaturized }
    
    weak var windowDelegate: WindowDelegate? = nil
    
    let nsWindow: NSWindow
    let vc: ViewController
    
    required init(descriptor: WindowDescriptor) {
        Log.info("Initializing Cocoa window: \(descriptor.title) \(descriptor.width) x \(descriptor.height)")
        
        // View
        vc = ViewController()
        defer {
            vc.mouseEventCallback = onMouseEvent
            vc.viewDrawCallback = onViewDraw
            vc.viewResizeCallback = onViewResize
        }

        // NSWindow
        nsWindow = NSWindow(contentRect: NSRect(x: 0, y: 0, width: Int(descriptor.width), height: Int(descriptor.height)),
                            styleMask: [.miniaturizable, .closable, .resizable, .titled],
                            backing: .buffered,
                            defer: false)
        nsWindow.title = descriptor.title
        nsWindow.center()
        nsWindow.contentView = vc.view
        nsWindow.acceptsMouseMovedEvents = true
        nsWindow.makeKeyAndOrderFront(nil)
        nsWindow.makeMain()
        
        // Add a tracking area to capture move events within the window;
        // otherwise, location would become screen coord when mouse is outside.
        let trackingArea = NSTrackingArea(rect: .zero, options: [.mouseMoved, .inVisibleRect, .activeAlways],
                                          owner: vc.view, userInfo: nil)
        vc.view.addTrackingArea(trackingArea)
        
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
