Shader "test/MyShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Num ("Number", Range(0, 25)) = 1

        _Offset ("Offset", Vector) = (0.0, 0.0, 0.0, 0.0)
        _EndScale ("End Scale", Vector) = (1.0, 1.0, 1.0, 1.0)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100
 
        Pass
        {
            CGPROGRAM

	            // What functions should we use for the vertex and fragment shaders?
	            #pragma vertex vert
	            #pragma fragment frag
	            #pragma geometry geom

	            // Include some commonly used helper functions
	            #include "UnityCG.cginc"

	            // ---------------------------
				// Variables
				// ---------------------------

		 		// What variables do I want in the Vertex & Fragment shaders?
	            struct appdata
	            {
	                float4 vertex : POSITION;
	                float3 normal : NORMAL;
	                float2 uv : TEXCOORD0;
	            };
	 
	            struct v2f
	            {
	                float4 vertex : SV_POSITION;
	                float3 normal : NORMAL;
	                float2 uv : TEXCOORD0;
	                float3 worldPosition : TEXCOORD1;
	            };

	            // User-specified properties
	            sampler2D _MainTex;
				float4 _MainTex_ST;
				float4 _Offset;
				float _Num;
				float4 _EndScale;

				// ---------------------------
				// Shaders
				// ----------------------------
					
				// The Vertex Shader 
	            v2f vert (appdata v)
	            {
	                v2f o;
	                o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);
	                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
	                o.normal = v.normal;
	                o.worldPosition = mul(_Object2World, v.vertex).xyz;

	                return o;
	            }

	            // The Geometry Shader
	            [maxvertexcount(75)] // How many vertices can the shader output?
	            void geom(triangle v2f input[3], inout TriangleStream<v2f> OutputStream)
	            {
	                v2f test = (v2f) 0;
	                float3 normal = normalize(cross(input[1].worldPosition.xyz - input[0].worldPosition.xyz, input[2].worldPosition.xyz - input[0].worldPosition.xyz));
	                float4 curOffset = float4(0.0, 0.0, 0.0, 0.0);

	                float4 curSize = float4(1.0, 1.0, 1.0, 1.0);
	                float4 scaleChange = (curSize - _EndScale) / _Num;

	                for(int k = 0; k < _Num; k++)
	                {
		                for(int i = 0; i < 3; i++)
		                {
		                    test.normal = normal;
		                    test.uv = input[i].uv;

		                    float4 a = float4((curSize * input[i].worldPosition.xyz + curOffset), 1.0);
		                    a = mul(_World2Object, a);
		                    test.vertex = mul(UNITY_MATRIX_MVP, a);

		                    OutputStream.Append(test);
		                }

		                curOffset.xyz += _Offset.xyz;
		                curSize -= scaleChange;
		                OutputStream.RestartStrip();
	                }
	            }

	            // The Fragment Shader
	            fixed4 frag (v2f i) : SV_Target
	            {
	                // sample the texture
	                fixed4 col = tex2D(_MainTex, i.uv);

	                // Some Fake Lighting
	                float3 lightDir = float3(-1, 1, -0.25);
	                float ndotl = dot(i.normal, normalize(lightDir));

	                // Output
	                return col * ndotl;
	            }
	        
            ENDCG
        }
    }
}