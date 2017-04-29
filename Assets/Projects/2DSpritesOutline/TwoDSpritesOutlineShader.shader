// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Author Ryan Nielson
// http://nielson.io/2016/04/2d-sprite-outlines-in-unity/
Shader "Ellioman/TwoDSpritesOutlineShader"
{
	Properties
	{
		[PerRendererData] _MainTex("Sprite Texture", 2D) = "white" {}
		_Color("Tint", Color) = (1,1,1,1)
		[MaterialToggle] PixelSnap("Pixel snap", Float) = 0

		// Add values to determine if outlining is enabled and outline color.
		[PerRendererData] _Outline("Outline", Float) = 0
		[PerRendererData] _OutlineColor("Outline Color", Color) = (1,1,1,1)
		[PerRendererData] _OutlineSize("Outline Size", int) = 1
	}

	SubShader
	{
		Tags
		{
			"Queue" = "Transparent"
			"IgnoreProjector" = "True"
			"RenderType" = "Transparent"
			"PreviewType" = "Plane"
			"CanUseSpriteAtlas" = "True"
		}

		Cull Off
		Lighting Off
		ZWrite Off
		Blend One OneMinusSrcAlpha

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile _ PIXELSNAP_ON
			#pragma shader_feature ETC1_EXTERNAL_ALPHA
			#include "UnityCG.cginc"

			int _OutlineSize;
			float _Outline;
			fixed4 _Color;
			fixed4 _OutlineColor;
			float4 _MainTex_TexelSize;
			sampler2D _MainTex;
			sampler2D _AlphaTex;

			struct appdata_t
			{
				float4 vertex   : POSITION;
				float4 color    : COLOR;
				float2 texcoord : TEXCOORD0;
			};

			struct v2f
			{
				float4 vertex   : SV_POSITION;
				fixed4 color : COLOR;
				float2 texcoord  : TEXCOORD0;
			};

			v2f vert(appdata_t IN)
			{
				v2f OUT;
				OUT.vertex = UnityObjectToClipPos(IN.vertex);
				OUT.texcoord = IN.texcoord;
				OUT.color = IN.color * _Color;
				#ifdef PIXELSNAP_ON
				OUT.vertex = UnityPixelSnap(OUT.vertex);
				#endif
				return OUT;
			}

			fixed4 frag(v2f IN) : SV_Target
			{
				fixed4 c = tex2D(_MainTex, IN.texcoord) * IN.color;

				// If outline is enabled and there is a pixel, try to draw an outline.
				if (_Outline > 0 && c.a != 0)
				{
					float totalAlpha = 1.0;

					// Unroll causes the compiler to assume there will never be 
					// more than sixteen iterations and the loop can be unrolled
					[unroll(16)]
					for (int i = 1; i < _OutlineSize + 1; i++)
					{
						fixed4 pixelUp = tex2D(_MainTex, IN.texcoord + fixed2(0, i * _MainTex_TexelSize.y));
						fixed4 pixelDown = tex2D(_MainTex, IN.texcoord - fixed2(0,i *  _MainTex_TexelSize.y));
						fixed4 pixelRight = tex2D(_MainTex, IN.texcoord + fixed2(i * _MainTex_TexelSize.x, 0));
						fixed4 pixelLeft = tex2D(_MainTex, IN.texcoord - fixed2(i * _MainTex_TexelSize.x, 0));
						totalAlpha = totalAlpha * pixelUp.a * pixelDown.a * pixelRight.a * pixelLeft.a;
					}

					if (totalAlpha == 0)
					{
						c.rgba = fixed4(1, 1, 1, 1) * _OutlineColor;
					}
				}
				c.rgb *= c.a;
				return c;
			}
			ENDCG
		}
	}
}