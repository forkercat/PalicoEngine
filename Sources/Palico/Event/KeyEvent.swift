//
//  KeyEvent.swift
//  Palico
//
//  Created by Junhao Wang on 12/19/21.
//

internal protocol KeyEvent: Event {
    var key: Key { get }
}

// KeyPressed
public class KeyPressedEvent: KeyEvent {
    public static var staticEventType: EventType { .keyPressed }
    
    public var eventType: EventType { Self.staticEventType }
    public var categoryFlags: EventCategory { [.keyboard, .input] }
    public var handled: Bool = false
    
    public let key: Key
    public let repeatCount: UInt
    
    public init(keyCode: KeyCode, repeat repeatCount: UInt) {
        key = Key(rawValue: keyCode) ?? .unknown
        self.repeatCount = repeatCount
    }
    
    public var toString: String {
        "[Event] type=KeyPressed, key=\(key), repeat=\(repeatCount), handled=\(handled)"
    }
}

// KeyReleased
public class KeyReleasedEvent: KeyEvent {
    public static var staticEventType: EventType { .keyReleased }
    
    public var categoryFlags: EventCategory { [.keyboard, .input] }
    public var eventType: EventType { Self.staticEventType }
    public var handled: Bool = false
    
    public let key: Key
    
    public init(keyCode: KeyCode) {
        key = Key(rawValue: keyCode) ?? .unknown
    }
    
    public var toString: String {
        "[Event] type=KeyReleased, key=\(key), handled=\(handled)"
    }
}

// CharTyped
public class CharTypedEvent: Event {
    public static var staticEventType: EventType { .charTyped }
    
    public var categoryFlags: EventCategory { [.keyboard, .input] }
    public var eventType: EventType { Self.staticEventType }
    public var handled: Bool = false
    
    public let char: String
    
    public init(char: String) {
        self.char = char
    }
    
    public var toString: String {
        "[Event] type=KeyTyped, char=\(char)), handled=\(handled)"
    }
}
