//
//  Context.swift
//  Palico
//
//  Created by Junhao Wang on 12/25/21.
//

protocol ContextDelegate {
    func initialize()
    func activate()
    func deinitialize()
    
    var isAppRunning: Bool { get }
    var isAppActive:  Bool { get }
}

public struct Context {
    private static let contextDelegate = CocoaContext()
    
    public static var isAppRunning: Bool { get {
        return Self.contextDelegate.isAppRunning
    }}
    
    public static var isAppActive: Bool { get {
        return Self.contextDelegate.isAppActive
    }}
    
    public static func initialize() {
        return Self.contextDelegate.initialize()
    }
    
    public static func activate() {
        return Self.contextDelegate.activate()
    }
    
    public static func deinitialize() {
        return Self.contextDelegate.deinitialize()
    }
    
    private init() { }
}
