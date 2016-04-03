// From the book Unity 5.x Shaders and Effects Cookbook
Shader "Ellioman/BlendModeScreenBlend"
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
			#pragma fragment frag
			#pragma fragmentoption ARB_precision_hint_fastest

			 // Helper functions
			 #include "UnityCG.cginc"

			uniform sampler2D _MainTex;
			uniform sampler2D _BlendTex;
			uniform fixed _Opacity;

			fixed4 frag(v2f_img i) : COLOR
			{
				// Get the colors from the RenderTexture and the uv's
				// from the v2f_img struct
				fixed4 renderTex = tex2D(_MainTex, i.uv);
				fixed4 blendTex = tex2D(_BlendTex, i.uv);

				// Multiply Blend Mode
				fixed4 blendedScreen = (1.0 - ((1.0 - renderTex) * (1.0 - blendTex)));

				// Adjust the blend mode with a lerp
				renderTex = lerp(renderTex, blendedScreen, _Opacity);

				return renderTex;
			}
		
		ENDCG
		}
	}
	FallBack "Diffuse"
}
