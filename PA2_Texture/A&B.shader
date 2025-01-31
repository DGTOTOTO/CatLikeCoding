Shader "Code/PA2_Texture/A&B"
{
    Properties {
        _MainTex("Texture", 2D) = "white"{}
        _DetailTex("Detail Texture", 2D) = "gray"{}
    }
    SubShader {
        Pass {
            CGPROGRAM
            #pragma vertex Vert
            #pragma fragment Frag

            #include "UnityCG.cginc"
            sampler2D _MainTex, _DetailTex;
            float4 _MainTex_ST, _DetailTex_ST;

            struct VertexData {
                float4 position: POSITION;
                float2 uv: TEXCOORD0;
            };
            
            struct Interpolators {
                float4 position: SV_POSITION;
                float2 uv: TEXCOORD0;
                float2 uvDetail: TEXCOORD1;
            };
            
            Interpolators Vert(VertexData v) {
                Interpolators i;
                i.position = mul(unity_MatrixMVP, v.position);
                i.uv = TRANSFORM_TEX(v.uv, _MainTex);
                i.uvDetail = TRANSFORM_TEX(v.uv, _DetailTex);
                return i;
            }

            float4 Frag(Interpolators i): SV_Target {
                float4 color = tex2D(_MainTex, i.uv) ;
                color *= tex2D(_DetailTex, i.uvDetail) * unity_ColorSpaceDouble;
                return color;
            }
            ENDCG
        }
    }
}