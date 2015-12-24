// 
Shader "Ellioman/Simple/RotateVertices"
{
	// What variables do we want sent in to the shader?
	Properties
	{
	  _MainTex ("Texture (RGB)", 2D) = "white" {}
	  _RotationSpeed ("Rotation Speed", Float) = 2.0
	}

	SubShader
    {
        Pass
        {
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
            	    float4 texcoord0 : TEXCOORD0;
	            };

	            struct vertexOutput
	            {
	                float4 position : SV_POSITION;
	                float4 texcoord0 : TEXCOORD0;
	            };
	            
	            // User-specified properties
	            sampler2D _MainTex;
	 			float _RotationSpeed;
	 			float4 _MainTex_ST;


	 			// ---------------------------
				// Functions
				// ----------------------------

				float4 CalculateRotation(float4 pos)
	            {
					// How much rotation do we have right now?
	                float rotation = _RotationSpeed * _Time.y;

	                // Create the Rotation Matrix
					float s, c;
					sincos(radians(rotation), s, c); // compute the sin and cosine
					float2x2 rotationMatrix = float2x2(c, -s, s, c);

					// Use the rotation matrix to rotate the vertices
					pos.xy = mul(pos.xy, rotationMatrix);

	                return pos;
	            }

	 			// ---------------------------
				// Shaders
				// ----------------------------

				// The Vertex Shader 
	            vertexOutput vert(vertexInput i)
	            {
	                vertexOutput o;

	                float4 k = float4(i.vertex.x, i.vertex.z, 1.0, 1.0);
	                k = CalculateRotation(k);
	                o.position = mul(UNITY_MATRIX_MVP, float4(k.x, i.vertex.y, k.y, i.vertex.w));
	                o.texcoord0.xy = TRANSFORM_TEX(i.texcoord0, _MainTex);
	                return o;
	            }

	            // The Fragment Shader
	            fixed4 frag(vertexOutput i) : SV_Target
	            {
	          		return tex2D(_MainTex, i.texcoord0);// + float4(c, s, 0.0, 0.0));
	            }
 
            ENDCG
        }
    }
    Fallback "VertexLit"
}