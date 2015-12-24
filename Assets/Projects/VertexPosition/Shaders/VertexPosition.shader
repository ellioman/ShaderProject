// 
Shader "Ellioman/VertexPosition"
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
				// Shaders
				// ----------------------------

				// The Vertex Shader 
	            vertexOutput vert(vertexInput i)
	            {
	                vertexOutput o;
	                 
//	                i.vertex.x = i.vertex.x + i.vertex.x * (_SinTime.w + 1.0);
//	                i.vertex.y = i.vertex.y * 0.5 + i.vertex.y * _SinTime.z;
//	                i.vertex.z = i.vertex.z + i.vertex.z * (_SinTime.z + 1.0);
					i.vertex.xz *= clamp((_SinTime.w + 3.0) * 0.5, 1.0, 2.0);
	                o.position = mul(UNITY_MATRIX_MVP, i.vertex);
	                //o.position.x = o.position.x * 0.5 + o.position.x * _SinTime;


	                o.texcoord0.xy = TRANSFORM_TEX(i.texcoord0, _MainTex);

//	                float2 div = (_MainTex_ST.xy / 2.0)  + _MainTex_ST.ba;
//	                o.texcoord0.xy -= div;
//	                o.texcoord0.xy *= clamp((_SinTime.w + 3.0) * 0.5, 1.0, 2.0);
//	                o.texcoord0.xy += div;
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