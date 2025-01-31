Shader "Code/PA2_Texture/Splat"
{
    Properties {
        // _MainTex 为 splat map；_Texture1 和 _Texture2 分别为待混合的两个纹理
        _MainTex("Splat Map", 2D) = "white"{}
        [NoScaleOffset] _Texture1("Texture 1", 2D) = "white" {}
        [NoScaleOffset] _Texture2("Texture 2", 2D) = "white" {}
    }
    SubShader {
        Pass {
            CGPROGRAM
            #pragma vertex Vert
            #pragma fragment Frag

            #include "UnityCG.cginc"
            sampler2D _MainTex;
            sampler2D _Texture1, _Texture2;
            float4 _MainTex_ST;

            struct VertexData {
                float4 position: POSITION;
                float2 uv: TEXCOORD0;
            };
            
            struct Interpolators {
                float4 position: SV_POSITION;
                float2 uv: TEXCOORD0;
                float2 uvSplat: TEXCOORD1;
            };

            Interpolators Vert(VertexData v) {
                Interpolators i;
                i.position = mul(unity_MatrixMVP, v.position);
                i.uv = TRANSFORM_TEX(v.uv, _MainTex);
                i.uvSplat = v.uv;
                return i;
            }

            float4 Frag(Interpolators i): SV_Target {
                float4 splat = tex2D(_MainTex, i.uvSplat);
                return tex2D(_Texture1, i.uv) * splat.r + tex2D(_Texture2, i.uv) * (1-splat.r);
            }
            ENDCG
        }
    }
}