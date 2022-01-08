//
//  Time.swift
//  Palico
//
//  Created by Junhao Wang on 12/17/21.
//

import Foundation

public typealias Timestep = Float

extension Timestep {
    public var toMilliSeconds: Timestep {
        get { self * 1000.0 }
    }
}

public enum Time {
    public private(set) static var lastFrameTime: Double = currentTime
    
    public static var currentTime: Double { get {
        PlatformContext.currentTime
        
    }}
    
    public static var deltaTime: Timestep { get {
        _deltaTime
    }}
    
    private static var _deltaTime: Timestep = 0.0
    
    // Used only internally - cannot be called by client (eg. Editor)
    internal static func update() {
        let time: Double = currentTime
        _deltaTime = Timestep(time - lastFrameTime)
        lastFrameTime = time
    }
}
