//
//  Color.swift
//  Palico
//
//  Created by Junhao Wang on 1/6/22.
//

import MathLib

public typealias Color3 = Float3
public typealias Color4 = Float4

extension Color3 {
    public static let white       = Color3(1, 1, 1)
    public static let black       = Color3(1, 1, 1)
    public static let red         = Color3(1, 0, 0)
    public static let green       = Color3(0, 1, 0)
    public static let blue        = Color3(0, 0, 1)
    public static let yellow      = Color3(1, 1, 0)
    public static let cyan        = Color3(0, 1, 1)
    public static let magneta     = Color3(1, 0, 1)
    
    public static let grey        = Color3(0.5, 0.5, 0.5)
    public static let lightGrey   = Color3(0.7, 0.7, 0.7)
    
    public static let lightYellow = Color3(ri: 238, gi: 205, bi: 151)
    public static let lightBlue   = Color3(ri: 59, gi: 148, bi: 240)
    
    public var r: Float { x }
    public var g: Float { y }
    public var b: Float { z }
    
    public init(r: Float, g: Float, b: Float) {
        self.init(r, g, b)
    }
    
    public init(ri: Int, gi: Int, bi: Int) {
        self.init(Float(ri) / Float(255), Float(gi) / Float(255), Float(bi) / Float(255))
    }
}

extension Color4 {
    public static let white       = Color4(Color3.white, 1)
    public static let black       = Color4(Color3.black, 1)
    public static let red         = Color4(Color3.red, 1)
    public static let green       = Color4(Color3.green, 1)
    public static let blue        = Color4(Color3.blue, 1)
    public static let yellow      = Color4(Color3.yellow, 1)
    public static let cyan        = Color4(Color3.cyan, 1)
    public static let magneta     = Color4(Color3.magneta, 1)
    
    public static let lightYellow = Color4(Color3.lightYellow, 1)
    public static let lightBlue   = Color4(Color3.lightBlue, 1)
    
    public static let grey        = Color4(Color3.grey, 1)
    public static let lightGrey   = Color4(Color3.lightGrey, 1)
    
    public var r: Float { x }
    public var g: Float { y }
    public var b: Float { z }
    public var a: Float { w }
    
    public var rgb: Color3 {
        return xyz
    }
    
    public init(r: Float, g: Float, b: Float, a: Float = 1.0) {
        self.init(r, g, b, a)
    }
    
    public init(ri: Int, gi: Int, bi: Int, ai: Int = 255) {
        self.init(Float(ri) / Float(255), Float(gi) / Float(255), Float(bi) / Float(255), Float(ai) / Float(255))
    }
}
