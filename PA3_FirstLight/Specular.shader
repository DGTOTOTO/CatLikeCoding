Shader "Code/PA3_FirstLight/Specular"
{
    // Properties 新增 _SpecularTint 和 _Smoothness
    Properties {
        _Tint("Tint", Color) = (1, 1, 1, 1)
        _MainTex("Albedo", 2D) = "white" {}
        _SpecularTint("Specular", Color) = (0.5, 0.5, 0.5)
        _Smoothness("Smoothness", Range(0, 1)) = 0.5
    }
    SubShader {
        Pass {
            Tags {
                "LightMode" = "ForwardBase"
            }
            CGPROGRAM
            #pragma vertex Vert
            #pragma fragment Frag
            #include "UnityStandardBRDF.cginc"
            #include "UnityStandardUtils.cginc"
            
            sampler2D _MainTex;
            float4 _Tint, _MainTex_ST, _SpecularTint;
            float _Smoothness;

            struct VertexData {
                float4 position: POSITION;
                float2 uv: TEXCOORD0;
                float3 normal: NORMAL;
            };
            
            // Interpolators 中定义 worldPos，将 mesh 顶点转换到世界坐标系
            struct Interpolators {
                float4 position: SV_POSITION;
                float2 uv: TEXCOORD0;
                float3 normal: TEXCOORD1;
                float3 worldPos: TEXCOORD2;
            };
            
            Interpolators Vert(VertexData v) {
                Interpolators i;
                i.position = mul(unity_MatrixMVP, v.position);
                i.worldPos = mul(unity_ObjectToWorld, v.position); // 物体顶点转换到世界坐标系
                i.normal = UnityObjectToWorldNormal(v.normal);
                i.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return i;
            }

            float4 Frag(Interpolators i): SV_Target {
                i.normal = normalize(i.normal);
                float3 lightDir = _WorldSpaceLightPos0.xyz;
                
                float3 lightColor = _LightColor0.rgb;
                float3 albedo = tex2D(_MainTex, i.uv).rgb * _Tint.rgb;
                float oneMinusReflectivity;
                albedo = EnergyConservationBetweenDiffuseAndSpecular(albedo, _SpecularTint.rgb, oneMinusReflectivity);

                // 半程向量公式：normalize(light direction + view direction)
                // viewDir 是观察方向，来自观察点 - 物体顶点（两点相减得向量）
                float3 viewDir = normalize(_WorldSpaceCameraPos - i.worldPos); // view director, 观察方向
                float3 halfVector = normalize(lightDir + viewDir); // half vector, 半程向量

                float3 diffuse = albedo * lightColor * DotClamped(lightDir, i.normal);
                float3 specular = _SpecularTint.rgb * lightColor * pow(DotClamped(halfVector, i.normal), _Smoothness * 100);
                return float4(diffuse + specular, 1);
            }
            ENDCG
        }
    }
}