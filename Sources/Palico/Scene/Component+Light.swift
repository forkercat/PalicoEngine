//
//  Component+Light.swift
//  Palico
//
//  Created by Junhao Wang on 1/9/22.
//

import Foundation

public class LightComponent: Component {
    public var uuid: String = UUID().uuidString
    public var title: String { "Light" }
    public var gameObject: GameObject { MothECS.getGameObject(self) }
    
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

// Equatable/Hashable
extension LightComponent {
    public static func == (lhs: LightComponent, rhs: LightComponent) -> Bool {
        return lhs.uuid == rhs.uuid
    }
}

extension LightComponent {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
}
