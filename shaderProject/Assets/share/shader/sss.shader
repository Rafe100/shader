Shader "Custom/sss"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_Color("BaseColor",Color) = (1,1,1,1)
	    _Pow("Pow", float) = 1
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

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
				float4 normal : NORMAL;
            };

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

            sampler2D _MainTex;
			sampler2D _sMap;
			float4x4 _shadowCameraW2LMatrix;
			float4x4 _shadowCameraProjectMatrix;
			float4 _sMap_TexelSize;
			float4 _lightPos;
			float4 _camPos;
			float _Pow;
			half4 _Color;
            fixed4 frag (v2f i) : SV_Target
            {
				float4 coord = mul(_shadowCameraProjectMatrix, mul(_shadowCameraW2LMatrix, float4(i.worldPos,1)));
				coord.xyz = (coord.xyz + 1) / 2;
				float shadowMapDepth = SAMPLE_DEPTH_TEXTURE(_sMap, coord.xy);
				float exitDepth = coord.z;
				float distance = shadowMapDepth - exitDepth;
				float3 lightDir = normalize(_lightPos.xyz - i.worldPos);
				//lightDir = normalize(lightDir + i.worldNormal);
				float3 viewDir = normalize(_camPos.xyz - i.worldPos);
				float lv = pow(saturate(dot(viewDir, -lightDir)), _Pow);

                //fixed4 col = tex2D(_MainTex, i.uv);
				fixed4 col = _Color;
				col *= lv;
				//col += float4(distance, distance, distance, 0);
				col.a = 1.0;
                return col;
            }
            ENDCG
        }
    }
}
