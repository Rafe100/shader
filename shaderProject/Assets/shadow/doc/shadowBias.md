
bias为常量可以解决部分acne问题，还有依靠斜率来计算的slop scale depth bias。当模型切平面和光线方向角度越小越容易出现问题。最为理想的情况是每个像素有独立的最小bias。

| shadow resolution | bias  | normal bias | unity_LightShadowBias   |
| ----------------- | ----- | ----------- | ----------------------- |
| low               | 0.005 | 0.4         | (-0.00056, 1, <font color=#0099ff>0.16</font> , 0)  |
| medium            | 0.005 | 0.4         | (-0.00056, 1, <font color=#0099ff>0.077</font> , 0) |
| high              | 0.005 | 0.4         | (-0.00056, 1, <font color=#0099ff>0.038</font> , 0) |
| very high         | 0.005 | 0.4         | (-0.00056, 1, <font color=#0099ff>0.038</font> , 0) |





<font color=#0099ff>unity_LightShadowBias.z</font>  值受到shadowMap分辨率大小的影响，准确的说是shadowMap像素大小相关

```
float4 UnityClipSpaceShadowCasterPos(float4 vertex, float3 normal)
{
    float4 wPos = mul(unity_ObjectToWorld, vertex);

    if (unity_LightShadowBias.z != 0.0)
    {
        float3 wNormal = UnityObjectToWorldNormal(normal);
        float3 wLight = normalize(UnityWorldSpaceLightDir(wPos.xyz));

        // apply normal offset bias (inset position along the normal)
        // bias needs to be scaled by sine between normal and light direction
        // (http://the-witness.net/news/2013/09/shadow-mapping-summary-part-1/)
        //
        // unity_LightShadowBias.z contains user-specified normal offset amount
        // scaled by world space texel size.

        float shadowCos = dot(wNormal, wLight);
        float shadowSine = sqrt(1-shadowCos*shadowCos);
        float normalBias = unity_LightShadowBias.z * shadowSine;

        wPos.xyz -= wNormal * normalBias;
    }

    return mul(UNITY_MATRIX_VP, wPos);
}
```