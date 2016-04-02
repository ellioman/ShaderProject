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
		//LOD 200

		Pass
		{
		CGPROGRAM

			#pragma vertex vert_img
			#pragma fragment frag
			#pragma fragmentoption ARB_precision_hint_fastest

			 // Helper functions
			 #include "UnityCG.cginc"

	//		// Use shader model 3.0 target, to get nicer looking lighting
	//		#pragma target 3.0

			uniform sampler2D _MainTex;
			uniform sampler2D _CameraDepthTexture; // Build in texture from UnityCG.cginc that gives us depth info
			uniform fixed _DepthPower;

			fixed4 frag(v2f_img i) : COLOR
			{
				// Get the colors from the RenderTexture and the uv's 
				// from the v2f_img struct
				float d = UNITY_SAMPLE_DEPTH(tex2D(_CameraDepthTexture, i.uv.xy));
				d = pow(Linear01Depth(d), _DepthPower);
				return d;
			}
		
		ENDCG
		}
	}
	FallBack "Diffuse"
}
