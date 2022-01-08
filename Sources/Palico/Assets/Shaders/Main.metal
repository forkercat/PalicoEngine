//
//  Main.metal
//  Palico
//
//  Created by Junhao Wang on 12/28/21.
//

using namespace metal;

namespace Palico {
    
    // In
    struct VertexIn {
        float4 position   [[ attribute(Position) ]];
        float3 normal     [[ attribute(Normal) ]];
        float2 uv         [[ attribute(UV) ]];
    };

    // Out
    struct VertexOut {
        float4 position   [[ position ]];
        float2 uv;
        float3 worldNormal;
        float3 worldPosition;
    };

    // Vertex
    vertex VertexOut vertex_main(
            const VertexIn in                          [[ stage_in ]], 
            constant VertexUniformData& vertexUniform  [[ buffer(Buffer::vertexUniform) ]]) {
    
        float4 positionOS = in.position;
        float4 positionWS = vertexUniform.modelMatrix * positionOS;

        float4 output = vertexUniform.projectionMatrix * vertexUniform.viewMatrix * positionWS;

        VertexOut out {
            .position = output,
            .worldNormal = vertexUniform.normalMatrix * in.normal,
            .worldPosition = positionWS.xyz,
            .uv = in.uv
        };
        return out;
    }

    // Fragment
    fragment float4 fragment_main(
            const VertexOut in                             [[ stage_in ]],
            constant FragmentUniformData& fragmentUniform  [[ buffer(Buffer::fragmentUniform) ]]) {
        
        // return float4(in.uv.x, in.uv.y, 0.8, 1.0);
        return fragmentUniform.tintColor;
    }

}  // Palico
