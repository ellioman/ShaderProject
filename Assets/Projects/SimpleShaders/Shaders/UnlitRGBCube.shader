// The Shader uses the _Color input given and colors the object with it.
Shader "Simple/UnlitRGBCube"
{
	SubShader
	{ 
		Pass
		{ 
			CGPROGRAM 
				
				// What functions should we use for the vertex and fragment shaders?
				#pragma vertex vert // vert function is the vertex shader 
				#pragma fragment frag // frag function is the fragment shader

				// ---------------------------
				// Variables
				// ----------------------------
	 			
	            // What variables do I want in the Vertex & Fragment shaders?
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
	            

				// ---------------------------
				// Shaders
				// ----------------------------
				
				// The Vertex Shader 
				vertexOutput vert(vertexInput i) 
				{
					vertexOutput output;

					output.pos = mul(UNITY_MATRIX_MVP, i.vertex);
					output.col = i.vertex + float4(0.5, 0.5, 0.5, 0.0);
					
					// Here the vertex shader writes output data
					// to the output structure. We add 0.5 to the 
					// x, y, and z coordinates, because the 
					// coordinates of the cube are between -0.5 and
					// 0.5 but we need them between 0.0 and 1.0. 
					return output;
				}

				// The Fragment Shader
				float4 frag(vertexOutput input) : COLOR
				{
					return input.col; 
					// Here the fragment shader returns the "col" input 
					// parameter with semantic TEXCOORD0 as nameless
					// output parameter with semantic COLOR.
				}

			ENDCG
		}
	}
}