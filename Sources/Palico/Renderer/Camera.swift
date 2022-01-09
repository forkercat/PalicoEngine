//
//  Camera.swift
//  Palico
//
//  Created by Junhao Wang on 1/6/22.
//

import MathLib

public protocol Camera: AnyObject {
    var position: Float3 { get }
    var viewMatrix: Float4x4 { get }
    var projectionMatrix: Float4x4 { get }
}
