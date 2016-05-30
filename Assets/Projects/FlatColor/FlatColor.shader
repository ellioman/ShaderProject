// The Shader uses the _Color input given and colors the object with it.
Shader "Ellioman/FlatColor"
{
	// What variables do we want sent in to the shader?
	Properties
	{
		_Color ("Color", Color) = (1,1,1,1)
	}
	
	SubShader
	{
		Pass
		{
			CGPROGRAM
				// Pragmas
				#pragma vertex vertexShader
				#pragma fragment fragmentShader
				
				// Helper functions
				#include "UnityCG.cginc"
				
				// User Defined Variables
				uniform fixed4 _Color;
				
				// Base Input Structs
				struct VSOutput
				{
					float4 pos : SV_POSITION;
				};
				
				// The Vertex Shader 
				// appdata_base is a Unity struct with position, normal and one tex coordinate
				VSOutput vertexShader(appdata_base IN)
				{
					VSOutput OUT;
					OUT.pos = mul(UNITY_MATRIX_MVP, IN.vertex);
					return OUT;
				}
				
				// The Fragment Shader
				fixed4 fragmentShader(VSOutput IN) : COLOR
				{
					return _Color;
				}
			ENDCG
		}
	}
	Fallback "VertexLit"
}