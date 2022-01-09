//
//  Light.swift
//  Palico
//
//  Created by Junhao Wang on 1/8/22.
//

import MathLib

public protocol Light {
    var type: LightType { get }
    var position: Float3 { get set }
    var color: Float4 { get set }
    var intensity: Float { get set }
    var direction: Float3 { get set }
    
    var lightData: LightData { get }
}

public struct DirectionalLight: Light {
    public var type: LightType { .dirLight }
    public var position: Float3 = [0, 0, 0]
    public var color: Color = .white
    public var intensity: Float = 1.0
    public var direction: Float3 = normalize([-1, -1, 0])
    
    public var lightData: LightData {
        var data = LightData()
        data.type = type
        data.position = position
        data.color = color
        data.intensity = intensity
        data.direction = direction

        return data
    }
}

public struct PointLight: Light {
    public var type: LightType { .pointLight }
    public var position: Float3 = [0, 0, 0]
    public var color: Color = .white
    public var intensity: Float = 1.0
    public var direction: Float3 = normalize([-1, -1, 0])
    
    public var lightData: LightData {
        var data = LightData()
        data.type = type
        data.position = position
        data.color = color
        data.intensity = intensity
        data.direction = direction
        
        return data
    }
}

public struct SpotLight: Light {
    public var type: LightType { .spotLight }
    public var position: Float3 = [0, 0, 0]
    public var color: Color = .white
    public var intensity: Float = 1.0
    public var direction: Float3 = normalize([-1, -1, 0])
    
    public var lightData: LightData {
        var data = LightData()
        data.type = type
        data.position = position
        data.color = color
        data.intensity = intensity
        data.direction = direction
        
        return data
    }
}

public struct AmbientLight: Light {
    public var type: LightType { .ambientLight }
    public var position: Float3 = [0, 0, 0]
    public var color: Color = .white
    public var intensity: Float = 1.0
    public var direction: Float3 = normalize([-1, -1, 0])
    
    public var lightData: LightData {
        var data = LightData()
        data.type = type
        data.position = position
        data.color = color
        data.intensity = intensity
        data.direction = direction
        
        return data
    }
}
