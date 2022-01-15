//
//  SceneLight.swift
//  Palico
//
//  Created by Junhao Wang on 1/8/22.
//

import MathLib

public class SceneLight: GameObject {
    public init(_ scene: Scene,
                name: String = "Scene Light",
                type: LightType = .dirLight,
                position: Float3 = [3, 3, 2],
                rotation: Float3 = [0, 0, 0]) {
        
        var defaultRotation: Float3 = rotation
        var defaultScale: Float3 = [0.2, 0.2, 0.2]
        
        if type == .dirLight || type == .spotLight {
            defaultRotation = [Float(-45).toRadians, Float(-90).toRadians, 0]
            defaultScale = [0.2, 0.3, 0.2]
        }
        
        super.init(scene, name: name,
                   position: position,
                   rotation: defaultRotation,
                   scale: defaultScale)
        
        let meshRenderer = MeshRendererComponent()
        meshRenderer.setMesh(makeLightMeshType(type: type))
        addComponent(meshRenderer)
        
        addComponent(LightComponent(type: type))
    }
    
    public override func onUpdateEditor(deltaTime ts: Timestep) {
        super.onUpdateEditor(deltaTime: ts)
        updateLightComponentData()
    }
    
    public override func onUpdateRuntime(deltaTime ts: Timestep) {
        super.onUpdateRuntime(deltaTime: ts)
        updateLightComponentData()
    }
    
    private func updateLightComponentData() {
        let transform = getComponent(TransformComponent.self)  // guranteed
        if hasComponent(LightComponent.self) {
            let lightComponent = getComponent(LightComponent.self)
            lightComponent.light.position = transform.position
            lightComponent.light.direction = -transform.upDirection  // points to -Y
        }
    }
    
    private func makeLightMeshType(type: LightType) -> PrimitiveType {
        switch type {
        case .dirLight:
            return .hemisphere
        case .pointLight:
            return .sphere
        case .spotLight:
            return .cone
        case .ambientLight:
            return .cube
        }
    }
}
