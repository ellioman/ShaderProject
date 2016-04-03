Shader "Ellioman/SilhuetteSurfaceShader"
{
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_DotProduct ("Rim Effect", Range(-1, 1)) = 0.25
		_ColorPower ("Color Power", Range(1, 10)) = 1.00
	}
	SubShader
	{
		// Tags...
		Tags
		{
			"Queue" = "Transparent"
			"IgnoreProjector" = "True"
			"RenderType" = "Transparent"
		}

		// If we want the backside to appear, uncomment this line
		//cull off 
		
		CGPROGRAM

		// Pragmas
		#pragma surface surf Lambert alpha:fade

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		 // User Defined Variables
		uniform sampler2D _MainTex;
		uniform fixed4 _Color;
		uniform float _DotProduct;
		uniform float _ColorPower;

		struct Input
		{
			float2 uv_MainTex;
			float3 worldNormal;
			float3 viewDir;
		};

		// The Surface Shader 
		void surf (Input IN, inout SurfaceOutput o)
		{
			// Albedo comes from a texture tinted by color
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color * _ColorPower;
			o.Albedo = c.rgb;

			float border = 0.5 - (abs(dot(IN.viewDir, IN.worldNormal)));
			float alpha = (border * (1 - _DotProduct) + _DotProduct);
			o.Alpha =  c.a * alpha;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
