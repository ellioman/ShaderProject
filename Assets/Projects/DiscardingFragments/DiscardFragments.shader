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
			// Number of lattice rectangles per unit (scaled) texture coordinate
			float2 fractionalOfScaledTexCoord = frac(IN.uv_MainTex * _DiscardScale);

			// Check if the fractional part, for both x and y, is greater than the discard limit
			float2 shouldDiscard = step(fractionalOfScaledTexCoord, float2(_DiscardLimit, _DiscardLimit));

			// discard this fragment if x and y of the fractionalOfScaledTexCoord are greater than _DiscardLimit
			if (all(bool2(shouldDiscard)))
			{
				discard;
			}

			// Otherwise we render as normal...
			else
			{
				// Albedo comes from a texture tinted by color
				fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
				o.Albedo = c.rgb;
				// Metallic and smoothness come from slider variables
				o.Metallic = _Metallic;
				o.Smoothness = _Glossiness;
				o.Alpha = _Color.a;
			}
		}
		ENDCG
	}
	FallBack "Diffuse"
}
