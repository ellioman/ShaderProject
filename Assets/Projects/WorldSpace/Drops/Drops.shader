// The shader checks the distance between the fragment and (0,0,0) in
// World Space and colors differantely whether it is inside or outside
Shader "Ellioman/WorldSpace/Drops"
{
	// What variables do we want sent in to the shader?
	Properties
	{
		[HideInInspector] _WorldPos1 ("WorldPos1", Vector) = (0,0,0,1)
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
				uniform fixed4 _WorldPos1;

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
					float dist1 = distance(input.position_in_world_space, float4(_WorldPos1.x, _WorldPos1.y, _WorldPos1.z, 1.0));
					float size = 3.0;
					float4 col = float4(0.1, 0.5, 0.1, 1.0);
					float4 white = float4(1.0, 1.0, 1.0, 1.0);
					return lerp(col, white, smoothstep(0.0, size, dist1));
					//return float4(col * mult, 1.0);
				}

			ENDCG  
		}
	}
}