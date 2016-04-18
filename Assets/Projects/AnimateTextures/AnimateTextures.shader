Shader "Ellioman/AnimateTextures"
{
	Properties
	{
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_ControlTex ("Control (RGB)", 2D) = "white" {}
		_Color ("Color", Color) = (1,1,1,1)
		_Speed ("Speed", Range(0.0, 10.0)) = 1.0
		_SliderR ("R", Range(0.0, 1.0)) = 0.5
		_SliderG ("G", Range(0.0, 1.0)) = 0.5
		_SliderB ("B", Range(0.0, 1.0)) = 0.5
		_SliderA ("A", Range(0.0, 1.0)) = 0.5
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM


		#pragma surface surf Lambert

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _MainTex;
		sampler2D _ControlTex;
		fixed4 _Color;
		float _Speed;
		float _SliderR;
		float _SliderG;
		float _SliderB;
		float _SliderA;

		struct Input
		{
			float2 uv_MainTex;
		};

		void surf (Input IN, inout SurfaceOutput o)
		{
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
			fixed4 con = tex2D (_ControlTex, IN.uv_MainTex);

			float time = _Time * _Speed;//sin(_Time.w) * 0.5 + 0.5;
			time = sin(_Time.w) * 0.5 + 0.5;

			_SliderR = time;
			_SliderG = time;
			_SliderB = time;
			_SliderA = time;

			c.rgb += ((step(1.01 - con.r, _SliderR)));
			c.rgb += ((step(1.01 - con.g, _SliderG)));
			c.rgb += ((step(1.01 - con.b, _SliderB)));
			c.rgb += ((step(1.01 - con.a, _SliderA)));

			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
