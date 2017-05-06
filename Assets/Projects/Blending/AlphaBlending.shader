// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// The Shader outputs a transparent object using alpha blending
Shader "Ellioman/Blending/AlphaBlending"
{
	// What variables do we want sent in to the shader?
	Properties
	{
		_MainTex ("Texture to blend", 2D) = "black" {}
		_Color ("Color", Color) = (1,1,1,1)
	}
	
	SubShader
	{
		// Draw after all opaque geometry has been drawn
		Tags
		{
			"Queue" = "Transparent"
		}
		
		// Grab the screen behind the object and put it into _GrabTexture
		GrabPass 
		{
			// Name of the variable holding the GrabPass output
			"_GrabTexture"
			
			// Pass name
			Name "BASE"
			
			// Tags for the pass
			Tags
			{
				"LightMode" = "Always"
			}
 		}
		
		Pass
		{
			// Don't write to depth buffer in order not to occlude other objects
			ZWrite Off 
			
			// Use alpha blending
			// float4 result = float4(1.0) * fragment_output + (float4(1.0) - fragment_output.aaaa) * pixel_color;
			Blend SrcAlpha OneMinusSrcAlpha
			
			CGPROGRAM
				// Pragmas
				#pragma vertex vertexShader
				#pragma fragment fragmentShader
				
				// Helper functions
				#include "UnityCG.cginc"
				
				// User Defined Variables
				uniform fixed4 _Color;
				uniform sampler2D _MainTex;
				
				// What variables do I want in the Vertex & Fragment shaders?
				struct VSInput
				{
					float4 vertex : POSITION;
					float4 texcoord0 : TEXCOORD0;
				};
				
				struct VSOutput
				{
					float4 position : SV_POSITION;
					float4 texcoord0 : TEXCOORD0;
				};
				
				// The Vertex Shader 
				VSOutput vertexShader(VSInput IN)
				{
					VSOutput OUT;
					OUT.position = UnityObjectToClipPos(IN.vertex);
					OUT.texcoord0 = IN.texcoord0;
					return OUT;
				}
				
				// The Fragment Shader
				fixed4 fragmentShader(VSOutput IN) : Color
				{
					return tex2D(_MainTex, IN.texcoord0) * _Color;
				}
			ENDCG
		}
	}
}