// The Shader takes two textures and blends them together using the _MainTexMultiplier
Shader "Ellioman/RenderPasses/Pass1"
{
	// What variables do we want sent in to the shader?
	Properties
	{
		[HideInInspector] _MainTex ("Base (RGB)", 2D) = "white" {}
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

				// The Fragment Shader				
				half4 frag(v2f_img i) : COLOR
				{
					//float zoomVal = (_SinTime * 0.5) + 0.5;
					//i.uv = map(i.uv, zoomVal * 0.5, 1.0 - zoomVal * 0.5);
					// Get the color value from the textures
					float4 aa = tex2D(_MainTex, i.uv);

					return float4(0.0, 0.0, 0.0, 0.0);//aa + float4(0.25, 0.25, 0.25, 0.0); 
				}
 			
			ENDCG
		}
	}
}