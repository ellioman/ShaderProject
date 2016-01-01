// Tutorial: https://en.wikibooks.org/wiki/Cg_Programming/Unity/Silhouette_Enhancement
Shader "Ellioman/Silhouette"
{
	// What variables do we want sent in to the shader?
	Properties
	{
		_Color ("Color", Color) = (1, 1, 1, 0.5)
		_SilhuettePower ("Silhuette Power", Range(0, 3)) = 0.5
	}
	
	SubShader
	{
		// Draw after all opaque geometry has been drawn
		Tags
		{
			"Queue" = "Transparent"
		}
		
		Pass
		{
			// Don't occlude other objects
			ZWrite Off
			
			// Standard alpha blending
			Blend SrcAlpha OneMinusSrcAlpha

			CGPROGRAM 
				
	 			// Pragmas
	            #pragma vertex vert
	            #pragma fragment frag
	            
	            // Helper functions
	            #include "UnityCG.cginc"

	            // User Defined Variables
				uniform float4 _Color;
				uniform float _SilhuettePower;

				// Base Input Structs
				struct vertexInput
				{
					float4 vertex : POSITION;
					float3 normal : NORMAL;
				};
				struct vertexOutput
				{
					float4 pos : SV_POSITION;
					float3 normal : TEXCOORD;
					float3 viewDir : TEXCOORD1;
				};

				// The Vertex Shader 
				vertexOutput vert(vertexInput input) 
				{
					vertexOutput output;

					// The direction to the viewer can be computed in the vertex shader as the vector
					// from the vertex position in world space to the camera position in world space
					output.viewDir = normalize(_WorldSpaceCameraPos - mul(_Object2World, input.vertex).xyz);
					output.normal = normalize(mul(float4(input.normal, 0.0), _Object2World).xyz);
					output.pos = mul(UNITY_MATRIX_MVP, input.vertex);
					
					return output;
				}
				
				// The Fragment Shader 
				float4 frag(vertexOutput input) : COLOR
				{
					float3 normalDirection = normalize(input.normal);
					float3 viewDirection = normalize(input.viewDir);
					
					float dotResults = pow(dot(viewDirection, normalDirection), _SilhuettePower);
					float newOpacity = min(1.0, _Color.a / abs(dotResults));
					
					return float4(_Color.rgb, newOpacity);
				}
			
			ENDCG
		}
	}
}