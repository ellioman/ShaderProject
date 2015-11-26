// The Shader uses the _MainTex input given and colors the object with it
Shader "Simple/CombineTextures"
{
	// What variables do we want sent in to the shader?
	Properties
	{
		 _MainTex ("Base (RGB)", 2D) = "white" {}
		 _SecondTex ("Base (RGB)", 2D) = "white" {}
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
	            struct vertexInput
	            {
            	    float4 vertex : POSITION;
            	    float4 texcoord0 : TEXCOORD0;
	            };

	            struct fragmentInput
	            {
	                float4 position : SV_POSITION;
	                float4 texcoord0 : TEXCOORD0;
	            };
	            
	            // This needs to be declared so the fragment shader can use it
	            sampler2D _MainTex; 
	            sampler2D _SecondTex;
				
				// The Vertex Shader 
	            fragmentInput vert(vertexInput i)
	            {
	                fragmentInput o;
	                o.position = mul (UNITY_MATRIX_MVP, i.vertex);
	                o.texcoord0 = i.texcoord0;
	                return o;
	            }
	            
	            // The Fragment Shader
	            fixed4 frag(fragmentInput i) : SV_Target
	            {
	           		//return tex2Dproj( _MainTex, UNITY_PROJ_COORD(i.texcoord0));
	          		float4 a = tex2D( _MainTex, i.texcoord0 );
	          		float4 b = tex2D( _SecondTex, i.texcoord0 );
	          		return (a + b) * 0.5f;
	            }
 
            ENDCG
        }
    }
    Fallback "VertexLit"
}