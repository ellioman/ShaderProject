// From the book Unity 5.x Shaders and Effects Cookbook
Shader "Ellioman/2DWater"
{
	// What variables do we want sent in to the shader?
	Properties
	{
		_NoiseTex ("Noise Texture (RGB)", 2D) = "white" {}
		_Color ("Colour", Color) = (1,1,1,1)
		_Period ("Period", Range(0,50)) = 1
		_Magnitude ("Magnitude", Range(0,0.5)) = 0.05
		_Scale ("Scale", Range(0,10)) = 1
	}

	Category
	{
		SubShader
		{
			Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}
			ZWrite Off Lighting Off Cull Off Fog { Mode Off } Blend One Zero
			LOD 110

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
					
					// Helper functions
					#include "UnityCG.cginc"

					// User Defined Variables
					uniform sampler2D _GrabTexture;
					uniform float4 _GrabTexture_TexelSize;
					uniform sampler2D _NoiseTex;
					uniform fixed4 _Color;
					uniform float _Period;
					uniform float _Magnitude;
					uniform float _Scale;

					// Base Input Structs
					struct vertInput
					{
						float4 vertex : POSITION;
						float4 color : COLOR;
						float2 texcoord : TEXCOORD0;
					};

					struct vertOutput
					{
						float4 vertex : POSITION;
						float4 color : COLOR;
						float2 texcoord : TEXCOORD0;
						float2 worldpos : TEXCOORD1;
						float4 uvgrab : TEXCOORD2;
					};

		 			// The Vertex Shader 
					vertOutput vert (vertInput v)
					{
						vertOutput o;
						o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);
						o.worldpos = mul(_Object2World, v.vertex);
						o.uvgrab = ComputeGrabScreenPos(o.vertex);
						o.color = v.color;
						o.texcoord = v.texcoord;

						return o;
					}

					// The Fragment Shader				
					half4 frag(vertOutput i) : COLOR
					{

						float sinT = sin(_Time.w / _Period);
						float2 distortion;
						distortion.x = tex2D(_NoiseTex, i.worldpos.xy / _Scale + float2(sinT, 0)).r - 0.5;
						distortion.y = tex2D(_NoiseTex, i.worldpos.xy / _Scale + float2(0, sinT)).r - 0.5;

						i.uvgrab.xy += distortion * _Magnitude;

						float4 col = tex2Dproj( _GrabTexture, UNITY_PROJ_COORD(i.uvgrab));
						return col * _Color;
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
