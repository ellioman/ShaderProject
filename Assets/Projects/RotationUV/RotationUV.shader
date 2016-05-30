// Rotates the uv coordinates of the texture
Shader "Ellioman/RotateUV"
{
	// What variables do we want sent in to the shader?
	Properties
	{
		_MainTex ("Texture (RGB)", 2D) = "white" {}
		_RotationSpeed ("Rotation Speed", Float) = 2.0
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
				uniform float _RotationSpeed;
				uniform float4 _MainTex_ST;
				
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
				
				// Rotates the UV Coordinate sent as a parameter
				float4 CalculateRotation(float4 uv)
				{
					// Small play with the Tiling a little bit
					//float change = 0.05;
					//_MainTex_ST.xy *= ((1.0 - change) + _SinTime.x * _CosTime.a * change);
					
					// Scale and offset the UV with the values in the Editor
					uv.xy = TRANSFORM_TEX(uv, _MainTex).xy;
					
					// How much rotation do we have right now?
					float rotation = _RotationSpeed * _Time.y;
					
					// Calculate the value we need to shift the center to (0,0)
					// using the tiling and offset set in the Editor (_MainTex_ST)
					float2 div = (_MainTex_ST.xy / 2.0)  + _MainTex_ST.ba;
					
					// Shift the center of the coordinates to (0,0)
					uv.xy -= div; 
					
					// Create the Rotation Matrix
					float s, c;
					sincos(radians(rotation), s, c); // compute the sin and cosine
					float2x2 rotationMatrix = float2x2(c, -s, s, c);
					
					// Use the rotation matrix to rotate the UV coordinates
					uv.xy = mul(uv.xy, rotationMatrix);
					
					// Shift the center of the coordinates back to (0.5,0.5)
					uv.xy += div;
					
					return uv;
				}
				
				// The Vertex Shader 
				VSOutput vertexShader(VSInput IN)
				{
					VSOutput OUT;
					OUT.position = mul(UNITY_MATRIX_MVP, IN.vertex);
					OUT.texcoord0.xy = CalculateRotation(IN.texcoord0);
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