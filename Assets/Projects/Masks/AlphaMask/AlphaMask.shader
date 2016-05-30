Shader "Ellioman/Masks/AlphaMask"
{
	Properties
	{
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_AlphaMask ("Alpha Mask", 2D) = "white" {}
		_AlphaAmount ("Alpha Amount", Range (-1,1)) = 1
	}
	
	CGINCLUDE
		// User Defined Variables
		sampler2D _MainTex;
		sampler2D _BumpMap;
		sampler2D _AlphaMask;
		half _AlphaAmount;
		
		// Base Input Structs
		struct Input
		{
			float2 uv_MainTex;
			float2 uv_AlphaMask;
		};
	ENDCG

	SubShader
	{
		Cull off
		ZWrite on
		ColorMask RGBA
		Blend SrcAlpha OneMinusSrcAlpha
		Tags
		{
			"RenderType"="Transparent"
		}
		LOD 200
		
		CGPROGRAM
			#pragma surface surfaceShader Lambert alpha
			#pragma target 3.0
			
			// The Surface Shader
			void surfaceShader(Input IN, inout SurfaceOutput o)
			{
				// Albedo comes from a texture tinted by color
				fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
				float aMask = tex2D (_AlphaMask, IN.uv_AlphaMask).g - _AlphaAmount;
				o.Albedo = c.rgb;
				o.Alpha = aMask;
			}
		ENDCG
	}
	
	Fallback off
}