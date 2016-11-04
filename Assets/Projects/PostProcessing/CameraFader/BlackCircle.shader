Shader "Ellioman/BlackCircle"
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
			uniform float _Size;
			uniform float4 _ScreenResolution;
			uniform float _PositionX;
			uniform float _PositionY;
			
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
				float2 center = float2(_PositionX * _ScreenResolution.x, _PositionY * _ScreenResolution.y);
				float light = 1.0 - clamp(distance(center.xy, (i.texcoord.xy * _ScreenResolution.xy)) - _Size + 1, 0.0, 1.0);

				return tex2D(_MainTex, uv) * light;
			}
			
			ENDCG
		}
		
	}
}
