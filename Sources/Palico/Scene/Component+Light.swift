//
//  Component+Light.swift
//  Palico
//
//  Created by Junhao Wang on 1/9/22.
//

public class LightComponent: Component {
    public var title: String { "Light" }
    
    public var light: Light = DirectionalLight()
    
    public required init() {
        
    }
    
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
