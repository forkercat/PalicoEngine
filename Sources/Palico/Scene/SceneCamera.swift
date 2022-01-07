//
//  SceneCamera.swift
//  Palico
//
//  Created by Junhao Wang on 1/6/22.
//

import MathLib

class SceneCamera: Camera {
    var viewMatrix: Float4x4 { .identity }
    var projectionMatrix: Float4x4 { .identity }
}
