Shader "Ellioman/TextureAtlas"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _TextureColumns ("Texture Columns", float) = 1
        _TextureRows ("Texture Rows", float) = 1
        _AnimationSpeed ("Animation Speed", float) = 1
        _Test ("Test Speed", float) = 1
    }

    CGINCLUDE

    sampler2D _MainTex;
	float _TextureColumns;
	float _TextureRows;
	float _AnimationSpeed;
	float _Test;

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

    // The Vertex Shader 
    vertexOutput vert(vertexInput i)
    {
        vertexOutput o;
        o.position = mul(UNITY_MATRIX_MVP, i.vertex);

        float time = floor(_Time.x * _AnimationSpeed);

        float xPos = time % _TextureColumns;
        float yPos = floor(time / _TextureColumns) % _TextureRows;

		float texWidth = (1.0 / _TextureColumns);
		float texHeight = (1.0 / _TextureRows);

		float u = (xPos * texWidth) + (texWidth * i.texcoord0.x);
        float v = (yPos * texHeight) + (texHeight * i.texcoord0.y);

        o.texcoord0.xy = float2(u,v);

        return o;
    }

	// The Fragment Shader
    fixed4 frag(vertexOutput i) : COLOR
	{
		return tex2D(_MainTex, i.texcoord0.xy);
	}

    ENDCG


    SubShader
    {
	    Pass
		{
			CGPROGRAM

				#pragma vertex vert
				#pragma fragment frag
				#pragma fragmentoption ARB_precision_hint_fastest
			
			ENDCG
		}
	}

    Fallback off
}