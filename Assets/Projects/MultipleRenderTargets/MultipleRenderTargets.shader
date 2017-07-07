// Thanks to Keijiro Takahashi for this example!
// https://github.com/keijiro/UnityMrtTest

Shader "Ellioman/MultipleRenderTargets"
{
    Properties
    {
        _MainTex("", 2D) = "white"{}
        _SecondTex("", 2D) = "white"{}
        _ThirdTex("", 2D) = "white"{}
        _FourthTex("", 2D) = "white"{}
    }

    CGINCLUDE

    #include "UnityCG.cginc"

    sampler2D _MainTex;
    sampler2D _SecondTex;
    sampler2D _ThirdTex;
    sampler2D _FourthTex;

    // MRT shader
    struct FragmentOutput
    {
        half4 dest0 : SV_Target0;
        half4 dest1 : SV_Target1;
        half4 dest2 : SV_Target2;
    };

    FragmentOutput frag_mrt(v2f_img i) : SV_Target
    {
        FragmentOutput o;
        o.dest0 = frac(i.uv.x);
        o.dest1 = frac(i.uv.y);
        o.dest2 = frac(1.0 / i.uv.x);
        return o;
    }

    // Simple combiner
    half4 frag_combine(v2f_img i) : SV_Target
    {
        half4 t1 = tex2D(_MainTex, i.uv);
        //return t1;

        half4 t2 = tex2D(_SecondTex, i.uv);
        //return t2;

        half4 t3 = tex2D(_ThirdTex, i.uv);
        //return t3;

        half4 t4 = tex2D(_FourthTex, i.uv);
        t4 *= 2.5;
        //return t4;

        //return min(frac(t2 - t3), frac(t2 + t3));
        return t4 * half4(t1.r, t2.g, t3.b, 1);
    }

    ENDCG

    SubShader
    {
        Cull Off ZWrite Off ZTest Always
        Pass
        {
            CGPROGRAM
            #pragma vertex vert_img
            #pragma fragment frag_mrt
            ENDCG
        }
        Pass
        {
            CGPROGRAM
            #pragma vertex vert_img
            #pragma fragment frag_combine
            ENDCG
        }
    }
}