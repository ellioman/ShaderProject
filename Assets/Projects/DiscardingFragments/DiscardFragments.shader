Shader "Ellioman/DiscardFragments"
{
	Properties
	{
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Glossiness ("Smoothness", Range(0,1)) = 0.5
		_Metallic ("Metallic", Range(0,1)) = 0.0
		_DiscardLimit("Discard Limit", Range(0.0, 1.0)) = 0.5
		_DiscardScale("Discard Scale", vector) = (1.0, 1.0, 1.0, 1.0)
	}
	SubShader
	{
		cull off
		Tags
		{
			"RenderType"="Opaque"
		}
		LOD 200
		
		CGPROGRAM
		#pragma surface surfaceShader Standard fullforwardshadows nolightmap
		#pragma target 3.0 // Use shader model 3.0 target, to get nicer looking lighting

		sampler2D _MainTex;
		half _Glossiness;
		half _Metallic;
		fixed4 _Color;
		float _DiscardLimit;
		float2 _DiscardScale;

		struct Input
		{
			float2 uv_MainTex;
		};

		void surfaceShader(Input IN, inout SurfaceOutputStandard o)
		{
			float2 aa = step(frac(IN.uv_MainTex * _DiscardScale), float2(_DiscardLimit, _DiscardLimit));
			if (all(bool2(aa)))
			{
				discard;
			}

			// Albedo comes from a texture tinted by color
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
			o.Albedo = c.rgb;
			// Metallic and smoothness come from slider variables
			o.Metallic = _Metallic;
			o.Smoothness = _Glossiness;
			o.Alpha = _Color.a;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
