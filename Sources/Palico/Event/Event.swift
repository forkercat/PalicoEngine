//
//  Event.swift
//  Palico
//
//  Created by Junhao Wang on 12/19/21.
//

import Darwin

public enum EventUtils {
    // Check if an event's category (could be multiple values) has a specific category.
    public static func isInCategory(event: Event, category: EventCategory) -> Bool {
        return event.categoryFlags.contains(category)
    }
}

public enum EventType {
    case none
    case windowViewResize, windowClose
    case keyPressed, keyReleased, charTyped
    case mouseButtonPressed, mouseButtonReleased, mouseMoved, mouseScrolled
}

public struct EventCategory: OptionSet {
    public let rawValue: UInt8
    public init(rawValue: UInt8) { self.rawValue = rawValue }
    
    public static let none        = Self(rawValue: 1 << 0)
    public static let application = Self(rawValue: 1 << 1)
    public static let input       = Self(rawValue: 1 << 2)
    public static let keyboard    = Self(rawValue: 1 << 3)
    public static let mouse       = Self(rawValue: 1 << 4)
    public static let mouseButton = Self(rawValue: 1 << 5)
}

// Event
public protocol Event: AnyObject, CustomStringConvertible {
    static var staticEventType: EventType { get }
    var eventType: EventType { get }
    var categoryFlags: EventCategory { get }
    var handled: Bool { get set }
}

public typealias EventCallback<T> = (T) -> Bool where T: Event

// EventDispatcher
public class EventDispatcher {
    public var event: Event
    
    public init(event: Event) {
        self.event = event
    }
    
    @discardableResult
    public func dispatch<T>(callback: EventCallback<T>) -> Bool where T: Event {
        if event.eventType == T.staticEventType {
            event.handled = event.handled || callback(event as! T)
            return true
        }
        return false
    }
}
