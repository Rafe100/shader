// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/StencilEdgeProcess"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
		_StencilColor("StencilBuffer Color",Color) = (1,1,0,1)
		_RefValue("Ref Value",Int) = 2
	}
		SubShader
		{
		

			Pass
			{
				Stencil{
					Ref[_RefValue]
					Comp Equal
				}

				CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag

				#include "UnityCG.cginc"

				struct appdata
				{
					float4 vertex : POSITION;
				};

				struct v2f
				{
					float4 vertex : SV_POSITION;
				};

				sampler2D _MainTex;
				fixed4 _StencilColor;

				v2f vert(appdata v)
				{
					v2f o;
					o.vertex = UnityObjectToClipPos(v.vertex);
					return o;
				}

				fixed4 frag(v2f i) : SV_Target
				{
					return _StencilColor;
				}
				ENDCG
			}
		}
}
