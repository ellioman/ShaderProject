// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Per pixel bumped refraction.
// Uses a normal map to distort the image behind, and
// an additional texture to tint the color.

Shader "Ellioman/Glass/GlassStained"
{
	Properties
	{
		_BumpAmt ("Distortion", range (0,1024)) = 10
		_MainTex ("Tint Color (RGB)", 2D) = "white" {}
		_BumpMap ("Normalmap", 2D) = "bump" {}
	}
	
	Category
	{
		// We must be transparent, so other objects are drawn before this one.
		Tags
		{
			"Queue"="Transparent+100"
			"RenderType"="Opaque"
		}
		
		SubShader
		{
			// This pass grabs the screen behind the object into a texture.
			// We can access the result in the next pass as _GrabTexture
			GrabPass 
			{
				"_GrabTexture"								
				Name "BASE"
				Tags
				{
					"LightMode" = "Always"
				}
			}
			
			// Main pass: Take the texture grabbed above and use the 
			// bumpmap to perturb it on to the screen
			Pass
			{
				Name "BASE"
				Tags
				{
					"LightMode" = "Always"
				}
				
				CGPROGRAM
					// What functions should we use for the vertex and fragment shaders?
					#pragma vertex vertexShader
					#pragma fragment fragmentShader
					#pragma fragmentoption ARB_precision_hint_fastest
					
					// Helper functions
					#include "UnityCG.cginc"
					
					// User Defined Variables
					float _BumpAmt;
					sampler2D _GrabTexture;
					float4 _GrabTexture_TexelSize;
					sampler2D _BumpMap;
					sampler2D _MainTex;
					
					// These are created by Unity when we use the TRANSFORM_TEX Macro in the
					// vertex shader. XY values controls the texture tiling and ZW the offset
					float4 _BumpMap_ST;
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
					
					VSOutput vertexShader(VSInput IN)
					{
						VSOutput OUT;
						OUT.vertex = UnityObjectToClipPos(IN.vertex);
						#if UNITY_UV_STARTS_AT_TOP
						OUT.vertex.y *= -1;
						#endif
						
						OUT.uvgrab.xy = (float2(OUT.vertex.x, OUT.vertex.y) + OUT.vertex.w) * 0.5;
						OUT.uvgrab.zw = OUT.vertex.zw;
						OUT.uvbump = TRANSFORM_TEX(IN.texcoord, _BumpMap);
						OUT.uvmain = TRANSFORM_TEX(IN.texcoord, _MainTex);
						return OUT;
					}
					
					// Fragment Shader
					half4 fragmentShader(VSOutput IN) : COLOR
					{
						// calculate perturbed coordinates
						half2 bump = UnpackNormal(tex2D(_BumpMap, IN.uvbump)).rg; // we could optimize this by just reading the x & y without reconstructing the Z
						float2 offset = bump * _BumpAmt * _GrabTexture_TexelSize.xy;
						IN.uvgrab.xy = offset * IN.uvgrab.z + IN.uvgrab.xy;
						
						half4 col = tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(IN.uvgrab));
						half4 tint = tex2D(_MainTex, IN.uvmain);
						return col * tint;
					}
				ENDCG
			}
		}
		
		// ------------------------------------------------------------------
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
