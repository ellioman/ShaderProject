
Shader "Ellioman/Water"
{
	Properties
	{
		_Color ("Color", Color) = (0,0,0,0)
		_Distortion ("Distortion", range (0,150)) = 10
		_NormalMap ("Normalmap", 2D) = "bump" {}
	}
	
	Category
	{
		// We must be transparent, so other objects are drawn before this one.
		Tags
		{
			"Queue"="Transparent+100"
			"RenderType"="Transparent"
		}
		
		// Show both sides
		Cull Off
		
		SubShader
		{
			// This pass grabs the screen behind the object into a texture.
			// We can access the result in the next pass as _GrabTexture
			GrabPass 
			{
				"_GrabTexture"								
				Name "BASE"
				Tags { "LightMode" = "Always" }
	 		}
	 		
	 		// Main pass: Take the texture grabbed above and use the 
	 		// bumpmap to perturb it on to the screen
			Pass
			{
				Name "BASE"
				Tags { "LightMode" = "Always" }
				Blend SrcAlpha OneMinusSrcAlpha
				CGPROGRAM
					// Pragmas
					#pragma vertex vertexShader
					#pragma fragment fragmentShader
					#pragma fragmentoption ARB_precision_hint_fastest
					
					// Helper functions
					#include "UnityCG.cginc"
					
					// User Defined Variables
					float _Distortion;
					float4 _Color;
					float4 _GrabTexture_TexelSize;
					sampler2D _NormalMap;
					sampler2D _GrabTexture;
					
					// These are created by Unity when we use the TRANSFORM_TEX Macro in the
					// vertex shader. XY values controls the texture tiling and ZW the offset
					float4 _NormalMap_ST;
					float4 _MainTex_ST;
					
					// Base Input Structs
					struct VSInput
					{
						float4 vertex : POSITION;
						float2 texcoord: TEXCOORD0;
					};
					
					struct VSOutput
					{
						float4 vertex : POSITION;
						float4 uvgrab : TEXCOORD0;
						float2 uvbump : TEXCOORD1;
						float2 uvmain : TEXCOORD2;
					};
					
					// The Vertex Shader
					VSOutput vertexShader(VSInput IN)
					{
						VSOutput OUT;
						OUT.vertex.y += sin(_Time.w) * 0.01;
						OUT.vertex = mul(UNITY_MATRIX_MVP, IN.vertex);
						_NormalMap_ST.z += _Time.x;
						
						OUT.uvmain = IN.texcoord;
						OUT.uvgrab.xy = (float2(OUT.vertex.x, OUT.vertex.y) + OUT.vertex.w) * .5;
						OUT.uvgrab.zw = OUT.vertex.zw;
						OUT.uvbump = TRANSFORM_TEX(IN.texcoord, _NormalMap);
						
						return OUT;
					}
					
					// The Fragment Shader
					half4 fragmentShader(VSOutput IN) : COLOR
					{
						// calculate perturbed coordinates
						half2 bump = UnpackNormal(tex2D(_NormalMap, IN.uvbump)).rg;
						float2 offset = bump * _Distortion * _GrabTexture_TexelSize.xy;
						IN.uvgrab.x = offset.x * IN.uvgrab.z + IN.uvgrab.x;
						IN.uvgrab.y = offset.y * IN.uvgrab.z + IN.uvgrab.y;
						
						half4 col = tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(IN.uvgrab));
						return col * _Color;
					}
				ENDCG
			}
		}

		// Fallback for older cards and Unity non-Pro
		SubShader
		{
			Blend DstColor Zero
			Pass
			{
				Name "BASE"
				SetTexture [_MainTex] {	combine texture }
			}
		}
	}
}
