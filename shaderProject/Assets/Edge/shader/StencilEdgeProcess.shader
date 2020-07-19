// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Hidden/StencilEdgeProcess"
{
   
	Properties{
		_MainTex("Base (RGB)", 2D) = "white" {}
			_StencilTex("Stencil Tex", 2D) = "white" {}
		_EdgeThreshold("Edge Threshold",Range(0,1)) = 0.1
	}
		SubShader{
			Pass {
				ZTest Always Cull Off ZWrite Off

				CGPROGRAM

				#include "UnityCG.cginc"

				#pragma vertex vert  
				#pragma fragment fragSobel

				sampler2D _MainTex;
						sampler2D _StencilTex;
				half4 _StencilTex_TexelSize;
				float _EdgeThreshold;
				struct v2f
							{
					float4 pos : SV_POSITION;
					half2 uv[9] : TEXCOORD0;
				};

				v2f vert(appdata_img v) {
					v2f o;
					o.pos = UnityObjectToClipPos(v.vertex);

					half2 uv = v.texcoord;

					o.uv[0] = uv + _StencilTex_TexelSize.xy * half2(-1, -1);
					o.uv[1] = uv + _StencilTex_TexelSize.xy * half2(0, -1);
					o.uv[2] = uv + _StencilTex_TexelSize.xy * half2(1, -1);
					o.uv[3] = uv + _StencilTex_TexelSize.xy * half2(-1, 0);
					o.uv[4] = uv + _StencilTex_TexelSize.xy * half2(0, 0);
					o.uv[5] = uv + _StencilTex_TexelSize.xy * half2(1, 0);
					o.uv[6] = uv + _StencilTex_TexelSize.xy * half2(-1, 1);
					o.uv[7] = uv + _StencilTex_TexelSize.xy * half2(0, 1);
					o.uv[8] = uv + _StencilTex_TexelSize.xy * half2(1, 1);

					return o;
				}


				half4 Sobel(v2f i) {

					const half Gx[9] = {-1,  0,  1,
											-2,  0,  2,
											-1,  0,  1};
					const half Gy[9] = {-1, -2, -1,
											0,  0,  0,
											1,  2,  1};
					half3 edgeColor = half3(0,0,0);
					float edgePixelCount = 0;
					half Colorluminance;
					half edgeX = 0;
					half edgeY = 0;
					half4 texColor;
					for (int it = 0; it < 9; it++)
					{
						texColor = tex2D(_StencilTex, i.uv[it]);
						Colorluminance = texColor.a;
						edgeX += Colorluminance * Gx[it];
						edgeY += Colorluminance * Gy[it];

						edgeColor += texColor.rgb;
						edgePixelCount += texColor.a;
					}

					half edge = 1 - abs(edgeX) - abs(edgeY);
					//防止除0
	edgePixelCount += saturate(1 - edgePixelCount);

	return half4(edgeColor / edgePixelCount, edge);
}

fixed4 fragSobel(v2f i) : SV_Target
{
	fixed4 srcColor = tex2D(_MainTex,i.uv[4]);
	half4 edgeInfo = Sobel(i);
	half edge = edgeInfo.w;
	edge += saturate(_EdgeThreshold)*(1 - edge);
	srcColor.rgb = lerp(edgeInfo.rgb, srcColor.rgb, edge);

	return fixed4(srcColor.rgb, 1);
}

ENDCG
}
		}
   
}
