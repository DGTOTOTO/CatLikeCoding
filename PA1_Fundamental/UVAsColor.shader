// UV 坐标 是作为顶点属性附加在 3D 模型顶点上的。
// 每个顶点不仅有它在 3D 空间中的 位置（X, Y, Z 坐标），还会有一个 UV 坐标（U, V），用来描述它对应于纹理图像上的哪个点。
// 3D 模型和 2D 贴图对纹理，是动模型，而不是动纹理。


Shader"Code/PA1_Fundamental/UVAsColor" 
{
    Properties {
        _Tint("Tint", Color) = (1, 1, 1, 1)
    }
    SubShader {
        Pass {
            CGPROGRAM
            #pragma vertex Vert
            #pragma fragment Frag

            #include "UnityCG.cginc"
            float4 _Tint;

            struct VertexData {
                float4 position: POSITION;
                float2 uv: TEXCOORD0;
            };
            
            struct Interpolators {
                float4 position: SV_POSITION;
                float2 uv: TEXCOORD0;
                // float3 localPosition: TEXCOORD0;
            };


            Interpolators Vert(VertexData v) {
                Interpolators i;
                // i.localPosition = v.position.xyz;
                i.uv = v.uv;
                i.position = mul(unity_MatrixMVP, v.position);
                return i;
            }

            float4 Frag(Interpolators i): SV_TARGET {
                // return float4(i.localPosition + 0.5, 1) * _Tint;
                return float4(i.uv, 1, 1);
            }
            
            ENDCG
        }
    }
}