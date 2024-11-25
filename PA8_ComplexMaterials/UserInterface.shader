Shader "Code/PA8_ComplexMaterials/UserInterface" {
	Properties {
		_Tint ("Tint", Color) = (1, 1, 1, 1)
		_MainTex ("Albedo", 2D) = "white" {}
		[NoScaleOffset] _NormalMap ("Normals", 2D) = "bump" {}
		_BumpScale ("Bump Scale", Float) = 1
		[Gamma] _Metallic ("Metallic", Range(0, 1)) = 0
		_Smoothness ("Smoothness", Range(0, 1)) = 0.1
		_DetailTex ("Detail Albedo", 2D) = "gray" {}
		[NoScaleOffset] _DetailNormalMap ("Detail Normals", 2D) = "bump" {}
		_DetailBumpScale ("Detail Bump Scale", Float) = 1
	}
	
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
			#pragma multi_compile _ SHADOWS_SCREEN
			#pragma multi_compile _ VERTEXLIGHT_ON
			#pragma vertex Vert
			#pragma fragment Frag
			#define FORWARD_BASE_PASS
			#include "UserInterface_Light.cginc"
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
			#pragma multi_compile_fwdadd_fullshadows
			#pragma vertex Vert
			#pragma fragment Frag
			#include "UserInterface_Light.cginc"
			ENDCG
		}

		Pass {
			Tags {
				"LightMode" = "ShadowCaster"
			}

			CGPROGRAM
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma vertex ShadowVert
			#pragma fragment ShadowFrag
			#include "ComplexMaterials_Shadow.cginc"
			ENDCG
		}
	}

	// STEP2
	// to use a custom GUI, have to add the CustomEditor directive to a shader
	// "the name of the GUI class"
	CustomEditor "UserInterface_GUI"
}