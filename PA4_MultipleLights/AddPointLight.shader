Shader"Code/PA4_MultipleLights/AddPointLight"
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
            #include "AddPointLight_Light.cginc"
            ENDCG
        }

        // new Pass
        Pass {
            Tags {
                "LightMode" = "ForwardAdd"
            }
            Blend One One // new
            ZWrite Off // new
            CGPROGRAM
            #pragma target 3.0
            #pragma vertex Vert
            #pragma fragment Frag
            #include "AddPointLight_Light.cginc"
            #define POINT
            ENDCG
        }
    }
}