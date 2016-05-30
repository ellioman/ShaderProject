Shader "Ellioman/NormalExtrusionWithoutTime"
{
	Properties
	{
		_Amount ("Extrusion Amount", Range(-1,1)) = 0
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_ExtrusionTex ("Extrusion Texture", 2D) = "white" {}
	}
	SubShader
	{
		Tags
		{
			"RenderType"="Opaque"
		}
		LOD 200
		
		CGPROGRAM
			#pragma surface surfaceShader Lambert vertex:vertexShader
			#pragma target 3.0 // Use shader model 3.0 target, to get nicer looking lighting
			
			// User Defined Variables
			float _Amount;
			fixed4 _Color;
			sampler2D _MainTex;
			sampler2D _ExtrusionTex;
			float4 _ExtrusionTex_ST;
			
			// Base Input Structs
			struct Input
			{
				float2 uv_MainTex;
			};
			
			// The Vertex Shader
			void vertexShader(inout appdata_full IN)
			{
				IN.texcoord.xy = TRANSFORM_TEX(IN.texcoord, _ExtrusionTex);
				
				// Get the data from the extrusion texture
				float4 tex = tex2Dlod(_ExtrusionTex, float4(IN.texcoord.xy, 0.0, 0.0));
				float extrusion = tex.r;// * 2 - 1;
				
				// Apply the amount from the variable and extrusion and multiply it to the normal
				IN.vertex.xyz += IN.normal * _Amount * extrusion;
			}
			
			// The Surface Shader
			void surfaceShader(Input IN, inout SurfaceOutput o)
			{
				// Albedo comes from a texture tinted by color
				fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
				o.Albedo = c.rgb;
				o.Alpha = c.a;
			}
		ENDCG
	}
	FallBack "Diffuse"
}
