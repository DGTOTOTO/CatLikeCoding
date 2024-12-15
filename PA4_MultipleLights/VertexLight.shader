Shader"Code/PA4_MultipleLights/VertexLight"
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

            // 使用 _ 来表示所有其他光源类型，让编译器自动处理
            // 仅对重要关键字（VERTEXLIGHT_ON）进行显式定义
            #pragma multi_compile _ VERTEXLIGHT_ON
            
            #pragma vertex Vert
            #pragma fragment Frag
            #include "VertexLight_Light.cginc"
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
            #include "VertexLight_Light.cginc"
            ENDCG
        }
    }
}