﻿Shader "Custom/wall"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
		_Color("BaseColor",Color) = (1,1,1,1)
	}
		SubShader
		{
			// No culling or depth
			Cull Off ZWrite On ZTest lequal

			Pass
			{

				Stencil {
					  Ref 4
					  Comp Always
					  Pass Replace
					  ZFail Keep
					}
				CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag

				#include "UnityCG.cginc"


				

				half4 _Color;
			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			v2f vert(appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}

			sampler2D _MainTex;

			fixed4 frag(v2f i) : SV_Target
			{
				fixed4 col = tex2D(_MainTex, i.uv);
				col = _Color;
				return col;
			}
				ENDCG
		}

		}
}
