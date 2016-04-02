// 
Shader "Ellioman/VertexManipulation/Random"
{
	// What variables do we want sent in to the shader?
	Properties
	{
	  _MainTex ("Texture (RGB)", 2D) = "white" {}
	  _HeightScale ("Height Scale", range(0, 300)) = 50
	}

	SubShader
    {
        Pass
        {
            CGPROGRAM
 			
	 			// Pragmas
	            #pragma vertex vert
	            #pragma fragment frag
	            
	            // Include some commonly used helper functions
	            #include "UnityCG.cginc"

	            // User Defined Variables
	            uniform sampler2D _MainTex;
	 			uniform float4 _MainTex_ST;
	 			uniform float _HeightScale;

	            // Base Input Structs
	            struct vertexInput
	            {
            	    float4 vertex : POSITION;
            	    float4 texcoord0 : TEXCOORD0;
	            };

	            struct vertexOutput
	            {
	                float4 position : SV_POSITION;
	                float4 texcoord0 : TEXCOORD0;
	            };

				// Random function
				float rand(float3 co)
				{
					return frac(sin( dot(co.xyz ,float3(12.9898,78.233,45.5432) )) * 43758.5453);
				}

				// The Vertex Shader 
	            vertexOutput vert(vertexInput i)
	            {
	                vertexOutput o;

	                float yVal = (_SinTime.w * rand(i.vertex.xyz)) * _HeightScale;
	                float4 k = float4(i.vertex.x, yVal, i.vertex.zw);
	                o.position = mul(UNITY_MATRIX_MVP, k);
	                o.texcoord0.xy = TRANSFORM_TEX(i.texcoord0, _MainTex);
	                return o;
	            }

	            // The Fragment Shader
	            fixed4 frag(vertexOutput i) : SV_Target
	            {
	          		return tex2D(_MainTex, i.texcoord0);
	            }
 			
            ENDCG
        }
    }
    Fallback "VertexLit"
}