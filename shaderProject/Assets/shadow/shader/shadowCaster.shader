Shader "Custom/shadowCaster"
{
    Properties
    {
    }
    SubShader
    {
        // No culling or depth
        Cull Off ZWrite on ZTest lequal

		Pass
		{
			Tags {"LightMode" = "ShadowCaster"}

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_shadowcaster
			#include "UnityCG.cginc"


			struct appdata {
				float4 vertex:POSITION;
			};
			struct v2f {
				float4 vertex : SV_POSITION;
			};

			v2f vert(appdata_base v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				return o;
			}

			float4 frag(v2f i) : SV_Target
			{
				return 0;
			}
			ENDCG
		}
    }
		FallBack "Diffuse"
}
