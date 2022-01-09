//
//  Component.swift
//  Palico
//
//  Created by Junhao Wang on 1/2/22.
//

import MathLib
import MetalKit

public protocol Component: AnyObject {
    var title: String { get }
}

// Components

// Tag
public class TagComponent: Component {
    public var title: String { "Tag" }
    public var tag: String = "Default"
}

// Transform
public class TransformComponent: Component {
    public var title: String { "Transform" }
    
    public var position: Float3 = [0, 0, 0]
    public var rotation: Float3 = [0, 0, 0] {
        didSet {
            let rotationMatrix = Float4x4(rotationZXY: rotation)  // Follow Unity (Extransic Order)
            quaternion = Quaternion(rotationMatrix)
        }
    }
    public var scale: Float3 = [1, 1, 1]
    
    public var modelMatrix: Float4x4 { get {
        let T = Float4x4(translation: position)
        let R = Float4x4(quaternion)
        let S = Float4x4(scale: scale)
        return T * R * S
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
}

// MeshRenderer
public class MeshRendererComponent: Component {
    public var title: String { "MeshRenderer" }
    
    // Mesh
    var mesh: Mesh
    
    // Material
    public var tintColor: Color
    
    init(mesh: Mesh) {
        self.mesh = mesh
        self.tintColor = .white
    }
}

// Camera
public class CameraComponent: Component {
    public var title: String { "Camera" }
    // TODO: SceneCamera
}

// Light
public class LightComponent: Component {
    public var title: String { "Light" }
    
    public var light: Light
    
    init(type: LightType) {
        switch type {
        case .dirLight:
            light = DirectionalLight()
        case .pointLight:
            light = PointLight()
        case .spotLight:
            light = SpotLight()
        case .ambientLight:
            light = AmbientLight()
        }
    }
}
