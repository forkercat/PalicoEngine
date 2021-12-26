//
//  Context.swift
//  Palico
//
//  Created by Junhao Wang on 12/25/21.
//

protocol ContextDelegate {
    var isAppRunning: Bool { get }
    var isAppActive:  Bool { get }
    var currentTime:  Timestep { get }
    
    func initialize()
    func activate()
    func deinitialize()
}

public struct Context {
    private static let contextDelegate = CocoaContext()
    
    public static var currentTime: Timestep { get {
        return Self.contextDelegate.currentTime
    }}
    
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
