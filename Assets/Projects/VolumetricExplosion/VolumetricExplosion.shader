Shader "Ellioman/VolumetricExplosion"
{
	Properties
	{
		_RampTex ("Color Ramp", 2D) = "white" {}
		_RampOffset ("Ramp Offset", Range(-0.5,0.5)) = 0.0

		_NoiseTex ("Noise Tex", 2D) = "gray" {}
		_Period ("Period", Range(0.0, 1.0)) = 0.5

		_Amount ("Amount", Range(0.0, 1.0)) = 0.5
		_ClipRange ("Clip Range", Range(0.0, 1.0)) = 0.5
	}
	SubShader
	{
		Tags
		{
			"RenderType"="Opaque"
		}
		LOD 200
		
		CGPROGRAM
			#pragma surface surfaceShader Lambert vertex:vertexShader nolightmap
			#pragma target 3.0 // Use shader model 3.0 target, to get nicer looking lighting
			
			// User Defined Variables
			sampler2D _MainTex;
			sampler2D _RampTex;
			half _RampOffset;
			sampler2D _NoiseTex;
			half _Period;
			half _Amount;
			half _ClipRange;
			
			// Base Input Structs
			struct Input
			{
				float2 uv_NoiseTex;
			};
			
			// The Vertex Shader
			void vertexShader(inout appdata_full IN)
			{
				float3 disp = tex2Dlod(_NoiseTex, float4(IN.texcoord.xy, 0.0, 0.0));
				float time = sin(_Time[3] * _Period + disp.r * 10);
				IN.vertex.xyz += IN.normal * disp.r * _Amount * time;
			}
			
			// The Surface Shader
			void surfaceShader(Input IN, inout SurfaceOutput OUT)
			{
				float3 noise = tex2D(_NoiseTex, IN.uv_NoiseTex);
				float n = saturate(noise.r + _RampOffset);
				clip(_ClipRange - n);
				
				half4 c = tex2D(_RampTex, float2(n, 0.5));
				OUT.Albedo = c.rgb;
				OUT.Emission = c.rgb * c.a;
			}
		ENDCG
	}
	FallBack "Diffuse"
}
