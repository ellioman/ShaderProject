Shader "Ellioman/Culling"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		[Enum(Off,0,Front,1,Back,2)] _CullMode ("Cull", Int) = 1

	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		Cull [_CullMode]
		LOD 100

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
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				return tex2D(_MainTex, i.uv);
			}
			ENDCG
		}
	}
	// Use a Custom C# Editor script for this shader
	CustomEditor "CullingMaterialEditor"
}
