// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// 
Shader "Ellioman/BlackWhiteGrabPass"
{
	// What variables do we want sent in to the shader?
	Properties
	{
		_bwBlend ("Black & White blend", Range (0, 1)) = 0
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
					uniform float _bwBlend;
					
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
						float4 c = tex2Dproj( _GrabTexture, UNITY_PROJ_COORD(IN.uvgrab));
						
						// The three magic numbers represent the sensitivity of the Human eye
						// to the R, G and B components. This is taken from
						// http://www.alanzucconi.com/2015/07/08/screen-shaders-and-postprocessing-effects-in-unity3d/
						float lum = c.r*.3 + c.g*.59 + c.b*.11;
						float3 bw = float3(lum, lum, lum); 
						float4 result = c;
						result.rgb = lerp(c.rgb, bw, _bwBlend);
						return result;
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
