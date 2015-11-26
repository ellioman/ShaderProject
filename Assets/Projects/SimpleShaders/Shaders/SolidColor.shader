Shader "Simple/SolidColor"
{
	Properties
	{
		_Color ("Color", Color) = (1,1,1,1)
	}
	
    SubShader
    {
        Pass
        {
            CGPROGRAM
 
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
 			
 			// What Variables do I want in the Vertex & Fragment shaders?
            struct v2f
            {
                float4 pos : SV_POSITION;
            };
 			
 			fixed4 _Color; // This needs to be declared so the fragment shader can use it
 
            v2f vert(appdata_base v)
            {
                v2f o;
                o.pos = mul (UNITY_MATRIX_MVP, v.vertex);
                return o;
            }
 			
            fixed4 frag(v2f i) : COLOR
            {
                return _Color;
            }
 
            ENDCG
        }
    }
    Fallback "VertexLit"
}