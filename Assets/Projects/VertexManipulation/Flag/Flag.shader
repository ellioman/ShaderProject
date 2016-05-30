// From the book Unity 5.x Shaders and Effects Cookbook
Shader "Ellioman/VertexManipulation/Flag"
{
	// What variables do we want sent in to the shader?
	Properties
	{
		_MainTex ("Albedo (RGB)", 2D) = "white" {}

		_TintAmount ("Tint Amount", Range(0,1)) = 0.5
		_ColorA ("Color A", Color) = (1,1,1,1)
		_ColorB ("Color B", Color) = (1,1,1,1)
		_Speed ("Wave Speed", Range(0,80)) = 5
		_Frequency ("Frequency", Range(0,5)) = 2
		_Amplitude ("Amplitude", Range(-1,1)) = 1
	}
	SubShader
	{
		Tags
		{
			"RenderType"="Opaque"
		}
		LOD 200
		
		CGPROGRAM
			// Physically based Standard lighting model, and enable shadows on all light types
			#pragma surface surfaceShader Lambert vertex:vertexShader
			#pragma target 3.0 // Use shader model 3.0 target, to get nicer looking lighting
			
			// User Defined Variables
			sampler2D _MainTex;
			half _TintAmount;
			fixed4 _ColorA;
			fixed4 _ColorB;
			float _Speed;
			float _Frequency;
			float _Amplitude;
			
			// Base Input Structs
			struct Input
			{
				float2 uv_MainTex;
				float3 vertColor;
			};
			
			// The Vertex Function
			void vertexShader(inout appdata_full IN, out Input OUT)
			{
				float time = _Time * _Speed; 
				float waveValueA = sin(time + IN.vertex.x * _Frequency) * _Amplitude;
				
				IN.vertex.xyz = float3(IN.vertex.x, IN.vertex.y + waveValueA, IN.vertex.z - waveValueA * 0.0625);
				IN.normal = normalize(float3(IN.normal.x + waveValueA, IN.normal.y, IN.normal.z));
				
				OUT.vertColor = float3(waveValueA, waveValueA, waveValueA);
				OUT.uv_MainTex = IN.texcoord;
			}
			
			// The Surface Shader
			void surfaceShader(Input IN, inout SurfaceOutput OUT)
			{
				// Albedo comes from a texture tinted by color
				fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
				float3 tintColor = lerp(_ColorA, _ColorB, IN.vertColor).rgb;
				OUT.Albedo = c.rgb * (tintColor * _TintAmount);
				OUT.Alpha = c.a;
			}
		ENDCG
	}
	FallBack "Diffuse"
}
