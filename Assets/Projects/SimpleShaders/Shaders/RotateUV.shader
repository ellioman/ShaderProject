// 
Shader "Ellioman/Simple/RotateUV"
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

				float4 CalculateRotation(float4 uv)
	            {
	            	// Small play with the Tiling a little bit
	            	//float change = 0.05;
	            	//_MainTex_ST.xy *= ((1.0 - change) + _SinTime.x * _CosTime.a * change);

	            	// Scale and offset the UV with the values in the Editor
					uv.xy = TRANSFORM_TEX(uv, _MainTex).xy;

					// How much rotation do we have right now?
	                float rotation = _RotationSpeed * _Time.y;

	                // Calculate the value we need to shift the center to (0,0)
	                // using the tiling and offset set in the Editor (_MainTex_ST)
	                float2 div = (_MainTex_ST.xy / 2.0)  + _MainTex_ST.ba;

	                // Shift the center of the coordinates to (0,0)
	                uv.xy -= div; 

	                // Create the Rotation Matrix
					float s, c;
					sincos(radians(rotation), s, c); // compute the sin and cosine

					float2x2 rotationMatrix = float2x2(c, -s, s, c);

					// Use the rotation matrix to rotate the UV coordinates
					uv.xy = mul(uv.xy, rotationMatrix);

	                // Shift the center of the coordinates back to (0.5,0.5)
	                uv.xy += div;

	                return uv;
	            }

	 			// ---------------------------
				// Shaders
				// ----------------------------

				// The Vertex Shader 
	            vertexOutput vert(vertexInput i)
	            {
	                vertexOutput o;
	                o.position = mul(UNITY_MATRIX_MVP, i.vertex);
	                o.texcoord0.xy = CalculateRotation(i.texcoord0);
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