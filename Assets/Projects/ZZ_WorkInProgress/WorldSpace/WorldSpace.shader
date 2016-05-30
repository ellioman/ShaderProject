// The shader checks the distance between the fragment and (0,0,0) in
// World Space and colors differantely whether it is inside or outside
Shader "Ellioman/WorldSpaceExample"
{
	// What variables do we want sent in to the shader?
	Properties
	{
		[HideInInspector] _WorldPos1 ("WorldPos1", Vector) = (0,0,0,1)
		[HideInInspector] _WorldPos2 ("WorldPos2", Vector) = (0,0,0,1)
		[HideInInspector] _WorldPos3 ("WorldPos3", Vector) = (0,0,0,1)
		[HideInInspector] _Size1 ("Size", float) = 0.5
		[HideInInspector] _Size2 ("Size", float) = 0.5
		[HideInInspector] _Size3 ("Size", float) = 0.5
		[HideInInspector] _ColorInside ("Color Inside", Color) = (1,1,1,1)
		[HideInInspector] _ColorOutside ("Color Outside", Color) = (1,1,1,1)
	}
	
	SubShader
	{
		Pass
		{
			CGPROGRAM
				// Pragmas
				#pragma vertex vertexShader
				#pragma fragment fragmentShader 
				
				// User-specified properties
				uniform float _Size1;
				uniform float _Size2;
				uniform float _Size3;
				uniform fixed4 _WorldPos1;
				uniform fixed4 _WorldPos2;
				uniform fixed4 _WorldPos3;
				uniform fixed4 _ColorInside;
				uniform fixed4 _ColorOutside;
				
				// Base Input Structs
				struct VSInput
				{
					float4 vertex : POSITION;
				};
				
				struct VSOutput
				{
					float4 pos : SV_POSITION;
					float4 position_in_world_space : TEXCOORD0;
				};
				
				// The Vertex Shader
				VSOutput vertexShader(VSInput IN) 
				{
					VSOutput OUT; 
					OUT.pos =  mul(UNITY_MATRIX_MVP, IN.vertex);
					
					// transformation of input.vertex from object coordinates to world coordinates
					OUT.position_in_world_space = mul(_Object2World, IN.vertex);
					
					return OUT;
				}
				
				// The Fragment Shader
				float4 fragmentShader(VSOutput IN) : COLOR 
				{
					// computes the distance between the fragment position 
					// and the origin (the 4th coordinate should always be 1 for points).
					float dist1 = distance(IN.position_in_world_space, float4(_WorldPos1.x, _WorldPos1.y, _WorldPos1.z, 1.0));
					float dist2 = distance(IN.position_in_world_space, float4(_WorldPos2.x, _WorldPos2.y, _WorldPos2.z, 1.0));
					float dist3 = distance(IN.position_in_world_space, float4(_WorldPos3.x, _WorldPos3.y, _WorldPos3.z, 1.0));
					
					// color near origin
					if (dist1 < _Size1 || dist2 < _Size2 || dist3 < _Size3)
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