// The shader checks the distance between the fragment and (0,0,0) in
// World Space and colors differantely whether it is inside or outside
Shader "Ellioman/WorldSpaceExample"
{
	// What variables do we want sent in to the shader?
	Properties
	{
		_Size ("Size", Range(0, 10)) = 0.5
		_ColorInside ("Color Inside", Color) = (1,1,1,1)
		_ColorOutside ("Color Outside", Color) = (1,1,1,1)
	}
	
	SubShader
	{
		Pass
		{
			CGPROGRAM

				// Pragmas
				#pragma vertex vert  
				#pragma fragment frag 
				
				// User-specified properties
				uniform float _Size;
				uniform fixed4 _ColorInside;
				uniform fixed4 _ColorOutside;

				// Base Input Structs
				struct vertexInput
				{
					float4 vertex : POSITION;
				};
				
				struct vertexOutput
				{
					float4 pos : SV_POSITION;
					float4 position_in_world_space : TEXCOORD0;
				};

				// The Vertex Shader
				vertexOutput vert(vertexInput input) 
				{
					vertexOutput output; 
					output.pos =  mul(UNITY_MATRIX_MVP, input.vertex);
					
					// transformation of input.vertex from object coordinates to world coordinates
					output.position_in_world_space = mul(_Object2World, input.vertex);
					
					return output;
				}

				// The Fragment Shader
				float4 frag(vertexOutput input) : COLOR 
				{
					// computes the distance between the fragment position 
					// and the origin (the 4th coordinate should always be 1 for points).
					float dist = distance(input.position_in_world_space, float4(0.0, 0.0, 0.0, 1.0));
					
					// color near origin
					if (dist < _Size)
					{
						return _ColorInside;
					}
					// color far from origin
					else
					{
						return _ColorOutside;
					}
				}

			ENDCG  
		}
	}
}