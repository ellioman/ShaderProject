// This shader is used to write the "Ref" number, in the Stencil part, to the Stencil Buffer.
Shader "Stencils/StencilMask"
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
		
		// ---------------------------
		// Stencil Buffer
		// ----------------------------
		
		// Here we always pass and replace the stencil value with the one in _StencilVal
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
			
				// What functions should we use for the vertex and fragment shaders?
				#pragma vertex vert
				#pragma fragment frag
				
				
				// ---------------------------
				// Variables
				// ---------------------------
				
				// What gets sent in the vertex and fragment shaders?
				struct appdata 
				{
					float4 vertex : POSITION;
				};
				
				struct vertexOutput 
				{
					float4 pos : SV_POSITION;
				};
				
				
				// ---------------------------
				// Shaders
				// ----------------------------
				
				// The Vertex Shader
				vertexOutput vert(appdata v) 
				{
					vertexOutput o;
					o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
					return o;
				}
				
				// The Fragment Shader
				half4 frag(vertexOutput i) : COLOR 
				{
					return half4(1,1,0,1);
				}
				
			ENDCG
		}
	}
}