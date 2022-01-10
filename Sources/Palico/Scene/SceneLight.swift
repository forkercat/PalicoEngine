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
                position: Float3 = [3, 3, 0],
                rotation: Float3 = [0, 0, 0]) {
        
        let defaultRotation: Float3 = (type == .dirLight || type == .spotLight) ? [0, 0, Float(-45).toRadians] : rotation
        let defaultScale: Float3 = [0.2, 0.2, 0.2]
        
        super.init(name: name, position: position,
                   rotation: defaultRotation,
                   scale: defaultScale)
        
        addComponent(MeshRendererComponent(mesh: makeLightMesh(type: type)))
        addComponent(LightComponent(type: type))
    }
    
    public override func onUpdate(deltaTime ts: Timestep) {
        // TODO: Get LightComponent from ECS
        // Hard-coded
        if let transform: TransformComponent = getComponent() {
            if let lightComponent: LightComponent = getComponent() {
                lightComponent.light.position = transform.position
                lightComponent.light.direction = transform.forwardDirection  // points to Z
            }
        }
    }
    
    private func makeLightMesh(type: LightType) -> Mesh {
        var mesh: Mesh
        switch type {
        case .dirLight:
            mesh = MeshFactory.makePrimitiveMesh(type: .cylinder)
        case .pointLight:
            mesh = MeshFactory.makePrimitiveMesh(type: .sphere)
        case .spotLight:
            mesh = MeshFactory.makePrimitiveMesh(type: .cone)
        case .ambientLight:
            mesh = MeshFactory.makePrimitiveMesh(type: .hemisphere)
        }
        return mesh
    }
}
