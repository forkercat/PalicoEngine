//
//  CocoaInput.swift
//  Palico
//
//  Created by Junhao Wang on 12/25/21.
//

import Cocoa
import MathLib

class CocoaInput: InputDelegate {
    private var keyMap: [Bool] = [Bool](repeating: false, count: 512)
    private var mouseMap: [Bool] = [Bool](repeating: false, count: 10)
    
    var mousePos: Float2 {
        // Becomes (0, 0) when app is not active (hidden) - not sure if it causes issue yet
        let locationInWindow = NSApp.mainWindow?.convertPoint(fromScreen: NSEvent.mouseLocation) ?? NSPoint(x: 0, y: 0)
        return Float2(locationInWindow.x, locationInWindow.y)
    }
    
    init() { }
    
    func isPressed(key: Key) -> Bool {
        let keycode = Int(key.rawValue)
        keyMap[keycode] = keyMap[keycode] && NSApp.isActive  // set false when the app is hidden
        return keyMap[keycode]
    }
    
    func isPressed(mouse: Mouse) -> Bool {
        let mousecode = Int(mouse.rawValue)
        mouseMap[mousecode] = mouseMap[mousecode] && NSApp.isActive  // set false when the app is hidden
        return mouseMap[mousecode]
    }
    
    func updateKeyMap(with flag: Bool, on keyCode: KeyCode) {
        keyMap[Int(keyCode)] = flag
    }
    
    func updateMouseMap(with flag: Bool, on mouseCode: MouseCode) {
        mouseMap[Int(mouseCode)] = flag
    }
}
