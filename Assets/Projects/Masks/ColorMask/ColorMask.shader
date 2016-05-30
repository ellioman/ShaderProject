Shader "Ellioman/Masks/ColorMask"
{
	Properties
	{
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_SecondTex ("Second Albedo (RGB)", 2D) = "white" {}
		_ColorMask ("Color Mask", 2D) = "white" {}
		_ColorAmount ("Color Amount", Range (-1,1)) = 1
	}
	
	CGINCLUDE
		// User Defined Variables
		sampler2D _MainTex;
		sampler2D _SecondTex;
		sampler2D _BumpMap;
		sampler2D _ColorMask;
		half _ColorAmount;
		
		// Base Input Structs
		struct Input
		{
			float2 uv_MainTex;
			float2 uv_ColorMask;
			float2 uv_SecondTex;
		};
	ENDCG
	
	SubShader
	{
		Cull off
		ZWrite on
		ColorMask RGBA
		Blend SrcAlpha OneMinusSrcAlpha
		Tags { "RenderType"="Transparent" }
		LOD 200
		
		CGPROGRAM
			#pragma surface surfaceShader Lambert alpha
			#pragma target 3.0
			
			// The Surface Shader
			void surfaceShader(Input IN, inout SurfaceOutput o)
			{
				fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
				fixed4 c2 = tex2D (_SecondTex, IN.uv_SecondTex);
				float cMask = clamp(tex2D (_ColorMask, IN.uv_ColorMask).r - _ColorAmount, 0, 1);
				o.Albedo = lerp(c.rgb, c2.rgb, cMask);
				o.Alpha = c.a;
			}
		ENDCG
	}
	Fallback off
}