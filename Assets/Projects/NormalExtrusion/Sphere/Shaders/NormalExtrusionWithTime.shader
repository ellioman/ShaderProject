Shader "Ellioman/NormalExtrusionWithTime"
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

		#pragma surface surf Lambert vertex:vert

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		struct Input
		{
			float2 uv_MainTex;
		};

		float _Amount;
		fixed4 _Color;
		sampler2D _MainTex;
		sampler2D _ExtrusionTex;
		float4 _ExtrusionTex_ST;

		// The Vertex Shader
		void vert(inout appdata_full v)
		{
			v.texcoord.xy = TRANSFORM_TEX(v.texcoord, _ExtrusionTex);

			// Get the data from the extrusion texture
			float4 tex = tex2Dlod(_ExtrusionTex, float4(v.texcoord.xy, 0.0, 0.0));
			float extrusion = tex.r;// * 2 - 1;
			float time = sin(_Time[3]) * 0.5 + 0.5; // make it go from 0 to 1 instead of -1 to 1

			// Apply the amount from the variable and extrusion and multiply it to the normal
			v.vertex.xyz += v.normal * _Amount * extrusion * time;
		}

		void surf (Input IN, inout SurfaceOutput o)
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
