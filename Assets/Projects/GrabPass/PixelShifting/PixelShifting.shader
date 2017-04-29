// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Blurs the contents of the screen behind the object
Shader "Ellioman/GrabPassShifter"
{
	Properties
	{
		_XDirection ("X Direction", range(-50,50)) = 0
		_YDirection ("Y Direction", range(-50,50)) = 0
	}
	Category
	{
		// Subshaders use tags to tell how and when they 
		// expect to be rendered to the rendering engine
		// We must be transparent, so other objects are drawn before this one.
		Tags
		{
			"Queue"="Transparent+100"
			"RenderType"="Opaque"
		}
		
		SubShader
		{
			// ---------------------------
			// GrabPass
			// This pass grabs the screen behind the object into a texture.
			// We can access the result in the next pass as _GrabTexture
			// ----------------------------
			
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
				// Pass name
				Name "BASE"
				
				// Subshaders use tags to tell how and when they 
				// expect to be rendered to the rendering engine
				Tags
				{
					"Queue"="Transparent+1000"
					"LightMode" = "Always"
				}
				
				CGPROGRAM
					// What functions should we use for the vertex and fragment shaders?
					#pragma vertex vertexShader
					#pragma fragment fragmentShader
					#pragma fragmentoption ARB_precision_hint_fastest
					
					// Include some commonly used helper functions
					#include "UnityCG.cginc"
					
					// User Defined Variables
					sampler2D _GrabTexture;
					float4 _GrabTexture_TexelSize;
					float _XDirection;
					float _YDirection;
					
					// Base Input Structs
					struct VSInput
					{
						float4 vertex : POSITION;
						float2 texcoord: TEXCOORD0;
					};
					
					struct VSOutput
					{
						float4 vertex : POSITION;
						float2 uv : TEXCOORD0;
						float4 uvgrab : TEXCOORD1;
					};
					
		 			// The Vertex Shader 
					VSOutput vertexShader(VSInput IN)
					{
						VSOutput OUT;
						OUT.vertex = UnityObjectToClipPos(IN.vertex);
						OUT.uv = IN.texcoord.xy;
						
						#if UNITY_UV_STARTS_AT_TOP
						float scale = -1.0;
						#else
						float scale = 1.0;
						#endif
						
						OUT.uvgrab.xy = (float2(OUT.vertex.x, OUT.vertex.y*scale) + OUT.vertex.w) * 0.5;
						OUT.uvgrab.zw = OUT.vertex.zw;
						return OUT;
					}
					
					// The Fragment Shader
					half4 fragmentShader(VSOutput IN) : COLOR
					{
						float2 offsetVec = (float2(_XDirection, _YDirection));
						float4 uv = IN.uvgrab + _GrabTexture_TexelSize * float4(offsetVec.x, offsetVec.y, 0.0, 0.0);
						half4 col = tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(uv));
						return col;
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
