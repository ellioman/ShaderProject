// The Shader takes two textures and blends them together using the _MainTexMultiplier
Shader "Ellioman/CombineTexturesOverlay"
{
	// What variables do we want sent in to the shader?
	Properties
	{
		[HideInInspector] _MainTex ("Base (RGB)", 2D) = "white" {}
		_SecondTex ("Base (RGB)", 2D) = "white" {} 
		_SecondTexMultiplier ("Second Tex Multiplier", Range(0, 10)) = 0.5
		_ResultMultiplier ("Results Multiplier", Range(0, 10)) = 0.5
		_Tint ("Tint", color) = (1,1,1,1)
	}
	
	SubShader
	{
		Pass
		{
			CGPROGRAM
				
				// Pragmas
				#pragma vertex vert_img // Use the helper vertex shader
				#pragma fragment frag
				
				// Helper functions
				#include "UnityCG.cginc"
				
				// User Defined Variables
				uniform sampler2D _MainTex; 
				uniform float4 _MainTex_TexelSize;
				uniform sampler2D _SecondTex;
				uniform float _SecondTexMultiplier;
				uniform float _ResultMultiplier;
				uniform float4 _Tint;

				// Maps a vector to a new range
				half2 map(half2 uv, float lower, float upper)
				{
					float p = upper - lower;
					half2 k = half2(uv.x * p, uv.y * p);
					k.x += lower;
					k.y += lower;
					return k;
				}

				// The Fragment Shader				
				half4 frag(v2f_img i) : COLOR
				{
					//float zoomVal = (_SinTime * 0.5) + 0.5;
					//i.uv = map(i.uv, zoomVal * 0.5, 1.0 - zoomVal * 0.5);
					// Get the color value from the textures
					float4 a = tex2D(_MainTex, i.uv);

					// Map the texture UV's so its between 0.05 and 0.95
					i.uv = map(i.uv, 0.05, 0.95);
					float4 b = tex2D(_SecondTex, i.uv);

					// Blend the two color values
					float4 c = _ResultMultiplier * (a + b * _SecondTexMultiplier);
					float lum = c.r*.3 + c.g*.59 + c.b*.11;
					float3 bw = float3(lum, lum, lum); 

					float4 result = c;
					result.rgb = bw * _Tint.rgb;
					return result;
				}
 			
			ENDCG
		}
	}
	Fallback "VertexLit"
}