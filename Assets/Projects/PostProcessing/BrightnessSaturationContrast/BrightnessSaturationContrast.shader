// From the book Unity 5.x Shaders and Effects Cookbook
Shader "Ellioman/BrightnessSaturationContrast"
{
	// What variables do we want sent in to the shader?
	Properties
	{
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_BrightnessAmount ("_Brightness Amount", Range(0.0, 1.0)) = 1.0
		_SaturationAmount ("Saturation Amount", Range(0.0, 1.0)) = 1.0
		_ContrastAmount ("_Contrast Amount", Range(0.0, 1.0)) = 1.0
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
				uniform fixed _BrightnessAmount;
				uniform fixed _SaturationAmount;
				uniform fixed _ContrastAmount;
				
				// Our CSB function...
				float3 ContrastSaturationBrightness(float3 color, float brt, float sat, float con)
				{
					// Increase or decrease thses values to
					// adjust r, g, b, color channels separately
					float3 avgLum = float3(0.5, 0.5, 0.5);
					
					// Luminance coefficients for getting luminance from the image
					float3 luminanceCoEff = float3(0.2125, 0.7154, 0.0721);
					
					// Operation for Brightness
					float3 brtColor = color * brt;
					float intensityf = dot(brtColor, luminanceCoEff);
					float3 intensity = float3(intensityf, intensityf, intensityf);
					
					// Operation for Saturation
					float3 satColor = lerp(intensity, brtColor, sat);
					
					// Operation for Contrast
					float3 conColor = lerp(avgLum, satColor, con);
					return conColor;
				}
				
				// The Fragment Shader
				fixed4 fragmentShader(v2f_img IN) : COLOR
				{
					fixed4 renderTex = tex2D(_MainTex, IN.uv);
					renderTex.rgb = ContrastSaturationBrightness(renderTex.rgb, _BrightnessAmount, _SaturationAmount, _ContrastAmount);
					return renderTex;
				}
			ENDCG
		}
	}
	FallBack "Diffuse"
}
