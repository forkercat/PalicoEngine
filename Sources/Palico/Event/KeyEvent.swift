//
//  KeyEvent.swift
//  Palico
//
//  Created by Junhao Wang on 12/19/21.
//

public protocol KeyEvent: Event {
    var key: Key { get }
}

// KeyPressed
public class KeyPressedEvent: KeyEvent {
    public static var categoryFlags: EventCategory { get { [.keyboard, .input] } }
    public static var staticEventType: EventType { get { .keyPressed } }
    
    public var eventType: EventType { get { Self.staticEventType } }
    public var handled: Bool = false
    
    public let key: Key
    public let repeatCount: UInt32
    
    public init(keyCode: KeyCode, repeatCount: UInt32) {
        key = Key(rawValue: keyCode) ?? .unknown
        self.repeatCount = repeatCount
    }
    
    public var toString: String {
        get { "[Event] type=KeyPressed, key=\(key), repeat=\(repeatCount), handled=\(handled)" }
    }
}

// KeyReleased
public class KeyReleasedEvent: KeyEvent {
    public static var categoryFlags: EventCategory { get { [.keyboard, .input] } }
    public static var staticEventType: EventType { get { .keyReleased } }
    
    public var eventType: EventType { get { Self.staticEventType } }
    public var handled: Bool = false
    
    public let key: Key
    
    public init(keyCode: KeyCode) {
        key = Key(rawValue: keyCode) ?? .unknown
    }
    
    public var toString: String {
        get { "[Event] type=KeyReleased, key=\(key), handled=\(handled)" }
    }
}

// CharTyped
public class CharTypedEvent: Event {
    public static var categoryFlags: EventCategory { get { [.keyboard, .input] } }
    public static var staticEventType: EventType { get { .charTyped } }
    
    public var eventType: EventType { get { Self.staticEventType } }
    public var handled: Bool = false
    
    public let char: CharCode
    
    public init(char: CharCode) {
        self.char = char
    }
    
    public var toString: String {
        get { "[Event] type=KeyTyped, char=\(char)), handled=\(handled)" }
    }
}
