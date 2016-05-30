// Blurs the contents of the screen behind the object
Shader "Ellioman/Blur"
{
	// What variables do we want sent in to the shader?
	Properties
	{
		_Blurryness ("Blur Amount", range (0,1024)) = 10
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
				
					// Pragmas
					#pragma vertex vertexShader
					#pragma fragment fragmentShader
					#pragma fragmentoption ARB_precision_hint_fastest
					
					// Helper functions
					#include "UnityCG.cginc"
					
					// User Defined Variables
					uniform sampler2D _GrabTexture;
					uniform float4 _GrabTexture_TexelSize;
					uniform float _Blurryness;
					
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
						OUT.uv =  IN.texcoord.xy;
						
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
						float offsetVal = _Blurryness;
						float4 uv = IN.uvgrab;
						half4 col = half4(0.0, 0.0, 0.0, 0.0);
						
						// Top level
						uv.y = IN.uvgrab.y + _GrabTexture_TexelSize.y * offsetVal;
						
						uv.x = IN.uvgrab.x + _GrabTexture_TexelSize.x * offsetVal;
						col += tex2Dproj( _GrabTexture, UNITY_PROJ_COORD(uv));
						
						uv.x = IN.uvgrab.x;
						col += tex2Dproj( _GrabTexture, UNITY_PROJ_COORD(uv));
						
						uv.x = IN.uvgrab.x - _GrabTexture_TexelSize.x * offsetVal;
						col += tex2Dproj( _GrabTexture, UNITY_PROJ_COORD(uv));
						
						// Middle level
						uv.y = IN.uvgrab.y;
						
						uv.x = IN.uvgrab.x + _GrabTexture_TexelSize.x * offsetVal;
						col += tex2Dproj( _GrabTexture, UNITY_PROJ_COORD(uv));
						
						uv.x = IN.uvgrab.x;
						col += tex2Dproj( _GrabTexture, UNITY_PROJ_COORD(uv));
						
						uv.x = IN.uvgrab.x - _GrabTexture_TexelSize.x * offsetVal;
						col += tex2Dproj( _GrabTexture, UNITY_PROJ_COORD(uv));
						
						// Bottom level
						uv.y = IN.uvgrab.y - _GrabTexture_TexelSize.y * offsetVal;
						
						uv.x = IN.uvgrab.x + _GrabTexture_TexelSize.x * offsetVal;
						col += tex2Dproj( _GrabTexture, UNITY_PROJ_COORD(uv));
						
						uv.x = IN.uvgrab.x;
						col += tex2Dproj( _GrabTexture, UNITY_PROJ_COORD(uv));
						
						uv.x = IN.uvgrab.x - _GrabTexture_TexelSize.x * offsetVal;
						col += tex2Dproj( _GrabTexture, UNITY_PROJ_COORD(uv));
						
						return col / 9;
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
