// Blurs the contents of the screen behind the object
Shader "Ellioman/BlackWhite"
{
	// What variables do we want sent in to the shader?
	Properties
	{
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_bwBlend ("Black & White blend", Range (0, 1)) = 0
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
					uniform float _bwBlend;
					
					// The Fragment Shader
					half4 fragmentShader(v2f_img i) : COLOR
					{
						float4 c = tex2D(_MainTex, i.uv);
						
						// The three magic numbers represent the sensitivity of the Human eye
						// to the R, G and B components. This is taken from
						// http://www.alanzucconi.com/2015/07/08/screen-shaders-and-postprocessing-effects-in-unity3d/
						float lum = c.r*.3 + c.g*.59 + c.b*.11;
						float3 bw = float3(lum, lum, lum); 
						
						float4 result = c;
						result.rgb = lerp(c.rgb, bw, _bwBlend);
						return result;
					}
				ENDCG
			}
		}
	}
}
