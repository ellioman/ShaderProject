  // The Shader takes a color and a normal texture and uses them to do normal mapping with a surface shader.
Shader "Ellioman/NormalMapSurfaceShader"
{
	// What variables do we want sent in to the shader?
	Properties
	{
		_MainTex ("Main Texture", 2D) = "white" {}
		_NormalMap ("Normal Map", 2D) = "bump" {}
		_NormalMapIntensity ("Normal Map Intensity", range(0, 10)) = 1
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
			// Pragmas
			#pragma surface surfaceShader StandardSpecular
			
			// User Defined Variables
			uniform sampler2D _MainTex;
			uniform sampler2D _NormalMap;
			uniform sampler2D _Occlusion;
			uniform sampler2D _Specular;
			uniform float _NormalMapIntensity;
			
			// Base Input Structs
			struct Input
			{
				float2 uv_MainTex;
				float2 uv_NormalMap;
				float2 uv_Occlusion;
				float2 uv_Specular;
			};
			
			// The Surface Shader
			void surfaceShader(Input IN, inout SurfaceOutputStandardSpecular o)
			{
				o.Albedo = tex2D(_MainTex, IN.uv_MainTex).rgb;
				o.Occlusion = tex2D(_Occlusion, IN.uv_Occlusion).rgb;
				o.Specular = tex2D(_Specular, IN.uv_Specular).rgb;
				
				fixed3 n = UnpackNormal (tex2D(_NormalMap, IN.uv_NormalMap)).rgb;
				n.x *= _NormalMapIntensity;
				n.y *= _NormalMapIntensity;
				o.Normal = normalize(n);
			}
		ENDCG
	} 

	Fallback "Diffuse"
}