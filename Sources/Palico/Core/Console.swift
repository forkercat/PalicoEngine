//
//  Console.swift
//  Palico
//
//  Created by Junhao Wang on 1/8/22.
//

import Foundation

public class Console {
    public struct Message {
        public enum Level: Int {
            case debug = 0
            case info  = 1
            case warn  = 2
            case error = 3
            
            public var str: String {
                switch self {
                case .debug:  return Self.levelStrings[0]
                case .info:   return Self.levelStrings[1]
                case .warn:   return Self.levelStrings[2]
                case .error:  return Self.levelStrings[3]
                }
            }
            
            public static let levelStrings: [String] = ["DEBUG", "INFO", "WARN", "ERROR"]
            public static var numLevels: Int = levelStrings.count
        }
        
        public var timestamp: String = "00:00:00.000"
        public var level: Level = .info
        public var content: String = ""
        
        public var str: String { get {
            "[\(timestamp)] \(level.str) - \(content)"
        }}
    }
    
    private static let maxMessageCount: Int = 30
    private static var messages: [Message?] = [Message?](repeating: nil, count: maxMessageCount)
    private static var start: Int = 0
    private static var end: Int = 0
    public private(set) static var numMessages: Int  = 0
    
    private static let dateFormatter: DateFormatter = DateFormatter()
    private static let timePattern = "hh:mm:ss.SSS"
    
    private init() {
        
    }
    
    public static func initialize() {
        dateFormatter.dateFormat = timePattern
        clear()
    }
    
    public static func getMessageList() -> [Message?] {
        return messages
    }
    
    private static var outputCursor: Int = start
    
    public static func nextMessage() -> Message? {
        guard outputCursor != end else {  // including the case where numMessages == 0
            outputCursor = start // reset
            return nil
        }
        
        let msg = messages[outputCursor]
        outputCursor = (outputCursor + 1) % maxMessageCount
        return msg
    }
    
    public static func clear() {
        numMessages = 0
        start = 0
        end = 0
        outputCursor = start
        for index in messages.indices {
            messages[index] = nil
        }
    }
    
    // [S(E), _, _, _, _]  // start
    // [S, E, _, _, _]
    // [S, _, _, _, E]  // numMessage = 5
    // [E, S, _, _, _]  // numMessage = 5 (kick out the earlist message)
    // [_, _, _, E, S]
    // [S, _, _, _, E]
    // [E, S, _, _, _]
    private static func addMessage(_ message: Message) {
        messages[end] = message
        numMessages = min(numMessages + 1, maxMessageCount)
        
        end = (end + 1) % maxMessageCount
        
        // Update start when end overlaps
        if start == end {
            start = (start + 1) % maxMessageCount
        }
    }
    
    @inline(__always)
    public static func debug(_ obj: Any) {  // debug
        debug("\(obj)")
    }
    
    @inline(__always)
    public static func debug(_ msg: String) {
        handleMessage(msg, level: .debug)
    }
    
    @inline(__always)
    public static func info(_ obj: Any) {  // info
        info("\(obj)")
    }
    
    @inline(__always)
    public static func info(_ msg: String) {
        handleMessage(msg, level: .info)
    }
    
    @inline(__always)
    public static func warn(_ obj: Any) {  // warn
        warn("\(obj)")
    }
    
    @inline(__always)
    public static func warn(_ msg: String) {
        handleMessage(msg, level: .warn)
    }
    
    @inline(__always)
    public static func error(_ obj: Any) {  // error
        error("\(obj)")
    }
    
    @inline(__always)
    public static func error(_ msg: String) {
        handleMessage(msg, level: .error)
    }
    
    private static func handleMessage(_ msg: String, level: Message.Level) {
        var message = Message()
        
        message.timestamp = dateFormatter.string(from: Date())
        message.level = level
        message.content = msg
        addMessage(message)
    }
}
