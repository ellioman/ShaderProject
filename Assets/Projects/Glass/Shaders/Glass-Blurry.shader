// Blurs the contents of the screen behind the object
Shader "Glass/Blurry"
{
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
	 		
	 		// Main pass: Take the texture grabbed above and use the bumpmap to perturb it
	 		// on to the screen
			Pass
			{
				Name "BASE"
				Tags { "LightMode" = "Always" }
				
				CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag
				#pragma fragmentoption ARB_precision_hint_fastest
				#include "UnityCG.cginc"

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

				sampler2D _GrabTexture;
				float4 _GrabTexture_TexelSize;
				half4 frag( v2f i ) : COLOR
				{
					float offsetVal = 195f;
					float4 uv = i.uvgrab;
					half4 col;
					
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
					
					return col / 9f;
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
