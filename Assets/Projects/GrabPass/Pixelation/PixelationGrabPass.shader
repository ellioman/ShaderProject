// Pixellates the pixels that are behind the object with this shader
Shader "Ellioman/PixelationGrabPass"
{
	// What variables do we want sent in to the shader?
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
				CGPROGRAM
					// Pragmas
					#pragma vertex vertexShader
					#pragma fragment fragmentShader
					#pragma fragmentoption ARB_precision_hint_fastest
					
					// Helper functions
					#include "UnityCG.cginc"
					
					// User Defined Variables
					uniform sampler2D _GrabTexture;
					uniform float4 _GrabTexture_TexelSize;
					uniform float _PixelSize;
					
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
						OUT.vertex = mul(UNITY_MATRIX_MVP, IN.vertex);
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
						float4 uv = IN.uvgrab;
						if (_PixelSize != 1.0)
						{
							_PixelSize /= 1000;//_ScreenParams.x * 1;
							int xxx = (IN.uvgrab.x / _PixelSize);
							uv.x = xxx * _PixelSize;
							
							int yyy = (IN.uvgrab.y / _PixelSize);
							uv.y = yyy * _PixelSize;
						}
						
						return tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(uv));
					}
				ENDCG
			}
		}
	}
}
