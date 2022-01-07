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
        float3 normal;
        float2 uv;
    };

    // Vertex
    vertex VertexOut vertex_main(
            const VertexIn in                          [[ stage_in ]], 
            constant VertexUniformData& vertexUniforms [[ buffer(Buffer::vertexUniform) ]]) {
        
        VertexOut out;
        out.position = in.position;
        out.normal = in.normal;
        out.uv = in.uv;
        return out;
    }

    // Fragment
    fragment float4 fragment_main(
            const VertexOut in                             [[ stage_in ]],
            constant FragmentUniformData& fragmentUniforms [[ buffer(Buffer::fragmentUniform) ]]) {
        
        return float4(in.uv.x, in.uv.y, 0.8, 1.0);
    }

}  // Palico
