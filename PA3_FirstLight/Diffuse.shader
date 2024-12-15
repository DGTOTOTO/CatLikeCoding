Shader "Code/PA3_FirstLight/Diffuse"
{
    Properties {
        _Tint("Tint", Color) = (1, 1, 1, 1)
        _MainTex("Albedo", 2D) = "white" {}
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
            
            sampler2D _MainTex;
            float4 _Tint, _MainTex_ST;

            struct VertexData {
                float4 position: POSITION;
                float2 uv: TEXCOORD0;
                float3 normal: NORMAL;
            };
            
            struct Interpolators {
                float4 position: SV_POSITION;
                float2 uv: TEXCOORD0;
                float3 normal: TEXCOORD1;
            };
            
            Interpolators Vert(VertexData v) {
                Interpolators i;
                i.position = mul(unity_MatrixMVP, v.position);
                i.uv = TRANSFORM_TEX(v.uv, _MainTex);
                i.normal = UnityObjectToWorldNormal(v.normal);
                return i;
            }

            float4 Frag(Interpolators i): SV_Target {
                i.normal = normalize(i.normal);
                float3 lightDir = _WorldSpaceLightPos0.xyz;
                float3 lightColor = _LightColor0.rgb;
                float3 albedo = tex2D(_MainTex, i.uv).rgb * _Tint.rgb;

                float3 diffuse = albedo * lightColor * DotClamped(lightDir, i.normal);
                return float4(diffuse, 1);
            }
            ENDCG
        }
    }
}