
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
					float _Distortion;
					float4 _Color;
					float4 _GrabTexture_TexelSize;
					sampler2D _NormalMap;
					sampler2D _GrabTexture;

					// These are created by Unity when we use the TRANSFORM_TEX Macro in the
					// vertex shader. XY values controls the texture tiling and ZW the offset
					float4 _NormalMap_ST;
					float4 _MainTex_ST;

					v2f vert (appdata_t v)
					{
						v2f o;
						o.vertex.y += sin(_Time.w) * 0.01;
						o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);
						_NormalMap_ST.z += _Time.x;



						o.uvmain = v.texcoord;
						o.uvgrab.xy = (float2(o.vertex.x, o.vertex.y) + o.vertex.w) * .5;
						o.uvgrab.zw = o.vertex.zw;
						o.uvbump = TRANSFORM_TEX(v.texcoord, _NormalMap);



						return o;
					}
					
					// Fragment Shader
					half4 frag(v2f i) : COLOR
					{
						// calculate perturbed coordinates
						half2 bump = UnpackNormal(tex2D(_NormalMap, i.uvbump)).rg;

						float2 offset = bump * _Distortion * _GrabTexture_TexelSize.xy;
						i.uvgrab.x = offset.x * i.uvgrab.z + i.uvgrab.x;
						i.uvgrab.y = offset.y * i.uvgrab.z + i.uvgrab.y;

						half4 col = tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(i.uvgrab));
						return col * _Color;
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
