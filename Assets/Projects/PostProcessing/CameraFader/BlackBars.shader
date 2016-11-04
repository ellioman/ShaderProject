Shader "Ellioman/BlackBars"
{
	Properties 
	{
		_MainTex ("Base (RGB)", 2D) = "white" {}
	}
	SubShader 
	{
		Pass
		{
			ZTest Always
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma fragmentoption ARB_precision_hint_fastest
			#pragma target 3.0
			#pragma glsl
			#include "UnityCG.cginc"
			
			
			uniform sampler2D _MainTex;
			uniform float _ClosedVal;
			uniform float4 _ScreenResolution;
			
		       struct appdata_t
            {
                float4 vertex   : POSITION;
                float4 color    : COLOR;
                float2 texcoord : TEXCOORD0;
            };
 
            struct v2f
            {
                  half2 texcoord  : TEXCOORD0;
                  float4 vertex   : SV_POSITION;
                  fixed4 color    : COLOR;
           };   
             
  			v2f vert(appdata_t IN)
            {
                v2f OUT;
                OUT.vertex = mul(UNITY_MATRIX_MVP, IN.vertex);
                OUT.texcoord = IN.texcoord;
                OUT.color = IN.color;
                
                return OUT;
            }

			float4 frag (v2f i) : COLOR
			{
				float2 uv = i.texcoord.xy;
				_ClosedVal *= 0.5;
				if (uv.y > 1.0 - _ClosedVal || uv.y < _ClosedVal)
				{
					return float4(0.0, 0.0, 0.0, 1.0);
				}
				else
				{
					return tex2D(_MainTex, uv);
				}
			}
			
			ENDCG
		}
		
	}
}
