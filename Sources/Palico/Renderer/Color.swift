//
//  Color.swift
//  Palico
//
//  Created by Junhao Wang on 1/6/22.
//

import MathLib

public typealias Color = Float4

extension Color {
    public static let white     = Color(1, 1, 1, 1)
    public static let black     = Color(1, 1, 1, 1)
    public static let red       = Color(1, 0, 0, 1)
    public static let green     = Color(0, 1, 0, 1)
    public static let blue      = Color(0, 1, 0, 1)
    public static let yellow    = Color(1, 1, 0, 1)
    public static let cyan      = Color(0, 1, 1, 1)
    public static let magneta   = Color(1, 0, 1, 1)
    
    public static let grey      = Color(0.5, 0.5, 0.5, 1)
    public static let lightGrey = Color(0.7, 0.7, 0.7, 1)
    
    public var r: Float { x }
    public var g: Float { y }
    public var b: Float { z }
    public var a: Float { w }
    
    public init(r: Float, g: Float, b: Float, a: Float = 1.0) {
        self.init(r, g, b, a)
    }
}
