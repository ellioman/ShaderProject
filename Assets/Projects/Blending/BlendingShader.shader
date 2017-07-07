Shader "Ellioman/Blending"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		[Enum(Zero,0,One,1,DstColor,2,SrcColor,3,OneMinusDstColor,4,SrcAlpha,5,OneMinusSrcColor,6,DstAlpha,7,OneMinusDstAlpha,8,SrcAlphaSaturate,9,OneMinusSrcAlpha,10)] _SourceBlendMode ("Source BlendMode", Int) = 0
		[Enum(Zero,0,One,1,DstColor,2,SrcColor,3,OneMinusDstColor,4,SrcAlpha,5,OneMinusSrcColor,6,DstAlpha,7,OneMinusDstAlpha,8,SrcAlphaSaturate,9,OneMinusSrcAlpha,10)] _DestinationBlendMode ("Destination BlendMode", Int) = 0
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100
		Blend [_SourceBlendMode] [_DestinationBlendMode]

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
				UNITY_FOG_COORDS(1)
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				// sample the texture
				fixed4 col = tex2D(_MainTex, i.uv);
				// apply fog
				UNITY_APPLY_FOG(i.fogCoord, col);
				return col;
			}
			ENDCG
		}
	}

	// Use a Custom C# Editor script for this shader
	CustomEditor "BlendingMaterialEditor"
}
