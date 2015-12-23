// Blurs the contents of the screen behind the object
Shader "Ellioman/Pixels"
{
	Properties
	{
		_PixelSize ("Pixel Size", range (1,1024)) = 1
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
						float2 uv : TEXCOORD0;
						float4 uvgrab : TEXCOORD1;
					};
					
					// User-specified properties
					sampler2D _GrabTexture;
					float4 _GrabTexture_TexelSize;
					float _PixelSize;
					
					// ---------------------------
					// Shaders
					// ----------------------------
		 			
		 			// The Vertex Shader 
					v2f vert (appdata_t v)
					{
						v2f o;
						o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);
						o.uv =  v.texcoord.xy;
						
						#if UNITY_UV_STARTS_AT_TOP
						float scale = -1.0;
						#else
						float scale = 1.0;
						#endif
						
						o.uvgrab.xy = (float2(o.vertex.x, o.vertex.y*scale) + o.vertex.w) * 0.5;
						o.uvgrab.zw = o.vertex.zw;
						
						return o;
					}

					// The Fragment Shader				
					half4 frag(v2f i) : COLOR
					{
						float4 uv = i.uvgrab;
						if (_PixelSize != 1.0)
						{
							_PixelSize /= 10000;//_ScreenParams.x * 1;
							int xxx = (i.uvgrab.x / _PixelSize);
							uv.x = xxx * _PixelSize;

							int yyy = (i.uvgrab.y / _PixelSize);
							uv.y = yyy * _PixelSize;
						}


						return tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(uv));
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
