// shader 版本的 Hello World
Shader "Code/PA1_Fundamental/YellowSphere"
{
    Properties {
        _Tint("Tint", Color) = (1,1,0,1) // Tint，英文 “染色”
    }
    SubShader {
        Pass {
            CGPROGRAM
            #pragma vertex Vert
            #pragma fragment Frag
            #include "UnityCG.cginc"
            
            float4 _Tint;

            // 顶点坐标使用 MVP 变换，从物体局部坐标转换为屏幕空间坐标
            float4 Vert(float4 position: POSITION): SV_POSITION {
                return mul(unity_MatrixMVP, position);
            }

            // 直接返回在 Properties 中定义的 _Tint
            float4 Frag(): SV_Target {
                return _Tint;
            }      
            ENDCG
        }
    }
}