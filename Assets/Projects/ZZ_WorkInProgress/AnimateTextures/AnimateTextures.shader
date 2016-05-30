Shader "Ellioman/AnimateTextures"
{
	Properties
	{
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_ControlTex ("Control (RGB)", 2D) = "white" {}
		_SecondTex ("Control (RGB)", 2D) = "white" {}
		_Color ("Color", Color) = (1,1,1,1)
		_Speed ("Speed", Range(0.0, 10.0)) = 1.0
		_SliderR ("R", Range(0.0, 1.0)) = 0.5
		_SliderG ("G", Range(0.0, 1.0)) = 0.5
		_SliderB ("B", Range(0.0, 1.0)) = 0.5
		_SliderA ("A", Range(0.0, 1.0)) = 0.5
	}
	
	SubShader
	{
		Tags
		{
			"RenderType"="Opaque"
		}
		LOD 200
		
		CGPROGRAM
			// Pragmas
			#pragma surface surf Lambert
			#pragma target 3.0// Use shader model 3.0 target, to get nicer looking lighting
			
			// User Defined Variables
			sampler2D _MainTex;
			sampler2D _ControlTex;
			sampler2D _SecondTex;
			fixed4 _Color;
			float _Speed;
			float _SliderR;
			float _SliderG;
			float _SliderB;
			float _SliderA;
			
			// Base Input Structs
			struct Input
			{
				float2 uv_MainTex;
			};

			// The Surface Shader
			void surf (Input IN, inout SurfaceOutput o)
			{
				fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
				fixed4 c2 = tex2D (_SecondTex, IN.uv_MainTex) * 1.0;
				fixed4 con = tex2D (_ControlTex, IN.uv_MainTex);

				float time = _Time * _Speed;
				time = sin(_Time.x * 7.0) * 0.5 + 0.5;
				_SliderR = time;

				time = sin(_Time.x * 7.0) * 0.5 + 0.5;
				_SliderG = time;
//				_SliderB = time;
//				_SliderA = time;

				float k = 0.0;

				k = step(1.000001 - con.r, _SliderR);
				c.rgb = lerp(c.rgb, c2.rgb, float3(k,k,k));

				k = step(1.000001 - con.g, _SliderG);
				c.rgb = lerp(c.rgb, c2.rgb, float3(k,k,k));
//
//				k = step(1.01 - con.b, _SliderB);
//				c.rgb = lerp(c.rgb, c2.rgb, float3(k,k,k));
//
//				k = step(1.01 - con.a, _SliderA);
//				c.rgb = lerp(c.rgb, c2.rgb, float3(k,k,k));

				o.Albedo = c.rgb;
				o.Alpha = c.a;
			}
		ENDCG
	}
	FallBack "Diffuse"
}
