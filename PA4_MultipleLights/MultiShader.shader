Shader"Code/PA4_MultipleLights/MultiShader"
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
            #pragma vertex Vert
            #pragma fragment Frag
            #include "MultiShader_Light.cginc"
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
            #pragma multi_compile DIRECTIONAL POINT // new line
            #pragma vertex Vert
            #pragma fragment Frag
            #include "MultiShader_Light.cginc"
            // #define POINT
            ENDCG
        }
    }
}