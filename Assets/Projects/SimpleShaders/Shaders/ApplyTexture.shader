// The Shader uses the _MainTex input given and colors the object with it
Shader "Simple/ApplyTexture"
{
	// What variables do we want sent in to the shader?
	Properties
	{
		 _MainTex ("Base (RGB)", 2D) = "white" {}
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
	 			
	 			
	 			// ---------------------------
				// Shaders
				// ----------------------------
				
				// The Vertex Shader 
	            vertexOutput vert(vertexInput i)
	            {
	                vertexOutput o;
	                o.position = mul(UNITY_MATRIX_MVP, i.vertex);
	                o.texcoord0 = i.texcoord0;
	                return o;
	            }
	            
	            // The Fragment Shader
	            fixed4 frag(vertexOutput i) : SV_Target
	            {
	           		//return tex2Dproj( _MainTex, UNITY_PROJ_COORD(i.texcoord0));
	          		return tex2D(_MainTex, i.texcoord0);
	            }
 
            ENDCG
        }
    }
    Fallback "VertexLit"
}