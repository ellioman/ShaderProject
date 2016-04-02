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
				Tags { "LightMode" = "Always" }
	 		}
	 		
	 		// Main pass: Take the texture grabbed above and use the 
	 		// bumpmap to perturb it on to the screen
			Pass
			{
				Name "BASE"
				Tags { "LightMode" = "Always" }
				
				CGPROGRAM
				
					// What functions should we use for the vertex and fragment shaders?
					#pragma vertex vert
					#pragma fragment frag
					
					
					#pragma fragmentoption ARB_precision_hint_fastest
					
					// Include some commonly used helper functions
					#include "UnityCG.cginc"
					
					
					// ---------------------------
					// Variables
					// ---------------------------

					struct appdata_t
					{
						float4 vertex : POSITION;
						float2 texcoord: TEXCOORD0;
					};

					struct v2f
					{
						float4 vertex : POSITION;
						float4 uvgrab : TEXCOORD0;
						float2 uvbump : TEXCOORD1;
						float2 uvmain : TEXCOORD2;
					};
					
					// User-specified properties
					float _BumpAmt;
					sampler2D _GrabTexture;
					float4 _GrabTexture_TexelSize;
					sampler2D _BumpMap;
					sampler2D _MainTex;
					
					// These are created by Unity when we use the TRANSFORM_TEX Macro in the
					// vertex shader. XY values controls the texture tiling and ZW the offset
					float4 _BumpMap_ST;
					float4 _MainTex_ST;

					v2f vert (appdata_t v)
					{
						v2f o;
						o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);
						#if UNITY_UV_STARTS_AT_TOP
						o.vertex.y *= -1;
						#endif
						o.uvgrab.xy = (float2(o.vertex.x, o.vertex.y) + o.vertex.w) * 0.5;
						o.uvgrab.zw = o.vertex.zw;
						o.uvbump = TRANSFORM_TEX(v.texcoord, _BumpMap);
						o.uvmain = TRANSFORM_TEX(v.texcoord, _MainTex);
						return o;
					}
					
					// Fragment Shader
					half4 frag(v2f i) : COLOR
					{
						// calculate perturbed coordinates
						half2 bump = UnpackNormal(tex2D(_BumpMap, i.uvbump)).rg; // we could optimize this by just reading the x & y without reconstructing the Z
						float2 offset = bump * _BumpAmt * _GrabTexture_TexelSize.xy;
						i.uvgrab.xy = offset * i.uvgrab.z + i.uvgrab.xy;
						
						half4 col = tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(i.uvgrab));
						half4 tint = tex2D(_MainTex, i.uvmain);
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
