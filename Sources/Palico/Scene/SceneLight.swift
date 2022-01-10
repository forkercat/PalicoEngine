//
//  SceneLight.swift
//  Palico
//
//  Created by Junhao Wang on 1/8/22.
//

import MathLib

public class SceneLight: GameObject {
    public init(name: String = "Scene Light",
                type: LightType = .dirLight,
                position: Float3 = [3, 3, 2],
                rotation: Float3 = [0, 0, 0]) {
        
        var defaultRotation: Float3 = rotation
        var defaultScale: Float3 = [0.2, 0.2, 0.2]
        
        if type == .dirLight || type == .spotLight {
            defaultRotation = [Float(-45).toRadians, Float(-90).toRadians, 0]
            defaultScale = [0.2, 0.3, 0.2]
        }
        
        super.init(name: name, position: position,
                   rotation: defaultRotation,
                   scale: defaultScale)
        
        addComponent(MeshRendererComponent(mesh: makeLightMesh(type: type)))
        addComponent(LightComponent(type: type))
    }
    
    public override func onUpdateEditor(deltaTime ts: Timestep) {
        updateLightComponentData()
    }
    
    private func updateLightComponentData() {
        if let lightComponent: LightComponent = getComponent() {
            let transform: TransformComponent = getComponent()!
            lightComponent.light.position = transform.position
            lightComponent.light.direction = -transform.upDirection  // points to -Y
        }
    }
    
    private func makeLightMesh(type: LightType) -> Mesh {
        var mesh: Mesh
        switch type {
        case .dirLight:
            mesh = MeshFactory.makePrimitiveMesh(type: .hemisphere)
        case .pointLight:
            mesh = MeshFactory.makePrimitiveMesh(type: .sphere)
        case .spotLight:
            mesh = MeshFactory.makePrimitiveMesh(type: .cone)
        case .ambientLight:
            mesh = MeshFactory.makePrimitiveMesh(type: .cube)
        }
        return mesh
    }
}
