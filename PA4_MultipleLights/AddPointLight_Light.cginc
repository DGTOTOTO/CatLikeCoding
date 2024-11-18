#if !defined(MULTIPLELIGHTS_ADDPOINTLIGHT_LIGHT)
#define MULTIPLELIGHTS_ADDPOINTLIGHT_LIGHT

#define UNITY_PBS_USE_BRDF3
#include "UnityPBSLighting.cginc"
#include "AutoLight.cginc" // 使用 UNITY_LIGHT_ATTENUATION 宏需包含头文件

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

// 将 Fragment shader 中 BRDF 函数需要的 direct light 的光线信息相关计算抽象出来
// 要不然代码就会越来越长了...
UnityLight CreateLight(Interpolators i) {
    UnityLight light;
    light.dir = normalize(_WorldSpaceLightPos0.xyz - i.worldPos);
    UNITY_LIGHT_ATTENUATION(attenuation, 0, i.worldPos);
    light.color = _LightColor0.rgb * attenuation;
    light.ndotl = DotClamped(i.normal, light.dir);
    return light;
}

float4 Frag(Interpolators i): SV_Target {
    i.normal = normalize(i.normal);
    // float3 lightDir = _WorldSpaceLightPos0.xyz;
    float3 viewDir = normalize(_WorldSpaceCameraPos - i.worldPos);
    // float3 lightColor = _LightColor0.rgb;
    float3 albedo = tex2D(_MainTex, i.uv).rgb * _Tint.rgb;
    float3 SpecularTint;
    float oneMinusReflectivity;
    albedo = DiffuseAndSpecularFromMetallic(albedo, _Metallic, SpecularTint, oneMinusReflectivity);

    // UnityLight light;
    // light.color = lightColor;
    // light.dir = lightDir;
    // light.ndotl = DotClamped(i.normal, lightDir);

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