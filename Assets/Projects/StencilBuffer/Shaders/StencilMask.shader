// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// This shader is used to write the "Ref" number, in the Stencil part, to the Stencil Buffer.
Shader "Ellioman/Stencils/StencilMask"
{
	// What variables do we want sent in to the shader?
	Properties
	{
		_StencilVal ("stencilVal", Range(0, 255)) = 1
	}
		
	SubShader 
	{
		// Subshaders use tags to tell how and when they 
		// expect to be rendered to the rendering engine
		Tags
		{
			"RenderType"="Opaque"
			"Queue"="Geometry-100"
		}
		
		// Stencil Buffer
		// Always pass and replace the stencil value with the one in _StencilVal
		ColorMask 0
		ZWrite off
		Stencil 
		{
			Ref [_StencilVal]
			Comp always
			Pass replace
		}
		
		Pass
		{
			CGPROGRAM
				// Pragmas
				#pragma vertex vertexShader
				#pragma fragment fragmentShader
				
				// Base Input Structs
				struct VSInput 
				{
					float4 vertex : POSITION;
				};
				
				struct VSOutput 
				{
					float4 pos : SV_POSITION;
				};
				
				// The Vertex Shader
				VSOutput vertexShader(VSInput IN) 
				{
					VSOutput OUT;
					OUT.pos = UnityObjectToClipPos(IN.vertex);
					return OUT;
				}
				
				// The Fragment Shader
				half4 fragmentShader(VSOutput IN) : COLOR 
				{
					return half4(1,1,0,1);
				}
			ENDCG
		}
	}
}