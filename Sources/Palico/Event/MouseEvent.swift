//
//  MouseEvent.swift
//  Palico
//
//  Created by Junhao Wang on 12/19/21.
//

internal protocol MouseEvent: Event { }

// MouseMoved
public class MouseMovedEvent: MouseEvent {
    public static var categoryFlags: EventCategory { [.mouse, .input] }
    public static var staticEventType: EventType { .mouseMoved }
    
    public var eventType: EventType { Self.staticEventType }
    public var handled: Bool = false
    
    public let xpos: Float
    public let ypos: Float
    
    public init(x xpos: Float, y ypos: Float) {
        self.xpos = xpos
        self.ypos = ypos
    }
    
    public var toString: String {
        "[Event] type=MouseMoved, position=(\(xpos), \(ypos)), handled=\(handled)"
    }
}

// MouseScrolled
public class MouseScrolledEvent: MouseEvent {
    public static var categoryFlags: EventCategory { [.mouse, .input] }
    public static var staticEventType: EventType { .mouseScrolled }
    
    public var eventType: EventType { Self.staticEventType }
    public var handled: Bool = false
    
    public let xoffset: Float
    public let yoffset: Float
    
    public init(x xoffset: Float, y yoffset: Float) {
        self.xoffset = xoffset
        self.yoffset = yoffset
    }
    
    public var toString: String {
        "[Event] type=MouseScrolled, offset=(\(xoffset), \(yoffset)), handled=\(handled)"
    }
}

internal protocol MouseButtonEvent: Event {
    var button: Mouse { get }
}

// MouseButtonPressed
public class MouseButtonPressedEvent: MouseButtonEvent {
    public static var categoryFlags: EventCategory { [.mouseButton, .input] }
    public static var staticEventType: EventType { .mouseButtonPressed }
    
    public var eventType: EventType { Self.staticEventType }
    public var handled: Bool = false
    
    public let button: Mouse
    
    public init(mouseCode: MouseCode) {
        self.button = Mouse(rawValue: mouseCode) ?? .unknown
    }
    
    public var toString: String {
        "[Event] type=MouseButtonPressed, button=\(button), handled=\(handled)"
    }
}

// MouseButtonReleased
public class MouseButtonReleasedEvent: MouseButtonEvent {
    public static var categoryFlags: EventCategory { [.mouseButton, .input] }
    public static var staticEventType: EventType { .mouseButtonReleased }
    
    public var eventType: EventType { Self.staticEventType }
    public var handled: Bool = false
    
    public let button: Mouse
    
    public init(mouseCode: MouseCode) {
        self.button = Mouse(rawValue: mouseCode) ?? .unknown
    }
    
    public var toString: String {
        "[Event] type=MouseButtonReleased, button=\(button), handled=\(handled)"
    }
}
