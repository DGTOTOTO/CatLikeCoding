#if !defined(SHADOWS_RECEIVINGSHADOW_SHADOW)
#define SHADOWS_RECEIVINGSHADOW_SHADOW

#include "UnityCG.cginc"

struct VertexData {
    float4 position : POSITION;
    float3 normal : NORMAL;
};

float4 ShadowVert (VertexData v) : SV_POSITION {
    float4 position =
        UnityClipSpaceShadowCasterPos(v.position.xyz, v.normal);
    return UnityApplyLinearShadowBias(position);
}

half4 ShadowFrag () : SV_TARGET {
    return 0;
}

#endif