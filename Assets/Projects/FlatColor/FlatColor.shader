// The Shader uses the _Color input given and colors the object with it.
Shader "Ellioman/FlatColor"
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
 			
	 			// Pragmas
	            #pragma vertex vert
	            #pragma fragment frag
	            
	            // Helper functions
	            #include "UnityCG.cginc"

	            // User Defined Variables
	 			uniform fixed4 _Color;

	 			// Base Input Structs
	            struct vertexOutput
	            {
	                float4 pos : SV_POSITION;
	            };

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