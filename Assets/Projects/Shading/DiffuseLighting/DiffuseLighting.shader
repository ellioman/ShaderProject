Shader "Ellioman/Shading/DiffuseLighting"
{
	Properties
	{
		MainTex ("Texture", 2D) = "white" {}
	}
	
	SubShader
	{
		Tags
		{
			"RenderType" = "Opaque"
		}
		
		CGPROGRAM
			#pragma surface surf SimpleLambert
			
			// User Defined Variables
			sampler2D _MainTex;
			
			// Base Input Structs
			struct Input
			{
				float2 uv_MainTex;
			};
			
			// The Lighting Function
			half4 LightingSimpleLambert(SurfaceOutput s, half3 lightDir, half atten)
			{
				// Ambient
				float4 ambientLight = UNITY_LIGHTMODEL_AMBIENT;
				
				// Diffuse
				half NdotL = dot(s.Normal, lightDir);
				float4 diffuseTerm = saturate(NdotL);
				float4 diffuseLight = diffuseTerm  * atten* _LightColor0;
				diffuseLight.a = s.Alpha;
				
				// Results
				return ambientLight + diffuseLight;
			}
			
			// The Surface Shader
			void surf(Input IN, inout SurfaceOutput OUT)
			{
				OUT.Albedo = tex2D (_MainTex, IN.uv_MainTex).rgb;
			}
		ENDCG
	}
	Fallback "Diffuse"
}