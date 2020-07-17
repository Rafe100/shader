Shader "Custom/xRay"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_Color("BaseColor",Color) = (1,1,1,1)
		_XrayColor("xRayColor", Color) = (1,0,1,1)
	}
		SubShader
		{
			// No culling or depth
			

			Pass
			{

				Stencil {
				  Ref 1
				  Comp greater
				  Pass Replace
				  ZFail Keep
				}
			Cull Off ZWrite on ZTest lequal
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

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            sampler2D _MainTex;

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
				col = _Color;
                return col;
			}
				ENDCG
		}



			Pass
			{

				Stencil {
				  Ref 4
				  Comp equal
				  Pass Replace
				  ZFail Keep
				}
				Cull Off ZWrite on ZTest always
				CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag

				#include "UnityCG.cginc"

				half4 _XrayColor;

				

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
				col = _XrayColor;
				return col;
			}
			ENDCG
		}

    }
}
