Shader "UVTexture"
{
    Properties {
        _MainTex("Texture", 2D) = "White"{}
    }
    SubShader {
        Pass {
            CGPROGRAM
            #pragma vertex Vert
            #pragma fragment Frag

            #include "UnityCG.cginc"
            sampler2D _MainTex;
            float4 _MainTex_ST;

            struct Interpolators {
                float4 position: SV_POSITION;
                float2 uv: TEXCOORD0;
            };

            struct VertexData {
                float4 position: POSITION;
                float2 uv: TEXCOORD0;
            };

            Interpolators Vert(VertexData v) {
                Interpolators i;
                // i.uv = v.uv * _MainTex_ST.xy + _MainTex_ST.zw;
                i.uv = TRANSFORM_TEX(v.uv, _MainTex);
                i.position = mul(unity_MatrixMVP, v.position);
                return i;
            }

            float4 Frag(Interpolators i): SV_TARGET {
                return tex2D(_MainTex, i.uv);
            }
            
            ENDCG
        }
    }
}
