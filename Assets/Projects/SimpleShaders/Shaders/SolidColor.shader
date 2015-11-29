// The Shader uses the _Color input given and colors the object with it.
Shader "Simple/SolidColor"
{
	// What variables do we want sent in to the shader?
	Properties
	{
		_Color ("Color", Color) = (1,1,1,1)
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
				// ----------------------------
	 			
	 			// What variables do I want in the Vertex & Fragment shaders?
	            struct vertexOutput
	            {
	                float4 pos : SV_POSITION;
	            };
	 			
	 			// User-specified properties
	 			fixed4 _Color; 
	 			
	 			
	 			// ---------------------------
				// Shaders
				// ----------------------------
	 			
	 			// The Vertex Shader 
	 			// appdata_base is a Unity struct with position, normal and one tex coordinate
	            vertexOutput vert(appdata_base v)
	            {
	                vertexOutput o;
	                o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
	                return o;
	            }
	 			
	 			// The Fragment Shader
	            fixed4 frag(vertexOutput i) : COLOR
	            {
	                return _Color;
	            }
 
            ENDCG
        }
    }
    Fallback "VertexLit"
}