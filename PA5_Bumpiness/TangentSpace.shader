Shader "Code/PA5_Bumpiness/TangentSpace" {
	Properties {
		_Tint ("Tint", Color) = (1, 1, 1, 1)
		_MainTex ("Albedo", 2D) = "white" {}
		[NoScaleOffset] _NormalMap ("Normals", 2D) = "bump" {}
		_BumpScale ("Bump Scale", Float) = 1
		[Gamma] _Metallic ("Metallic", Range(0, 1)) = 0
		_Smoothness ("Smoothness", Range(0, 1)) = 0.1
		_DetailTex ("Detail Texture", 2D) = "gray" {}
		[NoScaleOffset] _DetailNormalMap ("Detail Normals", 2D) = "bump" {}
		_DetailBumpScale ("Detail Bump Scale", Float) = 1
	}
	
	// 新增条件编译
	CGINCLUDE
	#define BINORMAL_PER_FRAGMENT
	ENDCG

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
			#define FORWARD_BASE_PASS
			#include "TangentSpace_Light.cginc"
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
			#include "TangentSpace_Light.cginc"
			ENDCG
		}
	}
}