// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'


Shader "Ellioman/Shading/Blinn-Phong"
{
	// What variables do we want sent in to the shader?
	Properties
	{
		_SpecularPower("Specular Power", float) = 25
	}
	SubShader
	{
		Pass
		{
			Tags
			{
				"LightMode" = "ForwardBase"
			}
			
			CGPROGRAM
				// Pragmas
				#pragma target 2.0
				#pragma vertex vertexShader
				#pragma fragment fragmentShader
				
				// Helper functions
				#include "UnityCG.cginc"
				
				// User Defined Variables
				float4 _LightColor0;
				float _SpecularPower;
				
				// Base Input Structs
				struct VSInput
				{
					float4 position : POSITION;
					float3 normal : NORMAL;
				};
				
				struct VSOutput
				{
					float4 screenPosition : SV_POSITION;
					float4 position : COORDINATE0;
					float3 normal : NORMAL;
				};
				
				// The Vertex Shader 
				VSOutput vertexShader(VSInput IN)
				{
					VSOutput OUT;
					OUT.screenPosition = UnityObjectToClipPos(IN.position);
					OUT.normal = normalize(mul(IN.normal, unity_WorldToObject));
					OUT.position = IN.position;
					return OUT;
				}
				
				// The Fragment Shader
				float4 fragmentShader(VSOutput IN) : SV_Target
				{
					// Ambient
					float4 ambientLight = UNITY_LIGHTMODEL_AMBIENT;
					
					// Diffuse
					float4 lightDirection = normalize(_WorldSpaceLightPos0);
					float4 diffuseTerm = saturate(dot(lightDirection, IN.normal));
					float4 diffuseLight = diffuseTerm * _LightColor0;
					
					// Blinn-Phong
					float4 cameraPosition = normalize(float4(_WorldSpaceCameraPos,1) - IN.position);
					float4 halfVector = normalize(lightDirection+cameraPosition);
					float4 specularTerm = pow(saturate(dot(IN.normal, halfVector)), _SpecularPower);
					
					// Results
					return ambientLight + diffuseLight + specularTerm;
				}
			ENDCG
		}
	}
}
