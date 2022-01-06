//
//  AppEvent.swift
//  Palico
//
//  Created by Junhao Wang on 12/19/21.
//

import MathLib

internal protocol AppEvent: Event { }

// WindowViewResize
public class WindowViewResizeEvent: AppEvent {
    public let size: Int2
    
    public static var staticEventType: EventType { .windowViewResize }
    
    public var eventType: EventType { Self.staticEventType }
    public var categoryFlags: EventCategory { [.application] }
    public var handled: Bool = false
    
    public init(size: Int2) {
        self.size = size
    }
    
    public var toString: String {
        "[Event] type=WindowViewResize, size=(\(size.width) x \(size.height)), handled=\(handled)"
    }
}

// WindowClose
public class WindowCloseEvent: AppEvent {
    public static var staticEventType: EventType { .windowClose }
    
    public var categoryFlags: EventCategory { [.application] }
    public var eventType: EventType { Self.staticEventType }
    public var handled: Bool = false
    
    public init() { }
    
    public var toString: String {
        "[Event] type=WindowClose, handled=\(handled)"
    }
}
