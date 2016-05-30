// 
Shader "Ellioman/WorldSpace2"
{
	// What variables do we want sent in to the shader?
	Properties
	{
		_MainTex ("Texture (RGB)", 2D) = "white" {}
		_HeightScale ("Height Scale", range(0, 300)) = 50
		_TargetPosition("Target Position", vector) = (0,0,0,0)
		_Position1("Position 1", vector) = (0,0,0,0)
		_Position2("Position 2", vector) = (0,0,0,0)
		_Position3("Position 3", vector) = (0,0,0,0)
		_Position4("Position 4", vector) = (0,0,0,0)
	}
	
	SubShader
	{
		cull off
		
		Pass
		{
			CGPROGRAM
				// Pragmas
				#pragma vertex vertexShader
				#pragma fragment fragmentShader
				
				// Include some commonly used helper functions
				#include "UnityCG.cginc"
				
				// User Defined Variables
				uniform sampler2D _MainTex;
				uniform float4 _MainTex_ST;
				uniform float _HeightScale;
				uniform float4 _Position1;
				uniform float4 _Position2;
				uniform float4 _Position3;
				uniform float4 _Position4;
				
				// Base Input Structs
				struct VSInput
				{
					float4 vertex : POSITION;
					float4 texcoord0 : TEXCOORD0;
				};
				
				struct VSOutput
				{
					float4 position : SV_POSITION;
					float2 texcoord0 : TEXCOORD0;
				};
				
				// The Vertex Shader 
				VSOutput vertexShader(VSInput IN)
				{
					VSOutput OUT;
					OUT.texcoord0 = TRANSFORM_TEX(IN.texcoord0, _MainTex);
					OUT.position = mul(UNITY_MATRIX_MVP, IN.vertex);
					return OUT;
				}
				
				// The Fragment Shader
				fixed4 fragmentShader(VSOutput IN) : COLOR
				{
					return float4(1.0, 0.0, 0.0, 1.0);//tex2D(_MainTex, i.texcoord0);
				}
			ENDCG
		}
	}
	Fallback "VertexLit"
}