// Upgrade NOTE: replaced 'defined UNITY_REVERSED_Z' with 'defined (UNITY_REVERSED_Z)'

Shader "Custom/shadow"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        // No culling or depth
        Cull Off ZWrite on ZTest lequal

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
			#include "Lighting.cginc"
			 #include "AutoLight.cginc"
            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
				float4 normal : NORMAL;
            };
			sampler2D _MainTex;
			sampler2D _sMap;
			float4 _cameraProp;
			float LinearDepth(float depth) {
				float x = 1 - _cameraProp.w / _cameraProp.z;
				float y = _cameraProp.w / _cameraProp.z;
				float z = x / _cameraProp.w;
				float w = y / _cameraProp.w;
				return 1 / (z * depth + w);
			}

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
				float3 worldPos : TEXCOORD1;
				float3 worldNormal : TEXCOORD2;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
				o.worldPos = mul(unity_ObjectToWorld, v.vertex);
				o.worldNormal = UnityObjectToWorldNormal(v.normal);
                o.uv = v.uv;
                return o;
            }

            
			//UNITY_DECLARE_SHADOWMAP(_sMap);
			float4x4 _CameraW2LMatrix;
			float4x4 _CameraProjectMatrix;
			float4 _sMap_TexelSize;
            fixed4 frag (v2f i) : SV_Target
            {

				float4 coord = mul(_CameraProjectMatrix, mul(_CameraW2LMatrix, float4(i.worldPos,1)));
				coord.xyz = (coord.xyz + 1) / 2;
				//coord.xy = (coord.xy / _cameraProp.x + 1)/ 2;
				//coord.z = (coord.z - _cameraProp.y)/(_cameraProp.z - _cameraProp.y);
				//#   define SAMPLE_DEPTH_TEXTURE(sampler, uv) (tex2D(sampler, uv).r)

				{
					//距离最近的shadowMap中心点
					coord.x = 0.5 *abs(_sMap_TexelSize.x) + floor(coord.x / abs(_sMap_TexelSize.x)) * _sMap_TexelSize.x;
					coord.y = 0.5 *abs(_sMap_TexelSize.y) + floor(coord.y / abs(_sMap_TexelSize.y)) * _sMap_TexelSize.y;
				}

				float shadowMapDepth = SAMPLE_DEPTH_TEXTURE(_sMap, coord.xy);
				float shadowMapDepth_1 = SAMPLE_DEPTH_TEXTURE(_sMap, coord.xy + float2(_sMap_TexelSize.xy));
				float shadowMapDepth_2 = SAMPLE_DEPTH_TEXTURE(_sMap, coord.xy + _sMap_TexelSize.xy*float2(-1,1));
				float shadowMapDepth_3 = SAMPLE_DEPTH_TEXTURE(_sMap, coord.xy + _sMap_TexelSize.xy);
				float shadowMapDepth_4 = SAMPLE_DEPTH_TEXTURE(_sMap, coord.xy + _sMap_TexelSize.xy);

				//shadow = shadow * 2 - 1;
				fixed4 col = fixed4(0.1, 0.1, 0.1,1);
				//fixed depth = LinearDepth(shadow);
				//fixed shadow = SHADOW_ATTENUATION(i);
				

				//direction light z vector
				float4 lightDir = normalize(_CameraW2LMatrix[2]);
				col.xyz += dot(lightDir.xyz, i.worldNormal.xyz);
#if defined (UNITY_REVERSED_Z) 
				shadowMapDepth = 1 - shadowMapDepth;
#endif
				{
					//shadow bias
					//coord.z -= 0.000001;
					//shadowMapDepth += 0.000001;
					//shadowMapDepth += unity_LightShadowBias.z;
					shadowMapDepth += 0.00000038;
				}

				

				if (coord.z > shadowMapDepth) {
					col = fixed4(0.05, 0.05, 0.05, 1);
				}
				//col = col;
                return col;
            }

		

            ENDCG
        }

    }
}
