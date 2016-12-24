// Credits: Alan Zucconi www.alanzucconi.com
Shader "Ellioman/Heatmap"
{
	Properties
	{
		_HeatTex("Texture", 2D) = "white" {}
	}

	SubShader
	{
		Tags{ "Queue" = "Transparent" }
		Blend SrcAlpha OneMinusSrcAlpha // Alpha blend

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			// Base Input Structs
			struct vertInput
			{
				float4 pos : POSITION;
			};

			struct vertOutput
			{
				float4 pos : POSITION;
				fixed3 worldPos : TEXCOORD1;
			};

			// User Defined Variables
			uniform int _Points_Length = 0;
			uniform float3 _Points[100];		// (x, y, z) = position
			uniform float2 _Properties[100];	// x = radius, y = intensity
			sampler2D _HeatTex;

			// The Vertex Shader 
			vertOutput vert(vertInput input)
			{
				vertOutput o;
				o.pos = mul(UNITY_MATRIX_MVP, input.pos);
				o.worldPos = mul(unity_ObjectToWorld, input.pos).xyz;
				return o;
			}

			// The Fragment Shader
			half4 frag(vertOutput output) : COLOR
			{
				// Loops over all the points
				half h = 0;
				for (int i = 0; i < _Points_Length; i++)
				{
					// Calculates the contribution of each point
					half di = distance(output.worldPos, _Points[i].xyz);

					half ri = _Properties[i].x;
					half hi = 1 - saturate(di / ri);

					h += hi * _Properties[i].y;
				}

				// Converts (0-1) according to the heat texture
				h = saturate(h);
				half4 col = tex2D(_HeatTex, fixed2(h, 0.5));
				return col;
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
}