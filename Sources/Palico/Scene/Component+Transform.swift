//
//  Component+Transform.swift
//  Palico
//
//  Created by Junhao Wang on 1/9/22.
//

import MathLib

public class TransformComponent: Component {
    public var title: String { "Transform" }
    public var enabled: Bool = true {
        didSet {
            enabled = true
            Log.error("You cannot set transform component status! Skipping")
        }
    }
    public static var icon: String { FAIcon.expandArrowsAlt }
    
    public var position: Float3 = [0, 0, 0]
    public var rotation: Float3 = [0, 0, 0] {
        didSet {
            let rotationMatrix = Float4x4(rotationXYZ: rotation)
//            let rotationMatrix = Float4x4(rotationZXY: rotation)  // Follow Unity (Extransic Order)
            quaternion = Quaternion(rotationMatrix)
        }
    }
    public var scale: Float3 = [1, 1, 1]
    
    public var modelMatrix: Float4x4 { get {
        let T = Float4x4(translation: position)
        let R = Float4x4(quaternion)
        let S = Float4x4(scale: scale)
        return mul(T, mul(R, S))
    }}
    
    public var rightDirection: Float3 { get {    // X
        return quaternion.act(Float3.right)
    }}
    public var upDirection: Float3 { get {       // Y
        return quaternion.act(Float3.up)
    }}
    public var forwardDirection: Float3 { get {  // Z
        return quaternion.act(Float3.forward)
    }}
    
    // Used quaternion internally
    private var quaternion = Quaternion()
    
    public required init() { }
}
