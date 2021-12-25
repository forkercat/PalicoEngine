//
//  Input.swift
//  Palico
//
//  Created by Junhao Wang on 12/19/21.
//

import AppKit
import MathLib

public enum Input {
    static var keyMap: [Bool] = [Bool](repeating: false, count: Key.maxKeyCode)
    static var mouseMap: [Bool] = [Bool](repeating: false, count: Mouse.maxMouseCode)
    
    public static func isPressed(key: Key) -> Bool {
        let keycode = Int(key.rawValue)
        keyMap[keycode] = keyMap[keycode] && NSApp.isActive          // set false when the app is hidden
        return keyMap[keycode]
    }
    
    public static func isPressed(mouse: Mouse) -> Bool {
        let mousecode = Int(mouse.rawValue)
        mouseMap[mousecode] = mouseMap[mousecode] && NSApp.isActive  // set false when the app is hidden
        return mouseMap[mousecode]
    }
    
    public static var mousePos: Float2 {
        get {
            // Becomes (0, 0) when app is not active (hidden) - not sure if it causes issue yet
            let locationInWindow = NSApp.mainWindow?.convertPoint(fromScreen: NSEvent.mouseLocation) ?? NSPoint(x: 0, y: 0)
            return Float2(locationInWindow.x, locationInWindow.y)
        }
    }
}
