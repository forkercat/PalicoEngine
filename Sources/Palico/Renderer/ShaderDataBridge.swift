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
public enum Attribute: Int {
    case position        = 0
    case normal          = 1
    case uv              = 2
}

public enum BufferIndex: Int {
    case vertices        = 0
    case vertexUniform   = 11
    case fragmentUniform = 12
    case lightData       = 13
    // skybox...
}

public enum TextureIndex: Int {
    case baseColor       = 0
    case normal          = 1
    case roughness       = 2
    case metallic        = 3
    case ao              = 4
}

// Uniforms
public struct VertexUniformData {
    var modelMatrix:     Float4x4 = .identity
    var viewMatrix:      Float4x4 = .identity
    var projectionMatrx: Float4x4 = .identity
    var normalMatrix:    Float3x3 = .identity
}

public struct FragmentUniformData {
    var tintColor: Color4 = .white
    var cameraPosition: Float3 = [0, 0, 0]
    var lightCount: Int32 = 0
    var noLight: Int32 = 0
}

// Light
public enum LightType: Int32 {
    case dirLight       = 0
    case pointLight     = 1
    case spotLight      = 2
    case ambientLight   = 3
    
    public static let typeStrings: [String] = [
        "Directional", "Point", "Spot", "Ambient"
    ]
}

public struct LightData {
    var type: Int32 = LightType.dirLight.rawValue
    var position: Float3 = [0, 0, 0]
    var color: Color3 = .white
    var intensity: Float = 1.0
    var direction: Float3 = normalize([1, 1, 1])
    var attenuation: Float3 = [1, 0, 0]
    var coneAngle: Float = 0
    var coneDirection: Float3 = [0, 0, 0]
    var coneAttenuation: Float3 = [1, 0, 0]
}
