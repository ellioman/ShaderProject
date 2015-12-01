// The Shader uses the _MainTex input given and colors the object with it
Shader "Simple/AlphaBlending"
{
	// What variables do we want sent in to the shader?
	Properties
	{
		_Color ("Color", Color) = (1,1,1,1)
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
        	// don't write to depth buffer in order not to occlude other objects
        	ZWrite Off 
        	
        	// Use alpha blending
        	// float4 result = float4(1.0) * fragment_output + (float4(1.0) - fragment_output.aaaa) * pixel_color;
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
	            };

	            struct vertexOutput
	            {
	                float4 position : SV_POSITION;
	            };
	 			
	 			// User-specified properties
	 			fixed4 _Color;
	 			
	 			
	 			// ---------------------------
				// Shaders
				// ----------------------------
				
				// The Vertex Shader 
				vertexOutput vert(vertexInput i)
				{
					vertexOutput o;
	                o.position = mul(UNITY_MATRIX_MVP, i.vertex);
	                return o;
				}
	            
	            // The Fragment Shader
	            fixed4 frag(vertexOutput i) : Color
	            {
	           		return _Color;
	            }
 
            ENDCG
        }
    }
}