//
//  ShaderDataBridge.swift
//  Palico
//
//  Created by Junhao Wang on 1/6/22.
//

import MathLib

// At this time, we need to manually keep this file consistent
// with shader files (Common.metal).

// Index
enum Attribute: Int {
    case position        = 0
    case normal          = 1
    case uv              = 2
}

enum BufferIndex: Int {
    case vertices        = 0
    case vertexUniform   = 11
    case fragmentUniform = 12
    case lights          = 13
    // skybox...
}

enum TextureIndex: Int {
    case baseColor       = 0
    case normal          = 1
    case roughness       = 2
    case metallic        = 3
    case ao              = 4
}

// Uniforms
struct VertexUniformData {
    var modelMatrix:     Float4x4 = .identity
    var viewMatrix:      Float4x4 = .identity
    var projectionMatrx: Float4x4 = .identity
    var normalMatrix:    Float3x3 = .identity
}

struct FragmentUniformData {
    var tintColor: Color = .white
    // light count
    // eyePos
}


