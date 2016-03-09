// Alan Zucconi: http://www.alanzucconi.com/?p=4565
Shader "Hidden/Smoke"
{
	Properties
	{
		_MainTex("Base (RGB)", 2D) = "white" {}

		_Pixels("Pixels in a quad", Float) = 128
		
		_Transmission("Transmission", Vector) = (1,1,1,1)
		_Dissipation("Dissipation", Range(0,1)) = 0.1
		_Minimum("Minimum", Range(0,1)) = 0.003

		// Mouse smoke
		_SmokeCentre("Smoke center", Vector) = (0,0,0,0)
		_SmokeRadius("Smoke Radius", Range(0,0.25)) = 0.05
	}
	
	SubShader
	{
		// Required to work
		ZTest Always Cull Off ZWrite Off
		Fog{ Mode off }

		Pass
		{
			CGPROGRAM
			
			//#pragma vertex vert_img
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			uniform sampler2D _MainTex;
			uniform half _Pixels;
			
			uniform half4 _Transmission;
			uniform half _Dissipation;
			uniform half _Minimum;

			// Mouse smoke
			uniform half2 _SmokeCentre;
			uniform float _SmokeRadius;


			struct vertOutput {
				float4 pos : SV_POSITION;	// Clip space
				float2 uv : TEXCOORD0;		// UV data
				float3 wPos : TEXCOORD1;	// World position
			};

			vertOutput vert(appdata_full v)
			{
				vertOutput o;
				o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
				o.uv = v.texcoord;
				o.wPos = mul(_Object2World, v.vertex).xyz;
				return o;
			}


			//float4 frag(v2f_img i) : COLOR
			float4 frag(vertOutput i) : COLOR
			{
				// Cell centre
				fixed2 uv = round(i.uv * _Pixels) / _Pixels;

				half s = 1 / _Pixels;

				float cl = tex2D(_MainTex, uv + fixed2(-s, 0)).a;	// Centre Left
				float tc = tex2D(_MainTex, uv + fixed2(-0, -s)).a;	// Top Centre
				float cc = tex2D(_MainTex, uv + fixed2(0, 0)).a;	// Centre Centre
				float bc = tex2D(_MainTex, uv + fixed2(0, +s)).a;	// Bottom Centre
				float cr = tex2D(_MainTex, uv + fixed2(+s, 0)).a;	// Centre Right

				float factor = 
					_Dissipation *
					(
						(
							cl * _Transmission.x +
							tc * _Transmission.y +
							bc * _Transmission.z +
							cr * _Transmission.w
						)
						- (_Transmission.x+ _Transmission.y+ _Transmission.z+ _Transmission.w) * cc
					);
				
				if (factor >= -_Minimum && factor < 0.0)
					factor = -_Minimum;
				cc += factor;


				// Mouse smoke
				if (distance(i.wPos, _SmokeCentre) < _SmokeRadius)
					cc = 1;

				return float4(1, 1, 1, cc);
				
			}
			ENDCG
		}
	}
}