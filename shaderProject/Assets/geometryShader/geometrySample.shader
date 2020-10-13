Shader "Custom/geometrySample"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        // No culling or depth
        Cull off ZWrite Off ZTest Always

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
			#pragma geometry geom
            #include "UnityCG.cginc"

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

			struct g2f {
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			struct v2g {
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
			[maxvertexcount(10)]
			void geom(triangle v2g l[3], inout LineStream<g2f> triStream) {
				g2f gOut;
				gOut.uv = l[0].uv;
				gOut.vertex = l[0].vertex;
				triStream.Append(gOut);
				gOut.uv = l[1].uv;
				gOut.vertex = l[1].vertex;
				triStream.Append(gOut);
				gOut.uv = l[2].uv;
				gOut.vertex = l[2].vertex;
				triStream.Append(gOut);
			}


            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = fixed4(0,1.0,1.0,1.0);
                return col;
            }
            ENDCG
        }
    }
}
