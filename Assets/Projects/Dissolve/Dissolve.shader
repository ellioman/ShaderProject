// A simple "dissolving" shader
// http://wiki.unity3d.com/index.php/Dissolve_With_Texture
// Use clouds or random noise as the slice guide for best results.
Shader "Ellioman/Dissolve/Dissolving"
{
	// What variables do we want sent in to the shader?
	Properties
	{
		_MainTex ("Texture (RGB)", 2D) = "white" {}
		_SliceGuide ("Slice Guide (RGB)", 2D) = "white" {}
		_SliceAmount ("Slice Amount", Range(0.0, 1.0)) = 0.5
	}
	
	SubShader
	{
		Tags
		{
			"RenderType" = "Opaque"
		}
		
		// Show both sides
		Cull Off
		
		CGPROGRAM
			// Pragmas
			// If you're not planning on using shadows, remove "addshadow" for better performance
			#pragma surface surf Lambert addshadow
			
			// User Defined Variables
			uniform sampler2D _MainTex;
			uniform sampler2D _SliceGuide;
			uniform float _SliceAmount;
			
			// Base Input Structs
			struct Input
			{
				float2 uv_MainTex;
				float2 uv_SliceGuide;
				float _SliceAmount;
			};
			
			// Surface Shader
			void surf(Input IN, inout SurfaceOutput OUT)
			{
				// Get the value for this pixel from the slice guide...
				float3 pixelValue = tex2D (_SliceGuide, IN.uv_SliceGuide).rgb - _SliceAmount;
				
				// Kill the current pixel output if any component of the given vector is negative
				clip(pixelValue);
				
				// Otherwise we just display the picture
				OUT.Albedo = tex2D (_MainTex, IN.uv_MainTex).rgb;
			}
		ENDCG
	} 
	Fallback "Diffuse"
}