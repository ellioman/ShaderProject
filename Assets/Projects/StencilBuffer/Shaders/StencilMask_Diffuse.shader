// This shader only renders if the stencil ref number matches the one in the Stencil Buffer
Shader "Stencils/StencilMask_Diffuse"
{
	// What variables do we want sent in to the shader?
	Properties
	{
		_StencilVal ("stencilVal", Range(0, 255)) = 1
		_Color ("Main Color", Color) = (1,1,1,1)
		_MainTex ("Base (RGB) Trans (A)", 2D) = "white" {}
	}

	SubShader
	{
		// Subshaders use tags to tell how and when they 
		// expect to be rendered to the rendering engine
		Tags
		{
			"Queue"="Transparent"
			"IgnoreProjector"="True"
			"RenderType"="Transparent"
		}
		LOD 200
		
		// ---------------------------
		// Stencil Buffer: http://docs.unity3d.com/Manual/SL-Stencil.html
		// ----------------------------
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
		#pragma surface surf Lambert alpha
		
		
		// ---------------------------
		// Variables
		// ----------------------------
		
		// These need to be declared again so the fragment shader can use it
		sampler2D _MainTex;
		fixed4 _Color;

		struct Input
		{
			float2 uv_MainTex;
		};
		
		
		// ---------------------------
		// Shaders
		// ----------------------------

		// The Surface Shader
		void surf (Input IN, inout SurfaceOutput o)
		{
			fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
		
		ENDCG
	}
	
	Fallback "Transparent/VertexLit"
}
