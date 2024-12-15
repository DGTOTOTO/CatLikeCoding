Shader"Code/PA4_MultipleLights/SH"
{
    Properties {
        _Tint("Tint", Color) = (1, 1, 1, 1)
        _MainTex("Albedo", 2D) = "white" {}
        [Gamma] _Metallic("Metallic", Range(0, 1)) = 0
        _Smoothness("Smoothness", Range(0, 1)) = 0.5
    }
    SubShader {
        Pass {
            Tags {
                "LightMode" = "ForwardBase"
            }
            CGPROGRAM
            #pragma target 3.0

            #pragma multi_compile _ VERTEXLIGHT_ON

            #pragma vertex Vert
            #pragma fragment Frag
            #define FORWARD_BASE_PASS // 需在 cginc 声明之上定义
            #include "SH_Light.cginc"
            ENDCG
        }

        Pass {
            Tags {
                "LightMode" = "ForwardAdd"
            }
            Blend One One
            ZWrite Off
            CGPROGRAM
            #pragma target 3.0
            
            #pragma multi_compile_fwdadd
            
            #pragma vertex Vert
            #pragma fragment Frag
            #include "SH_Light.cginc"
            ENDCG
        }
    }
}