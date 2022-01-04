//
//  Component.swift
//  Palico
//
//  Created by Junhao Wang on 1/2/22.
//

import MathLib
import simd
import MetalKit

public protocol Component {
    var title: String { get }
}

// Components

// Tag
public class TagComponent: Component {
    public var title: String { "Tag" }
    public var tag: String = "Default"
}

public typealias Quaternion = simd_quatf

// Transform
public class TransformComponent: Component {
    public var title: String { "Transform" }
    
    public var position: Float3 = [0, 0, 0]
    public var rotation: Float3 = [0, 0, 0] {
        didSet {
            let rotationMatrix = Float4x4(rotation: rotation)
            quaternion = Quaternion(rotationMatrix)
        }
    }
    public var scale: Float3 = [1, 1, 1]
    
    public var quaternion = Quaternion()
    public var modelMatrix: Float4x4 { get {
        let T = Float4x4(translation: position)
        let R = Float4x4(quaternion)
        let S = Float4x4(scale: scale)
        return T * R * S
    }}
}

// MeshRenderer
public class MeshRendererComponent: Component {
    public var title: String { "MeshRenderer" }
    
    // Mesh
    var mesh: Mesh
    // Material
    
    init(mesh: Mesh) {
        self.mesh = mesh
    }
    
    func onRender(encoder: MTLRenderCommandEncoder) {
        encoder.setVertexBuffer(mesh.nativeMesh.vertexBuffers[0].buffer, offset: 0, index: 0)
        for submesh in mesh.submeshes {
            encoder.drawIndexedPrimitives(type: .triangle,
                                          indexCount: submesh.nativeSubmesh.indexCount,
                                          indexType: submesh.nativeSubmesh.indexType,
                                          indexBuffer: submesh.nativeSubmesh.indexBuffer.buffer,
                                          indexBufferOffset: 0)
        }
    }
}

// Camera
public class CameraComponent: Component {
    public var title: String { "Camera" }
}

