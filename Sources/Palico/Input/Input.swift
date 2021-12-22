//
//  Input.swift
//  Palico
//
//  Created by Junhao Wang on 12/19/21.
//

import MathLib

public enum Input {
    public static func isKeyPressed(key: Key) -> Bool {
        let state = Application.instance?.window.lookupKeyState(key: key)
        return state == .pressed || state == .repeated
    }
    
    public static func isMouseButtonPressed(button: Mouse) -> Bool {
        let state = Application.instance?.window.lookupMouseButtonState(mouse: button)
        return state == .pressed
    }
    
    public static var mousePos: Float2 {
        get {
            let position = Application.instance?.window.lookupMousePosition() ?? Float2(x: 0, y: 0)
            return position
        }
    }
}
