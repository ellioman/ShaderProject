// The Shader uses the vertex positions to color the object
Shader "Ellioman/FlatRGBColor"
{
	SubShader
	{ 
		Pass
		{ 
			CGPROGRAM 
				
				// Pragmas
				#pragma vertex vert
				#pragma fragment frag

				// Base Input Structs
	            struct vertexInput
	            {
            	    float4 vertex : POSITION;
            	    float4 texcoord : TEXCOORD0;
	            };

	            struct vertexOutput
	            {
	            	float4 pos : SV_POSITION;
					float4 col : TEXCOORD0;
	            };

				// The Vertex Shader 
				vertexOutput vert(vertexInput i) 
				{
					vertexOutput output;
					output.pos = mul(UNITY_MATRIX_MVP, i.vertex);

					// We add 0.5 to the x, y, and z coordinates, because the coordinates of
					// the cube are between -0.5 and 0.5 but we need them between 0.0 and 1.0.
					output.col = i.vertex + float4(0.5, 0.5, 0.5, 0.0);

					return output;
				}

				// The Fragment Shader
				float4 frag(vertexOutput input) : COLOR
				{
					return input.col; 
				}

			ENDCG
		}
	}
}