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
            constant FragmentUniformData& fragmentUniform  [[ buffer(Buffer::fragmentUniform) ]],
            constant LightData* lightData                  [[ buffer(Buffer::lightData) ]]) {
        
        // return float4(in.worldNormal, 1.0);
        // return float4(in.worldPosition, 1.0);

        float3 normalWS = normalize(in.worldNormal);

        /*
        for (uint i = 0; i < fragmentUniform.lightCount; i++) {
            LightData light = lightData[i];
        }
        */

        LightData light0 = lightData[0];
        LightData light1 = lightData[1];

        float3 baseColor = float3(1, 1, 1);  // tintColor

        float3 diffuseColor = 0;

        // float3 lightDir = normalize(-light0.direction);
        // float3 lightDir = normalize(light1.position - in.worldPosition);
        float3 lightDir = normalize(float3(-1, 1, -1) - in.worldPosition);

        float diffuseIntensity = saturate(dot(normalWS, lightDir));  // NdotL

        // fragmentUniform.cameraPosition

        // return fragmentUniform.tintColor;
        // return float4(diffuseIntensity);
        // return float4(normalWS, 1.0);
        return fragmentUniform.tintColor;
    
    
    }

}  // Palico
