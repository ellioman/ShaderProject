Shader "Ellioman/Shading/Diffuse"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_Color ("Color", Color) = (1,1,1,1)
		_Kd ("Diffuse Reflectivity", Vector) = (0,0,0,1)
		_Ld ("Light source Intensity", Vector) = (0,0,0,1)
	}
	SubShader
	{
		Tags { "LightMode" = "ForwardBase" }
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float4 normal : NORMAL;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
				float3 color : Color;
				float2 uv : TEXCOORD0;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			half4 _Color;
			float3 _Ld;
			float3 _Kd; 

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);

				// Diffuse shading
				// Kd = Diffuse Reflectivity. Some light is absorved before re-emitted. This is a reflection
				//      coefficient which represents the fraction of the incoming light that is scattered
				// L = Kd * Ld * (S dot n)
				// Ld = Light Source Intensity
				// S = Sun/Light
				// N = Normal of the surface
				float3 N = mul(UNITY_MATRIX_IT_MV,float4(v.normal.rgb,1));
				float3 S = _WorldSpaceLightPos0;
				o.color = _Ld * _Kd * saturate(dot(S, N));
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				// sample the texture
				fixed4 texColor = tex2D(_MainTex, i.uv);
				return float4(i.color.rgb, 1.0) * texColor * _Color;
			}
			ENDCG
		}
	}
}
