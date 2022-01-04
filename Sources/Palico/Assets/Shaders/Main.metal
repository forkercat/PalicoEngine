//
//  Main.metal
//  Palico
//
//  Created by Junhao Wang on 12/28/21.
//

#include <metal_stdlib>
using namespace metal;

namespace Palico {
    struct VertexIn {
        float4 position   [[ attribute(0) ]];
        float3 normal     [[ attribute(1) ]];
        float2 uv         [[ attribute(2) ]];
    };
    
    struct VertexOut {
        float4 position [[ position ]];
        float3 normal;
        float2 uv;
    };
    
    vertex VertexOut vertex_main(VertexIn in [[ stage_in ]]) {
        VertexOut out;
        out.position = in.position;
        out.normal = in.normal;
        out.uv = in.uv;
        
        return out;
    }
    
    fragment float4 fragment_main(VertexOut in [[ stage_in ]]) {
        return float4(in.uv.x, in.uv.y, 0.8, 1.0);
    }
    
}
