Shader "Ellioman/Deferred/DeferredTexturesShader"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100
		ZWrite off
		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;

			uniform sampler2D _CameraDepthTexture;    // Depth
			uniform sampler2D _CameraGBufferTexture0; // Diffuse
			uniform sampler2D _CameraGBufferTexture1; // Specular
			uniform sampler2D _CameraGBufferTexture2; // World Space Normal
			uniform sampler2D _CameraGBufferTexture3; // Emission + lighting + lightmaps + reflection probes buffer.


			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				if (i.uv.x < 0.5)
				{
					// Diffuse...
					// Down Left corner
					if (i.uv.y < 0.5)
					{
						i.uv *= 2.0;
						return tex2D(_CameraGBufferTexture0, i.uv);
					}
					// Depth...
					// Up left corner
					else
					{
						i.uv.y -= 0.5;
						i.uv *= 2.0;
						return tex2D(_CameraDepthTexture, i.uv).r;
					}
				}
				else 
				{
					i.uv.x -= 0.5;

					// Results..
					// Down right corner
					if (i.uv.y < 0.5)
					{
						i.uv *= 2.0;
						return tex2D(_CameraGBufferTexture3, i.uv);
					}
					// Normals...
					// Up right corner
					else
					{
						i.uv.y -= 0.5;
						i.uv *= 2.0;
						return tex2D(_CameraGBufferTexture2, i.uv);
					}
				}
			}
			ENDCG
		}
	}
}
