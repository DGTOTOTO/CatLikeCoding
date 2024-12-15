#if !defined(MULTIPLELIGHTS_ADDPOINTLIGHT_LIGHT)
#define MULTIPLELIGHTS_ADDPOINTLIGHT_LIGHT

#define UNITY_PBS_USE_BRDF3
#include "UnityPBSLighting.cginc"
#define POINT
#include "AutoLight.cginc"

sampler2D _MainTex;
float4 _Tint, _MainTex_ST;
float _Smoothness, _Metallic;

struct VertexData {
    float4 position: POSITION;
    float2 uv: TEXCOORD0;
    float3 normal: NORMAL;
};

struct Interpolators {
    float4 position: SV_POSITION;
    float2 uv: TEXCOORD0;
    float3 normal: TEXCOORD1;
    float3 worldPos: TEXCOORD2;
};

Interpolators Vert(VertexData v) {
    Interpolators i;
    i.position = mul(unity_MatrixMVP, v.position);
    i.worldPos = mul(unity_ObjectToWorld, v.position);
    i.normal = UnityObjectToWorldNormal(v.normal);
    i.uv = TRANSFORM_TEX(v.uv, _MainTex);
    return i;
}

// 如果定义了 POINT，则手动计算光线距离；
// 否则就意味着 Directional Light，就直接使用 _WorldSpaceLightPos0 变量
UnityLight CreateLight(Interpolators i) {
    UnityLight light;

    // 使用 #if defined 语句来检测这些 Shader 变量是否被定义
    // 根据变量选择不同的光照处理方式，从而针对光源类型实现对应变体的调用
    #if defined(POINT)
    light.dir = normalize(_WorldSpaceLightPos0.xyz - i.worldPos);
    #else
    light.dir = _WorldSpaceLightPos0.xyz;
    #endif
    
    UNITY_LIGHT_ATTENUATION(attenuation, 0, i.worldPos);
    light.color = _LightColor0.rgb * attenuation;
    light.ndotl = DotClamped(i.normal, light.dir);
    return light;
}

float4 Frag(Interpolators i): SV_Target {
    i.normal = normalize(i.normal);
    float3 viewDir = normalize(_WorldSpaceCameraPos - i.worldPos);
    float3 albedo = tex2D(_MainTex, i.uv).rgb * _Tint.rgb;
    float3 SpecularTint;
    float oneMinusReflectivity;
    albedo = DiffuseAndSpecularFromMetallic(albedo, _Metallic, SpecularTint, oneMinusReflectivity);

    UnityIndirect indirectLight;
    indirectLight.diffuse = 0;
    indirectLight.specular = 0;

    return UNITY_BRDF_PBS(
        albedo, SpecularTint,
        oneMinusReflectivity, _Smoothness,
        i.normal, viewDir,
        CreateLight(i), indirectLight
        );
}

#endif