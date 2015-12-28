Shader "Ellioman/ModelSurfaceShader"
{
	Properties
	{
		_StencilVal ("stencilVal", Range(0, 255)) = 1
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Glossiness ("Smoothness", Range(0,1)) = 0.5
		_Metallic ("Metallic", Range(0,1)) = 0.0
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 200

		// Stencil Buffer: http://docs.unity3d.com/Manual/SL-Stencil.html
		Stencil
		{
			// The value to be compared against (if Comp is anything else than always) and/or the value to be
			// written to the buffer (if either Pass, Fail or ZFail is set to replace). 0–255 integer.
			Ref [_StencilVal]
			
			// The function used to compare the reference value to the current contents of the buffer.
			// Here we use Equal because we only want to render when the stencil matched the "Ref" value above
			Comp Equal
			
			// What to do with the contents of the buffer if the stencil test (and the depth test) passes.
			// We use keep because we don't want to mess with the buffer
			Pass Keep
			
			// What to do with the contents of the buffer if the stencil test fails.
			// We use keep because we don't want to mess with the buffer
			Fail Keep
		}

		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Standard fullforwardshadows

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _MainTex;

		struct Input
		{
			float2 uv_MainTex;
		};

		half _Glossiness;
		half _Metallic;
		fixed4 _Color;

		void surf (Input IN, inout SurfaceOutputStandard o)
		{
			// Albedo comes from a texture tinted by color
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
			o.Albedo = c.rgb;

			// Metallic and smoothness come from slider variables
			o.Metallic = _Metallic;
			o.Smoothness = _Glossiness;
			o.Alpha = c.a;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
