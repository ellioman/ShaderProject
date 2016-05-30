// http://gamasutra.com/blogs/DavidLeon/20150702/247602/NextGen_Cel_Shading_in_Unity_5.php
Shader "Ellioman/CelShading"
{
	Properties
	{
		_Color("Color", Color) = (1, 1, 1, 1)
		_MainTex("Albedo (RGB)", 2D) = "white" {}
	}
	
	SubShader
	{
		Tags
		{
			"RenderType" = "Opaque"
		}
		LOD 200
		
		CGPROGRAM
			#pragma surface surfaceShader CelShadingForward
			#pragma target 3.0
			
			// User Defined Variables
			uniform sampler2D _MainTex;
			uniform fixed4 _Color;
			
			// Base Input Structs
			struct Input
			{
				float2 uv_MainTex;
			};
			
			// The Custom Cel Shading Lighting Function
			half4 LightingCelShadingForward(SurfaceOutput s, half3 lightDir, half atten)
			{
				half NdotL = dot(s.Normal, lightDir);
				NdotL = smoothstep(0, 0.025f, NdotL);
				
				half4 c;
				c.rgb = s.Albedo * _LightColor0.rgb * (NdotL * atten * 2);
				c.a = s.Alpha;
				return c;
			}
			
			// The Surface Shader
			void surfaceShader(Input IN, inout SurfaceOutput o) 
			{
				// Albedo comes from a texture tinted by color
				fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
				o.Albedo = c.rgb;
				o.Alpha = c.a;
			}
		ENDCG
	}
	FallBack "Diffuse"
}