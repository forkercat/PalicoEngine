//
//  Common.metal
//  Palico
//
//  Created by Junhao Wang on 1/6/22.
//

#include <metal_stdlib>
using namespace metal;

namespace Palico {
    
    // Index
    enum Attribute {
        Position          = 0,
        Normal            = 1,
        UV                = 2
    };

    enum class Buffer {
        vertices          = 0,
        vertexUniform     = 11,
        fragmentUniform   = 12,
        lightData         = 13
    };

    enum Texture {
        BaseColorTexture  = 0,
        NormalTexture     = 1,
        RoughnessTexture  = 2,
        MetallicTexture   = 3,
        AOTexture         = 4
    };

    // Uniforms
    struct VertexUniformData {
        float4x4 modelMatrix;
        float4x4 viewMatrix;
        float4x4 projectionMatrix;
        float3x3 normalMatrix;
    };

    struct FragmentUniformData {
        float4 tintColor;
        uint   lightCount;
        float3 cameraPosition;
    };
    
    // Light
    enum LightType {
        NoLight           = 0,
        DirLight          = 1,
        PointLight        = 2,
        SpotLight         = 3,
        AmbientLight      = 4
    };
    
    struct LightData {
        LightType type;
        float3    position;
        float4    color;
        float     intensity;
        float3    direction;
        float3    attenuation;
        float     coneAngle;
        float3    coneDirection;
        float3    coneAttenuation;
    };
        
}  // Palico
