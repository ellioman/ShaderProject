Shader "Custom/StencilMask_1_Diffuse"
{
	Properties
	{
		_Color ("Main Color", Color) = (1,1,1,1)
		_MainTex ("Base (RGB) Trans (A)", 2D) = "white" {}
	}

	SubShader
	{
		// Stencil
		// http://docs.unity3d.com/Manual/SL-Stencil.html
		// 
		// Comparison Function
		// Greater	Only render pixels whose reference value is greater than the value in the buffer.
		// GEqual	Only render pixels whose reference value is greater than or equal to the value in the buffer.
		// Less	Only render pixels whose reference value is less than the value in the buffer.
		// LEqual	Only render pixels whose reference value is less than or equal to the value in the buffer.
		// Equal	Only render pixels whose reference value equals the value in the buffer.
		// NotEqual	Only render pixels whose reference value differs from the value in the buffer.
		// Always	Make the stencil test always pass.
		// Never	Make the stencil test always fail.
		// 
		// Stencil Operation
		// Keep	Keep the current contents of the buffer.
		// Zero	Write 0 into the buffer.
		// Replace	Write the reference value into the buffer.
		// IncrSat	Increment the current value in the buffer. If the value is 255 already, it stays at 255.
		// DecrSat	Decrement the current value in the buffer. If the value is 0 already, it stays at 0.
		// Invert	Negate all the bits.
		// IncrWrap	Increment the current value in the buffer. If the value is 255 already, it becomes 0.
		// DecrWrap	Decrement the current value in the buffer. If the value is 0 already, it becomes 255
	
	
		Stencil
		{
			// The value to be compared against (if Comp is anything else than always) and/or the value to be
			// written to the buffer (if either Pass, Fail or ZFail is set to replace). 0–255 integer.
			Ref 2
			
			// An 8 bit mask as an 0–255 integer, used when comparing the reference value with the contents of
			// the buffer (referenceValue & readMask) comparisonFunction (stencilBufferValue & readMask). Default: 255.
			// ReadMask readMask
			
			// An 8 bit mask as an 0–255 integer, used when writing to the buffer. Default: 255.
			// WriteMask writeMask
			
			// The function used to compare the reference value to the current contents of the buffer. Default: always.
			Comp Equal
			
			// What to do with the contents of the buffer if the stencil test (and the depth test) passes. Default: keep.
			Pass Keep
			
			// What to do with the contents of the buffer if the stencil test fails. Default: keep.
			Fail Keep
			
			// What to do with the contents of the buffer if the stencil test passes, but the depth test fails. Default: keep.
			// ZFail stencilOperation

		}
		Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}
		LOD 200

		CGPROGRAM
		#pragma surface surf Lambert alpha

		sampler2D _MainTex;
		fixed4 _Color;

		struct Input
		{
			float2 uv_MainTex;
		};

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
