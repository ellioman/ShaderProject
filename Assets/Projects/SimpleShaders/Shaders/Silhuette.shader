Shader "Cg silhouette enhancement"
{
	// What variables do we want sent in to the shader?
	Properties
	{
		_Color ("Color", Color) = (1, 1, 1, 0.5) 
	}
	
	SubShader
	{
		// draw after all opaque geometry has been drawn
		Tags
		{
			"Queue" = "Transparent"
		}
		
		Pass
		{
			// don't occlude other objects
			ZWrite Off
			
			// standard alpha blending
			Blend SrcAlpha OneMinusSrcAlpha

			CGPROGRAM 

	 			// What functions should we use for the vertex and fragment shaders?
	            #pragma vertex vert
	            #pragma fragment frag
	            
	            // Include some commonly used helper functions
	            #include "UnityCG.cginc"
	            
	            
				// ---------------------------
				// Variables
				// ---------------------------
	 			
	            // What variables do I want in the Vertex & Fragment shaders?
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
				
				// User-specified properties
				uniform float4 _Color;

				
				// ---------------------------
				// Shaders
				// ----------------------------
				
				// The Vertex Shader 
				vertexOutput vert(vertexInput input) 
				{
					vertexOutput output;

					float4x4 modelMatrix = _Object2World;
					float4x4 modelMatrixInverse = _World2Object; 

					output.normal = normalize(mul(float4(input.normal, 0.0), modelMatrixInverse).xyz);
					output.viewDir = normalize(_WorldSpaceCameraPos - mul(modelMatrix, input.vertex).xyz);
					output.pos = mul(UNITY_MATRIX_MVP, input.vertex);
					return output;
				}
				
				// The Fragment Shader 
				float4 frag(vertexOutput input) : COLOR
				{
					float3 normalDirection = normalize(input.normal);
					float3 viewDirection = normalize(input.viewDir);

					float newOpacity = min(1.0, _Color.a / abs(dot(viewDirection, normalDirection)));
					return float4(_Color.rgb, newOpacity);
				}
			
			ENDCG
		}
	}
}