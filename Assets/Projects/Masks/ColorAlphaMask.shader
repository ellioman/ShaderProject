Shader "Ellioman/Masks/ColorAlphaMask"
{
    Properties {
        _Color ("Color", Color) = (1,1,1,1)
        _SpecCol ("Specular Color", Color) = (1,1,1,1)
        _Spec ("Specularity", Range (0,1)) = 0.8
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _SecondTex ("SecondAlbedo (RGB)", 2D) = "white" {}
        _BumpMap ("Normal Map", 2D) = "bump" {}
        _Mask ("Color Mask", 2D) = "white" {}
        _AlphaMask ("Alpha Mask", 2D) = "white" {}
        _Test ("Test", Range (-1,1)) = 0
        _AlphaAmount ("_Alpha Amount", Range (-1,1)) = 0
        _AnimationSpeed ("Animation Speed", Range (0,20)) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" }
        LOD 200
       
        CGPROGRAM
        #pragma surface surf Spec fullforwardshadows addshadow alpha
 
        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0
 
        sampler2D _MainTex;
        sampler2D _SecondTex;
        sampler2D _BumpMap;
        sampler2D _Mask;
        sampler2D _AlphaMask;
 
        struct Input {
            float2 uv_MainTex;
            float2 uv_SecondTex;
            float2 uv_BumpMap;
            float2 uv_Mask;
            float2 uv_AlphaMask;
        };
 
        half _Spec;
        half _Test;
        half _AlphaAmount;
        half _AnimationSpeed;
        fixed4 _SpecCol;
        fixed4 _Color;
 
        half4 LightingSpec (SurfaceOutput s, half3 lightDir, half3 viewDir, half atten)
        {
            s.Normal = normalize (s.Normal);
 
            half3 h = normalize (lightDir + viewDir);
 
            half diff = max (0, dot (s.Normal, lightDir));
 
            float nh = max (0, dot (s.Normal, h));
            float spec = pow (nh, 4096.0 * pow (s.Specular, 2)) * s.Specular * 2;
 
            half4 c;
            c.rgb = (s.Albedo * _LightColor0.rgb * diff + _LightColor0.rgb * spec * _SpecCol) * atten;
            c.a = s.Alpha;
            return c;
        }
 
        void surf (Input IN, inout SurfaceOutput o)
        {
            // Albedo comes from a texture tinted by color
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
            fixed4 c2 = tex2D (_SecondTex, IN.uv_SecondTex + float2(_Time.x * 0.0, 0.0)) * _Color;
            float cMask = clamp(tex2D (_Mask, IN.uv_Mask).g + sin(_Time.x * _AnimationSpeed), 0, 1);
            float aMask = tex2D (_AlphaMask, IN.uv_AlphaMask + float2(_Time.x * 0.0, 0.0)).g - sin(_Time.y) * _AlphaAmount;

			o.Albedo = lerp(c.rgb, c2.rgb, cMask);
            o.Specular = _Spec;
            o.Normal = UnpackNormal (tex2D (_BumpMap, IN.uv_BumpMap));

//            o.Alpha = lerp(c.a, c2.a, maskVal - _Test);
            o.Alpha = aMask;
//			o.Alpha = 1.0;
        }
        ENDCG
    }
    FallBack "Diffuse"
}