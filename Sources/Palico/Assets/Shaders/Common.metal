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
        lights            = 13
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
    };

}  // Palico
