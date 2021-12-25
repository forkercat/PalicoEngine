//
//  AppEvent.swift
//  Palico
//
//  Created by Junhao Wang on 12/19/21.
//

internal protocol AppEvent: Event { }

// WindowViewResize
public class WindowViewResizeEvent: AppEvent {
    public let width: UInt32
    public let height: UInt32
    
    public static var categoryFlags: EventCategory { get { [.application] } }
    public static var staticEventType: EventType { get { .windowViewResize } }
    public var eventType: EventType { get { Self.staticEventType } }
    public var handled: Bool = false
    
    public init(width: UInt32, height: UInt32) {
        self.width = width
        self.height = height
    }
    
    public var toString: String {
        get { "[Event] type=WindowViewResize, size=(\(width) x \(height)), handled=\(handled)" }
    }
}

// WindowClose
public class WindowCloseEvent: AppEvent {
    public static var categoryFlags: EventCategory { get { [.application] } }
    public static var staticEventType: EventType { get { .windowClose } }
    public var eventType: EventType { get { Self.staticEventType } }
    public var handled: Bool = false
    
    public init() { }
    
    public var toString: String {
        get { "[Event] type=WindowClose, handled=\(handled)" }
    }
}
