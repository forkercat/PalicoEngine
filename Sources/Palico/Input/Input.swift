//
//  Input.swift
//  Palico
//
//  Created by Junhao Wang on 12/19/21.
//

import MathLib

protocol InputDelegate {
    var mousePos: Float2 { get }
    
    func isPressed(key: Key) -> Bool
    func isPressed(mouse: Mouse) -> Bool
    
    func updateKeyMap(with flag: Bool, on keyCode: KeyCode)
    func updateMouseMap(with flag: Bool, on mouseCode: MouseCode)
}

public struct Input {
    private static let inputDelegate = CocoaInput()
    
    public static var mousePos: Float2 { get {
        return Self.inputDelegate.mousePos
    }}
    
    public static func isPressed(key: Key) -> Bool {
        return Self.inputDelegate.isPressed(key: key)
    }
    
    public static func isPressed(mouse: Mouse) -> Bool {
        return Self.inputDelegate.isPressed(mouse: mouse)
    }
    
    // Internal only
    static func updateKeyMap(with flag: Bool, on keyCode: KeyCode) {
        Self.inputDelegate.updateKeyMap(with: flag, on: keyCode)
    }
    
    static func updateMouseMap(with flag: Bool, on mouseCode: MouseCode) {
        Self.inputDelegate.updateMouseMap(with: flag, on: mouseCode)
    }
    
    private init() { }
}
