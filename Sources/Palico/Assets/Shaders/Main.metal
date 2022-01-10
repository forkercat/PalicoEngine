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
        
        // Temp for light objects
        if (fragmentUniform.noLight) {
            return fragmentUniform.tintColor;
        }

        float3 normalWS = normalize(in.worldNormal);
        float3 tintColor = fragmentUniform.tintColor.xyz;
        float materialShininess = 32;
        float3 materialSpecularColor = float3(1, 1, 1);

        // Output Color
        float3 diffuseColor = 0;
        float3 specularColor = 0;
        float3 ambientColor = 0;
        
        for (uint i = 0; i < fragmentUniform.lightCount; i++) {
            LightData light = lightData[i];
            if (light.type == DirLight) {
                float3 lightDir = normalize(-light.direction);
                float diffuseIntensity = saturate(dot(normalWS, lightDir));  // NdotL
                float3 intensity = diffuseIntensity * light.intensity;
                diffuseColor += light.color * tintColor * intensity;

                if (diffuseIntensity > 0) {
                    float3 reflectDir = normalize(reflect(-lightDir, normalWS));
                    float3 viewDir = normalize(fragmentUniform.cameraPosition - in.worldPosition);
                    float specularIntensity = pow(saturate(dot(reflectDir, viewDir)), materialShininess);
                    float3 sIntensity = specularIntensity * light.intensity;
                    specularColor += light.color * materialSpecularColor * sIntensity;
                }
            } else if (light.type == PointLight) {
                float3 lightDir = normalize(light.position - in.worldPosition);
                float diffuseIntensity = saturate(dot(normalWS, lightDir));  // NdotL
                float3 intensity = diffuseIntensity * light.intensity;
                diffuseColor += light.color * tintColor * intensity;

                if (diffuseIntensity > 0) {
                    float3 reflectDir = normalize(reflect(-lightDir, normalWS));
                    float3 viewDir = normalize(fragmentUniform.cameraPosition - in.worldPosition);
                    float specularIntensity = pow(saturate(dot(reflectDir, viewDir)), materialShininess);
                    float3 sIntensity = specularIntensity * light.intensity;
                    specularColor += light.color * materialSpecularColor * sIntensity;
                }
            } else if (light.type == SpotLight) {
                continue;  // TODO: support spot light
            } else if (light.type == AmbientLight) {
                float3 intensity = light.intensity;
                ambientColor += light.color * intensity;
            }
        }

        float3 color = diffuseColor + specularColor + ambientColor;
        return float4(color, 1);
    }

}  // Palico
