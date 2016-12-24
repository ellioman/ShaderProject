Shader "Ellioman/Shading/Diffuse"
{
	SubShader
	{
		Pass
		{
			Tags
			{
				"RenderType" = "Opaque"
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
					OUT.screenPosition = mul(UNITY_MATRIX_MVP, IN.position);
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
					half NdotL = dot(lightDirection, IN.normal);
					float4 diffuseTerm = saturate(NdotL);
					float4 diffuseLight = diffuseTerm * _LightColor0;
					
					// Results
					return ambientLight + diffuseLight;
				}
			ENDCG
		}
	}
}
