//
//  SceneLight.swift
//  Palico
//
//  Created by Junhao Wang on 1/8/22.
//

import MathLib

public class SceneLight: GameObject {
    public override init(name: String = "Scene Light",
                         position: Float3 = [0, 0, 0],
                         rotation: Float3 = [Float(-45.0).toRadians,
                                             Float(45.0).toRadians,
                                             0],
                         scale: Float3 = [1, 1, 1]) {
        super.init(name: name, position: position, rotation: rotation, scale: scale)
        
        let mesh = MeshFactory.getPrimitiveMesh(type: .sphere)
        addComponent(MeshRendererComponent(mesh: mesh))
        addComponent(LightComponent(type: .dirLight))
    }
    
    public init(name: String = "Scene Light",
                type: LightType = .dirLight,
                position: Float3 = [0, 0, 0],
                rotation: Float3 = [Float(-45.0).toRadians,
                                    Float(45.0).toRadians,
                                    0],
                scale: Float3 = [1, 1, 1]) {
        super.init(name: name, position: position, rotation: rotation, scale: scale)
        
        let mesh = MeshFactory.getPrimitiveMesh(type: .sphere)
        addComponent(MeshRendererComponent(mesh: mesh))
        addComponent(LightComponent(type: type))
    }
    
    public override func onUpdate(deltaTime ts: Timestep) {
        // TODO: Get LightComponent from ECS
        // Hard-coded
        if let transform = getComponent(at: 1) as? TransformComponent {
            if let lightComponent = getComponent(at: 3) as? LightComponent {
                lightComponent.light.position = transform.position
                lightComponent.light.direction = transform.forwardDirection  // points to Z
            }
        }
    }
}
