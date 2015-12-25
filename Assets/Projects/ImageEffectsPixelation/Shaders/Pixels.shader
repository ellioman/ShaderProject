// Blurs the contents of the screen behind the object
Shader "Ellioman/Pixels"
{
	// What variables do we want sent in to the shader?
	Properties
	{
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_PixelSize ("Pixel Size", range (1,100)) = 1
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
					#pragma fragment frag
					
					// Helper functions
					#include "UnityCG.cginc"
					
					// User Defined Variables
					uniform float _PixelSize;
					uniform sampler2D _MainTex;
					uniform float4 _MainTex_TexelSize;

					// The Fragment Shader				
					float4 frag(v2f_img i) : COLOR
					{
						half2 uv = i.uv;
						if (_PixelSize != 1.0)
						{
							_PixelSize *= _MainTex_TexelSize;
							int xxx = (i.uv.x / _PixelSize);
							uv.x = xxx * _PixelSize;

							int yyy = (i.uv.y / _PixelSize);
							uv.y = yyy * _PixelSize;
						}

						return tex2D(_MainTex, uv);
					}
					
				ENDCG
			}
		}
	}
}
