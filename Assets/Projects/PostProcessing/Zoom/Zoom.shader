// 
Shader "Ellioman/Zoom"
{
	// What variables do we want sent in to the shader?
	Properties
	{
		[HideInInspector] _MainTex ("Base (RGB)", 2D) = "white" {}
		_ZoomViewPointPos ("vector", vector) = (1.0, 1.0, 0.0, 0.0)
		_T ("mmm", float) = 0.5
		_V ("mmm", float) = 0.5
		_ZoomVal ("Zoom Value", range(0.0, 1.0)) = 0.5
	}
	
    SubShader
    {
        Pass
        {
//			Blend SrcAlpha OneMinusSrcAlpha // Alpha blending
//			Blend One One // Additive
//			Blend OneMinusDstColor One // Soft Additive
//			Blend DstColor Zero // Multiplicative
//			Blend DstColor SrcColor // 2x Multiplicative

            CGPROGRAM
 			
	 			// Pragmas
				#pragma vertex vert // Use the helper vertex shader
				#pragma fragment frag
				
				// Helper functions
				#include "UnityCG.cginc"
	 			
	 			// User Defined Variables
	            uniform sampler2D _MainTex; 
	            uniform float4 _MainTex_TexelSize;
	            uniform float4 _ZoomViewPointPos;
	            uniform float _T;
	            uniform float _V;
	            uniform float _ZoomVal;

	            // Base Input Structs
				struct vertexInput
				{
					float4 vertex : POSITION;
					float2 uv : TEXCOORD0; 
					float2 uv2 : TEXCOORD1;
				};
				
				struct vertexOutput
				{
					float4 pos : SV_POSITION;
					float2 uv : TEXCOORD0; 
					float2 uv2 : TEXCOORD1;
				};

				// The Vertex Shader
				vertexOutput vert(vertexInput input) 
				{
					vertexOutput output; 
					output.pos =  mul(UNITY_MATRIX_MVP, input.vertex);
					output.uv = input.uv; 
					output.uv2 = half2(_T, _V);
					 
					return output;
				}

	            // Maps a vector to a new range
	            half2 map(half2 uv, float lower, float upper)
	            {
				    float p = upper - lower;
				    half2 k = half2(uv.x * p, uv.y * p);
				    k.x += lower;
				    k.y += lower;
				    return k;
	            }

				// The Fragment Shader				
				half4 frag(vertexOutput i) : COLOR
				{
					i.uv2 = map(i.uv2, -0.5, 0.5);
					half2 uv = i.uv + i.uv2;
					uv = map(uv, _ZoomVal * 0.5, 1.0 - _ZoomVal * 0.5);

	            	// Get the color value using the new UV
					return tex2D(_MainTex, uv);
	            }
 			
            ENDCG
        }
    }
    Fallback "VertexLit"
}