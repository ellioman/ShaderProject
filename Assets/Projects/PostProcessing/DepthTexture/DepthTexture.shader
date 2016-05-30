// From the book Unity 5.x Shaders and Effects Cookbook
Shader "Ellioman/DepthTexture"
{
	// What variables do we want sent in to the shader?
	Properties
	{
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_DepthPower ("Depth Power", Range(1,5)) = 1
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
				uniform sampler2D _CameraDepthTexture; // Build in texture from UnityCG.cginc that gives us depth info
				uniform fixed _DepthPower;
				
				// The Fragment Shader
				fixed4 fragmentShader(v2f_img IN) : COLOR
				{
					// Get the colors from the RenderTexture and the uv's 
					// from the v2f_img struct
					float d = UNITY_SAMPLE_DEPTH(tex2D(_CameraDepthTexture, IN.uv.xy));
					d = pow(Linear01Depth(d), _DepthPower);
					return d;
				}
			ENDCG
		}
	}
	FallBack "Diffuse"
}
