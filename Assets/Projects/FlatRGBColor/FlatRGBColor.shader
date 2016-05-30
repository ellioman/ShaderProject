// The Shader uses the vertex positions to color the object
Shader "Ellioman/FlatRGBColor"
{
	SubShader
	{ 
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
					float4 texcoord : TEXCOORD0;
				};
				
				struct VSOutput
				{
					float4 pos : SV_POSITION;
					float4 col : TEXCOORD0;
				};
				
				// The Vertex Shader 
				VSOutput vertexShader(VSInput IN)
				{
					VSOutput OUT;
					OUT.pos = mul(UNITY_MATRIX_MVP, IN.vertex);
					
					// We add 0.5 to the x, y, and z coordinates, because the coordinates of
					// the cube are between -0.5 and 0.5 but we need them between 0.0 and 1.0.
					OUT.col = IN.vertex + float4(0.5, 0.5, 0.5, 0.0);
					
					return OUT;
				}
				
				// The Fragment Shader
				float4 fragmentShader(VSOutput IN) : COLOR
				{
					return IN.col; 
				}
			ENDCG
		}
	}
}