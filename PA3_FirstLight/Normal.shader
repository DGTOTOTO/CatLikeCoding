// 实现法线可视化输出

Shader "Code/PA3_FirstLight/Normal"
{
    Properties {
    }
    SubShader {
        Pass {
            CGPROGRAM
            #pragma vertex Vert
            #pragma fragment Frag
            #include "UnityCG.cginc"

            struct VertexData {
                float4 position: POSITION;
                float3 normal: NORMAL;
            };
            
            struct Interpolators {
                float4 position: SV_POSITION;
                float3 normal: TEXCOORD0;
            };
            
            Interpolators Vert(VertexData v) {
                Interpolators i;
                i.position = mul(unity_MatrixMVP, v.position);
                i.normal = UnityObjectToWorldNormal(v.normal);
                return i;
            }

            float4 Frag(Interpolators i): SV_Target {
                i.normal = normalize(i.normal);
                return float4(i.normal * 0.5 + 0.5, 1);
            }
            ENDCG
        }
    }
}