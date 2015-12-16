Shader "test/MyShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Num ("Number", Range(0, 25)) = 1

        _Offset ("Offset", Vector) = (0.0, 0.0, 0.0, 0.0)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100
 cull off
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma geometry geom
           
            #include "UnityCG.cginc"
 
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
 			
            sampler2D _MainTex;
			float4 _MainTex_ST;
			float4 _Offset;
			float _Num;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.normal = v.normal;
                o.worldPosition = mul(_Object2World, v.vertex).xyz;

                return o;
            }
 
            [maxvertexcount(75)]
            void geom(triangle v2f input[3], inout TriangleStream<v2f> OutputStream)
            {
            	
                v2f test = (v2f)0;
                float3 normal = normalize(cross(input[1].worldPosition.xyz - input[0].worldPosition.xyz, input[2].worldPosition.xyz - input[0].worldPosition.xyz));
                float4 curOffset = float4(0.0, 0.0, 0.0, 0.0);
                for(int k = 0; k < _Num; k++)
                {
	                for(int i = 0; i < 3; i++)
	                {
	                    test.normal = normal;
	                    test.uv = input[i].uv;

	                    float4 a = float4(input[i].worldPosition.xyz + curOffset, 1.0);
	                    a = mul(_World2Object, a);
	                    test.vertex = mul(UNITY_MATRIX_MVP, a);

	                    OutputStream.Append(test);
	                }

	                curOffset.xyz += _Offset.xyz;
	                OutputStream.RestartStrip();
                }
            }
           
            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
 
                float3 lightDir = float3(-1, 1, -0.25);
                float ndotl = dot(i.normal, normalize(lightDir));
 
                return col * ndotl;
            }
            ENDCG
        }
    }
}