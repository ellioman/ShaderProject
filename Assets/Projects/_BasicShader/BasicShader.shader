Shader "Ellioman/BasicShader"
{
	Properties
	{
		_MainTex ("Main Texture", 2D) = "white" {}
		_Color ("Color", Color) = (1,1,1,1)

		//[Enum(Zero, 0, One,1, DstColor,2, SrcColor,3, OneMinusDstColor,4, SrcAlpha, 5, OneMinusSrcColor, 6, DstAlpha, 7, OneMinusDstAlpha, 8, SrcAlphaSaturate, 9, OneMinusSrcAlpha,10)] _BlendModeSourceColor ("Source Color BlendMode", Int) = 1
		[Enum(UnityEngine.Rendering.BlendMode)] _BlendModeSourceColor ("Source Color BlendMode", Int) = 1
		[Enum(UnityEngine.Rendering.BlendMode)] _BlendModeDestinationColor ("Destination Color BlendMode", Int) = 0
		[Enum(UnityEngine.Rendering.BlendMode)] _BlendModeSourceAlpha ("Source Alpha BlendMode", Int) = 1
		[Enum(UnityEngine.Rendering.BlendMode)] _BlendModeDestinationAlpha ("Destination Alpha BlendMode", Int) = 0
		[Enum(UnityEngine.Rendering.BlendOp)] _BlendOpColor ("Blend Op Color", Int) = 0
		[Enum(UnityEngine.Rendering.BlendOp)] _BlendOpAlpha ("Blend Op Alpha", Int) = 0
		[Enum(UnityEngine.Rendering.CullMode)] _CullMode ("CullMode", Int) = 2
		[Enum(Less, 0, Greater, 1, LEqual, 2, GEqual, 3, Equal, 4, NotEqual, 5, Always, 6)] _ZTestMode ("Z Test Mode", Int) = 3
		[Enum(On, 0, Off,1)] _ZWriteMode ("Z Write Mode", Int) = 0
		_DepthOffsetFactor ("Depth Offset Factor", Float) = 0
		_DepthOffsetUnits ("Depth Offset Units", Float) = 0
	}
	SubShader
	{
		Tags 
		{
			"Queue" = "Transparent"
			"RenderType" = "Transparent"
			"PreviewType" = "Plane"
			// "DisableBatching" = "True" / "False" / "LODFading"
			//"ForceNoShadowCasting" = "True"
			//"IgnoreProjector" = "True"
			//"CanUseSpriteAtlas" = "False"
		}

		// Shader Level of Detail (LOD) works by only using shaders or 
		// subshaders that have their LOD value less than a given number.
		LOD 100

		// Cull
		// Control which sides of polygons should be culled (not drawn)
		//   Back:  Don’t render polygons facing away from the viewer (default).
		//   Front: Don’t render polygons facing towards the viewer. Used for turning objects inside-out.
		//   Off:   Disables culling - all faces are drawn. Used for special effects.
		Cull [_CullMode]

		// ZTest
		// How should depth testing be performed. 
		// Default is LEqual (draw objects in from or at the distance as existing objects; hide objects behind them).
		// Options: Less | Greater | LEqual | GEqual | Equal | NotEqual | Always
		ZTest [_ZTestMode]

		// ZWrite
		// Controls whether pixels from this object are written to the depth buffer (default is On). 
		// If you’re drawng solid objects, leave this on. 
		// If you’re drawing semitransparent effects, switch to ZWrite Off. 
		// Options: On | Off
		ZWrite [_ZWriteMode]

		// Offset
		// Allows you specify a depth offset with two parameters. factor and units. 
		// Factor scales the maximum Z slope, with respect to X or Y of the polygon, 
		// and units scale the minimum resolvable depth buffer value. This allows you 
		// to force one polygon to be drawn on top of another although they are actually 
		// in the same position. For example Offset 0, –1 pulls the polygon closer to the
		// camera ignoring the polygon’s slope, whereas Offset –1, –1 will pull the polygon even closer
		// when looking at a grazing angle.
		Offset [_DepthOffsetFactor], [_DepthOffsetUnits]

		// Blend
		// Configure and enable blending. 
		// The generated color is multiplied by the SrcFactor. The color already on screen is multiplied by DstFactor.
		// The two are then added/Subtracted/etc together, which is determined by BlendOp.
		// Note: Unity checks and disables blend in case of non blending operation set 
		// (source == One, dest == Zero, sourceAlpha == One, destAlpha == Zero)
		Blend [_BlendModeSourceColor] [_BlendModeDestinationColor], [_BlendModeSourceAlpha] [_BlendModeDestinationAlpha]

		// Blending Operation
		BlendOp [_BlendOpColor], [_BlendOpAlpha]

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

			uniform sampler2D _MainTex;
			uniform float4 _MainTex_ST;
			uniform fixed4 _Color;

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				UNITY_TRANSFER_FOG(o, O.vertex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 col = tex2D(_MainTex, i.uv); // sample the texture
				UNITY_APPLY_FOG(i.fogCoord, col);   // apply fog
				return col * _Color;                // return the texture color * the color property
			}
			ENDCG
		}
	}

	// Use a Custom C# Editor script for this shader
	CustomEditor "BasicShaderMaterialEditor"
}
