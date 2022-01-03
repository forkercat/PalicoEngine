//
//  CocoaWindow+Callback.swift
//  Palico
//
//  Created by Junhao Wang on 1/2/22.
//

import Cocoa

extension CocoaWindow {
    func keyEventCallback(nsEvent: NSEvent) {
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
    
    func modifierChangedEventCallback(nsEvent: NSEvent) {
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
    
    func charTypedEventCallback(nsEvent: NSEvent) {
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
    
    func mouseButtonEventCallback(nsEvent: NSEvent) {
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
    
    func mouseMovedEventCallback(nsEvent: NSEvent) {
        let cursorLocation = nsEvent.locationInWindow
        let event = MouseMovedEvent(x: Float(cursorLocation.x), y: Float(cursorLocation.y))
        publishEvent(event)
    }
    
    func mouseScrollWheelEventCallback(nsEvent: NSEvent) {
        let event = MouseScrolledEvent(x: Float(nsEvent.scrollingDeltaX), y: Float(nsEvent.scrollingDeltaY))
        publishEvent(event)
    }
}
