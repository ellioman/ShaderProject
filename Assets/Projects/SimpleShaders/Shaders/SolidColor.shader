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
	 			
	 			// What variables do I want in the Vertex & Fragment shaders?
	            struct v2f
	            {
	                float4 pos : SV_POSITION;
	            };
	 			
	 			fixed4 _Color; // This needs to be declared so the fragment shader can use it
	 			
	 			// The Vertex Shader 
	 			// appdata_base is a Unity struct with position, normal and one tex coordinate
	            v2f vert(appdata_base v)
	            {
	                v2f o;
	                o.pos = mul (UNITY_MATRIX_MVP, v.vertex);
	                return o;
	            }
	 			
	 			// The Fragment Shader
	            fixed4 frag(v2f i) : COLOR
	            {
	                return _Color;
	            }
 
            ENDCG
        }
    }
    Fallback "VertexLit"
}