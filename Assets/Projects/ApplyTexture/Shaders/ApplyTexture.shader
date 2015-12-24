// The Shader uses the _MainTex input given and colors the object with it
Shader "Ellioman/ApplyTexture"
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
 			
	 			// Pragmas
	            #pragma vertex vert
	            #pragma fragment frag
	            
	            // Helper functions
	            #include "UnityCG.cginc"

	            // User Defined Variables
	            uniform sampler2D _MainTex;
	 			
	            // Base Input Structs
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
	          		return tex2D(_MainTex, i.texcoord0);
	            }
 			
            ENDCG
        }
    }
    Fallback "VertexLit"
}