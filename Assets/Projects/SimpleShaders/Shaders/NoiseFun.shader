// 
Shader "Ellioman/Simple/NoiseFun"
{
	// What variables do we want sent in to the shader?
	Properties
	{
	  _MainTex ("Texture (RGB)", 2D) = "white" {}
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
	 			float4 _MainTex_ST;


	 			// ---------------------------
				// Functions
				// ----------------------------

				float rand(float3 co)
				{
					return frac(sin( dot(co.xyz ,float3(12.9898,78.233,45.5432) )) * 43758.5453);
				}

	 			// ---------------------------
				// Shaders
				// ----------------------------

				// The Vertex Shader 
	            vertexOutput vert(vertexInput i)
	            {
	            	float time = _SinTime.z;
	                vertexOutput o;

	                float3 kkk = (2.0 + time) * rand(i.vertex.xyz) * 50;
	                float4 k = float4(i.vertex.x, kkk.y, i.vertex.zw);
	                o.position = mul(UNITY_MATRIX_MVP, k);
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