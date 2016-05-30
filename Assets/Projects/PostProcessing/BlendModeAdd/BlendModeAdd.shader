// From the book Unity 5.x Shaders and Effects Cookbook
Shader "Ellioman/BlendModeAdd"
{
	// What variables do we want sent in to the shader?
	Properties
	{
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_BlendTex ("Blend Texture (RGB)", 2D) = "white" {}
		_Opacity ("Blend Opacity", Range(0.0, 1.0)) = 1.0
	}
	
	SubShader
	{
		Tags
		{
			"RenderType"="Opaque"
		}
		
		Pass
		{
			CGPROGRAM
				#pragma vertex vert_img
				#pragma fragment fragmentShader
				#pragma fragmentoption ARB_precision_hint_fastest
				
				// Helper functions
				#include "UnityCG.cginc"
				
				// User Defined Variables
				uniform sampler2D _MainTex;
				uniform sampler2D _BlendTex;
				uniform fixed _Opacity;
				
				// The Fragment Shader
				fixed4 fragmentShader(v2f_img IN) : COLOR
				{
					// Get the colors from the RenderTexture and the uv's
					// from the v2f_img struct
					fixed4 renderTex = tex2D(_MainTex, IN.uv);
					fixed4 blendTex = tex2D(_BlendTex, IN.uv);
					
					// Multiply Blend Mode
					fixed4 blendedAdd = renderTex + blendTex;
					
					// Adjust the blend mode with a lerp
					renderTex = lerp(renderTex, blendedAdd, _Opacity);
					return renderTex;
				}
			ENDCG
		}
	}
	FallBack "Diffuse"
}
