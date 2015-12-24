  // The Shader takes a color and a normal texture and uses them to do normal mapping with a surface shader.
  Shader "Ellioman/Mapping/NormalMapSurfaceShader"
  {
  	// What variables do we want sent in to the shader?
	Properties
	{
      _MainTex ("Main Texture", 2D) = "white" {}
      _NormalMap ("Normal Map", 2D) = "bump" {}
      _Occlusion ("Occlusion", 2D) = "white" {}
      _Specular ("Specular Map", 2D) = "white" {}
    }
    
    SubShader
    {
      Tags
      {
      	"RenderType" = "Opaque"
      }
      
      CGPROGRAM
      
      	// What functions should we use for the vertex and fragment shaders?
		#pragma surface surf StandardSpecular
	      
		// ---------------------------
		// Variables
		// ----------------------------
		
		// What variables do I want in the Vertex & Fragment shaders?
		struct Input
		{
			float2 uv_MainTex;
			float2 uv_NormalMap;
			float2 uv_Occlusion;
			float2 uv_Specular;
		};
		
		// User-specified properties
		sampler2D _MainTex;
		sampler2D _NormalMap;
		sampler2D _Occlusion;
		sampler2D _Specular;
		
		// ---------------------------
		// Shaders
		// ----------------------------
		
		// The Surface Shader
		void surf (Input IN, inout SurfaceOutputStandardSpecular o)
		{
			o.Albedo = tex2D(_MainTex, IN.uv_MainTex).rgb;
			o.Occlusion = tex2D(_Occlusion, IN.uv_Occlusion).rgb;
	        o.Normal = UnpackNormal (tex2D(_NormalMap, IN.uv_NormalMap));
	        o.Specular = tex2D(_Specular, IN.uv_Specular).rgb;
		}
		
      ENDCG
    } 
    
    Fallback "Diffuse"
}