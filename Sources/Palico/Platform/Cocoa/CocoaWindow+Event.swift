//
//  CocoaWindow+Event.swift
//  Palico
//
//  Created by Junhao Wang on 1/2/22.
//

import Cocoa

extension CocoaWindow {
    func publishEvent(_ event: Event) {
        windowDelegate?.onEvent(event: event)
    }
    
    func onMouseEvent(event: NSEvent) {
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
    
    func onKeyEvent(event: NSEvent) {
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
}
