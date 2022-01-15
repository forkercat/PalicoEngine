//
//  Component+Light.swift
//  Palico
//
//  Created by Junhao Wang on 1/9/22.
//

public class LightComponent: Component {
    public var title: String { "Light" }
    public var enabled: Bool = true
    public static var icon: String { FAIcon.lightbulb }
    
    public var light: Light = DirectionalLight()
    
    public required init() {
        
    }
    
    public init(type: LightType) {
        setLightType(type)
    }
    
    public func setLightType(_ type: LightType) {
        let color = light.color
        let intensity = light.intensity
        
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
        
        light.color = color
        light.intensity = intensity
    }
}
