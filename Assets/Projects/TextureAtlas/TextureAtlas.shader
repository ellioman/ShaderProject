Shader "Ellioman/TextureAtlas"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _TextureColumns ("Texture Columns", float) = 1
        _TextureRows ("Texture Rows", float) = 1
        _AnimationSpeed ("Animation Speed", float) = 1
        _AnimationTime ("Animation Time", float) = 1
    }

    SubShader 
	{
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Lambert vertex:vert
		#pragma target 3.0
	    uniform sampler2D _MainTex;
		uniform float _TextureColumns;
		uniform float _TextureRows;
		uniform float _AnimationSpeed;
		uniform float _AnimationTime;

	    struct Input 
		{
			float2 image_uv;
		};

		void vert(inout appdata_full v, out Input o)
		{
	        float time = floor(_AnimationTime * _AnimationSpeed);

	        float xPos = floor(time) % _TextureColumns; 
	        float yPos = floor(time / _TextureColumns) % _TextureRows;

			float texWidth = (1.0 / _TextureColumns);
			float texHeight = (1.0 / _TextureRows);

			float uu = (xPos * texWidth) + (texWidth * v.texcoord.x);
	        float vv = (yPos * texHeight) + (texHeight * v.texcoord.y);

	        o.image_uv = float2(uu,vv);
		}

	    void surf (Input IN, inout SurfaceOutput o) 
		{
			half4 c = tex2D (_MainTex, IN.image_uv);
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}

		ENDCG
	}

    Fallback off
}