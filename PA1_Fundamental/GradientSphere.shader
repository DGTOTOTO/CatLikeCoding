Shader "Code/PA1_Fundamental/GradientSphere"
{
    Properties {
        _Tint("Tint", Color) = (1, 1, 1, 1)
    }
    SubShader {
        // refactor
        Pass {
            CGPROGRAM
            // 指定顶点 / 片元着色器
            #pragma vertex Vert
            #pragma fragment Frag

            #include "UnityCG.cginc"
            float4 _Tint;

            struct Interpolators {
                float4 position: SV_POSITION;
                float3 localPosition: TEXCOORD0;
            };

            // float4 MyVertexProgram(float4 position: POSITION, out float3 localPosition: TEXCOORD0): SV_POSITION {
            //     localPosition = position.xyz;
            //     return mul(unity_MatrixMVP, position);
            // }
            
            Interpolators Vert(float4 position: POSITION) {
                Interpolators i;
                i.localPosition = position.xyz;
                i.position = mul(unity_MatrixMVP, position);
                return i;
            }

            // float4 MyFragmentProgram(float4 position: SV_POSITION, float3 localPosition: TEXCOORD0): SV_Target {
            //     return float4(localPosition, 1);
            // }

            float4 Frag(Interpolators i): SV_TARGET {
                return float4(i.localPosition + 0.5, 1) * _Tint;
            }
            
            ENDCG
        }
    }
}