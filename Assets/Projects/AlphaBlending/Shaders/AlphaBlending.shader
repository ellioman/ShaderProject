// The Shader outputs a transparent object using alpha blending
Shader "Ellioman/AlphaBlending"
{
	// What variables do we want sent in to the shader?
	Properties
	{
		_MainTex ("Texture to blend", 2D) = "black" {}
		_Color ("Color", Color) = (1,1,1,1)
	}
	
    SubShader
    {
    	// Draw after all opaque geometry has been drawn
    	Tags
    	{
    		"Queue" = "Transparent"
    	} 
         
        Pass
        {
        	// Don't write to depth buffer in order not to occlude other objects
        	ZWrite Off 
        	
        	// Use alpha blending
        	// float4 result = float4(1.0) * fragment_output + (float4(1.0) - fragment_output.aaaa) * pixel_color;
        	Blend SrcAlpha OneMinusSrcAlpha
            
            CGPROGRAM
 			
	 			// Pragmas
	            #pragma vertex vert
	            #pragma fragment frag
	            
	            // Helper functions
	            #include "UnityCG.cginc"

	            // User Defined Variables
	 			uniform fixed4 _Color;
	 			uniform sampler2D _MainTex;
	 			
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
				
				// The Vertex Shader 
				vertexOutput vert(vertexInput i)
				{
					vertexOutput o;
	                o.position = mul(UNITY_MATRIX_MVP, i.vertex);
	                o.texcoord0 = i.texcoord0;
	                return o;
				}
	            
	            // The Fragment Shader
	            fixed4 frag(vertexOutput i) : Color
	            {
					return tex2D(_MainTex, i.texcoord0) * _Color;
	            }
 			
            ENDCG
        }
    }
}