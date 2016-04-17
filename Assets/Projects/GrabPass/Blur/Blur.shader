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
					#pragma vertex vert
					#pragma fragment frag
					#pragma fragmentoption ARB_precision_hint_fastest
					
					// Helper functions
					#include "UnityCG.cginc"

					// User Defined Variables
					uniform sampler2D _GrabTexture;
					uniform float4 _GrabTexture_TexelSize;
					uniform float _Blurryness;

					// Base Input Structs
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
						float offsetVal = _Blurryness;
						float4 uv = i.uvgrab;
						half4 col = half4(0.0, 0.0, 0.0, 0.0);
						
						// Top level
						uv.y = i.uvgrab.y + _GrabTexture_TexelSize.y * offsetVal;
						
						uv.x = i.uvgrab.x + _GrabTexture_TexelSize.x * offsetVal;
						col += tex2Dproj( _GrabTexture, UNITY_PROJ_COORD(uv));
						
						uv.x = i.uvgrab.x;
						col += tex2Dproj( _GrabTexture, UNITY_PROJ_COORD(uv));

						uv.x = i.uvgrab.x - _GrabTexture_TexelSize.x * offsetVal;
						col += tex2Dproj( _GrabTexture, UNITY_PROJ_COORD(uv));
						
						// Middle level
						uv.y = i.uvgrab.y;
						
						uv.x = i.uvgrab.x + _GrabTexture_TexelSize.x * offsetVal;
						col += tex2Dproj( _GrabTexture, UNITY_PROJ_COORD(uv));
						
						uv.x = i.uvgrab.x;
						col += tex2Dproj( _GrabTexture, UNITY_PROJ_COORD(uv));

						uv.x = i.uvgrab.x - _GrabTexture_TexelSize.x * offsetVal;
						col += tex2Dproj( _GrabTexture, UNITY_PROJ_COORD(uv));
						
						// Bottom level
						uv.y = i.uvgrab.y - _GrabTexture_TexelSize.y * offsetVal;
						
						uv.x = i.uvgrab.x + _GrabTexture_TexelSize.x * offsetVal;
						col += tex2Dproj( _GrabTexture, UNITY_PROJ_COORD(uv));
						
						uv.x = i.uvgrab.x;
						col += tex2Dproj( _GrabTexture, UNITY_PROJ_COORD(uv));

						uv.x = i.uvgrab.x - _GrabTexture_TexelSize.x * offsetVal;
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
