// Blurs the contents of the screen behind the object
Shader "Ellioman/Tint"
{
	// What variables do we want sent in to the shader?
	Properties
	{
		[HideInInspector] _MainTex ("Base (RGB)", 2D) = "white" {}
		_Tint ("Tint", color) = (1,1,1,1)
	}
	Category
	{
		SubShader
		{
			Pass
			{
				CGPROGRAM
					// Pragmas
					#pragma vertex vert_img // Use the helper vertex shader
					#pragma fragment fragmentShader
					
					// Helper functions
					#include "UnityCG.cginc"
					
					// User Defined Variables
					uniform sampler2D _MainTex;
					uniform float4 _MainTex_TexelSize;
					uniform float4 _Tint;
					
					// The Fragment Shader
					half4 fragmentShader(v2f_img IN) : COLOR
					{
						float4 c = tex2D(_MainTex, IN.uv);
						
						// Make the image black/white
						// The three magic numbers represent the sensitivity of the Human eye
						// to the R, G and B components. This is taken from
						// http://www.alanzucconi.com/2015/07/08/screen-shaders-and-postprocessing-effects-in-unity3d/
						float lum = c.r*.3 + c.g*.59 + c.b*.11;
						float3 bw = float3(lum, lum, lum); 
						
						// Tint the image
						float4 result = c;
						result.rgb = bw * _Tint.rgb;
						return lerp(c, result, _Tint.a);
					}
				ENDCG
			}
		}
	}
}
