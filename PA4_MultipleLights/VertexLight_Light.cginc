#if !defined(MULTIPLELIGHTS_VERTEXLIGHT_LIGHT)
#define MULTIPLELIGHTS_VERTEXLIGHT_LIGHT

#define UNITY_PBS_USE_BRDF3
#include "UnityPBSLighting.cginc"
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

    // 增加条件判断，决策是否启动额外的数据插值与传递
    #if defined(VERTEXLIGHT_ON)
        float3 vertexLightColor: TEXCOORD3;
    #endif
};

// 将顶点光照的计算逻辑抽象出来，作为 inout 参数传递给函数
// 其将在 vertex shader 中调用
// 这里是单个 Vertex Light 的计算逻辑，多个光源打包使用工具函数 Shade4PointLights 即可
void ComputeVertexLightColor(inout Interpolators i) {
    #if defined(VERTEXLIGHT_ON)
        float3 lightPos = float3(unity_4LightPosX0.x, unity_4LightPosY0.x, unity_4LightPosZ0.x);
        float3 lightVec = lightPos - i.worldPos;
        float3 lightDir = normalize(lightVec);
        float ndotl = DotClamped(i.normal, lightDir);
        float attenuation = 1 / (1 + dot(lightVec, lightVec) * unity_4LightAtten0.x);
        
        i.vertexLightColor = unity_LightColor[0].rgb * ndotl * attenuation;
        // i.vertexLightColor = unity_LightColor[0].rgb; // 测试语句
    #endif
}

Interpolators Vert(VertexData v) {
    Interpolators i;
    i.position = mul(unity_MatrixMVP, v.position);
    i.worldPos = mul(unity_ObjectToWorld, v.position);
    i.normal = UnityObjectToWorldNormal(v.normal);
    i.uv = TRANSFORM_TEX(v.uv, _MainTex);
    ComputeVertexLightColor(i);
    return i;
}

UnityLight CreateLight(Interpolators i) {
    UnityLight light;
    #if defined(POINT) || defined(POINT_COOKIE) || defined(SPOT)
        light.dir = normalize(_WorldSpaceLightPos0.xyz - i.worldPos);
    #else
        light.dir = _WorldSpaceLightPos0.xyz;
    #endif
    UNITY_LIGHT_ATTENUATION(attenuation, 0, i.worldPos);
    light.color = _LightColor0.rgb * attenuation;
    light.ndotl = DotClamped(i.normal, light.dir);
    return light;
}

// 抽象出 fragment shader 阶段的 indirect light 计算逻辑
UnityIndirect CreateIndirectLight(Interpolators i) {
    UnityIndirect indirectLight;
    indirectLight.diffuse = 0;
    indirectLight.specular = 0;
    #if defined(VERTEXLIGHT_ON)
        indirectLight.diffuse = i.vertexLightColor;
    #endif
    return indirectLight;
}

float4 Frag(Interpolators i): SV_Target {
    i.normal = normalize(i.normal);
    float3 viewDir = normalize(_WorldSpaceCameraPos - i.worldPos);
    float3 albedo = tex2D(_MainTex, i.uv).rgb * _Tint.rgb;
    
    float3 SpecularTint;
    float oneMinusReflectivity;
    albedo = DiffuseAndSpecularFromMetallic(albedo, _Metallic, SpecularTint, oneMinusReflectivity);

    // UnityIndirect indirectLight;
    // indirectLight.diffuse = 0;
    // indirectLight.specular = 0;

    return UNITY_BRDF_PBS(
        albedo, SpecularTint,
        oneMinusReflectivity, _Smoothness,
        i.normal, viewDir,
        CreateLight(i), CreateIndirectLight(i)
        );
}

#endif