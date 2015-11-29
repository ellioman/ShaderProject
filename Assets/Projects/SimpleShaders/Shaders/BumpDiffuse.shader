  // The Shader takes two textures and blends them together using the _BlendValue
  Shader "Simple/NormalMapSurfaShader"
  {
  	// What variables do we want sent in to the shader?
	Properties
	{
      _MainTex ("Texture", 2D) = "white" {}
      _BumpMap ("Bumpmap", 2D) = "bump" {}
    }
    
    SubShader
    {
      Tags
      {
      	"RenderType" = "Opaque"
      }
      
      CGPROGRAM
      
      	// What functions should we use for the vertex and fragment shaders?
		#pragma surface surf Lambert
	      
		// ---------------------------
		// Variables
		// ----------------------------
		
		// What variables do I want in the Vertex & Fragment shaders?
		struct Input
		{
			float2 uv_MainTex;
			float2 uv_BumpMap;
		};
		
		// These need to be declared again so the fragment shader can use it
		sampler2D _MainTex;
		sampler2D _BumpMap;
		
		// The Surface Shader
		void surf (Input IN, inout SurfaceOutput o)
		{
			o.Albedo = tex2D (_MainTex, IN.uv_MainTex).rgb;
	        o.Normal = UnpackNormal (tex2D (_BumpMap, IN.uv_BumpMap));
		}
		
      ENDCG
    } 
    
    Fallback "Diffuse"
}