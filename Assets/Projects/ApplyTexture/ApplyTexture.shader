// The Shader uses the _MainTex input given and colors the object with it
Shader "Ellioman/ApplyTexture"
{
	// What variables do we want sent in to the shader?
	Properties
	{
		_MainTex ("Base (RGB)", 2D) = "white" {}
	}
	
	SubShader
	{
		Pass
		{
			CGPROGRAM
				// Pragmas
				#pragma vertex vertexShader
				#pragma fragment fragmentShader
				
				// Helper functions
				#include "UnityCG.cginc"
				
				// User Defined Variables
				uniform sampler2D _MainTex;
				
				// These are created by Unity when we use the TRANSFORM_TEX Macro in the
				// vertex shader. XY values controls the texture tiling and ZW the offset
				float4 _MainTex_ST;
				
				// Base Input Structs
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
					OUT.position = mul(UNITY_MATRIX_MVP, IN.vertex);
					OUT.texcoord0 = IN.texcoord0;
					OUT.texcoord0.xy = TRANSFORM_TEX(IN.texcoord0, _MainTex);
					return OUT;
				}
				
				// The Fragment Shader
				fixed4 fragmentShader(VSOutput IN) : SV_Target
				{
					return tex2D(_MainTex, IN.texcoord0);
				}
			ENDCG
		}
	}
	Fallback "VertexLit"
}