Shader "Ellioman/TextureAtlas"
{
	Properties
	{
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_TextureColumns ("Texture Columns", float) = 1
		_TextureRows ("Texture Rows", float) = 1
		_Speed ("Speed", float) = 1
	}

	SubShader 
	{
		Tags
		{
			"RenderType"="Opaque"
		}
		LOD 200
		
		CGPROGRAM
			// Pragmas
			#pragma surface surfaceShader Lambert vertex:vertexShader
			#pragma target 3.0
			
			// User Defined Variables
			uniform sampler2D _MainTex;
			uniform float _TextureColumns;
			uniform float _TextureRows;
			uniform float _Speed;
			uniform float _AnimationTime;

			// Base Input Structs
			struct Input 
			{
				float2 image_uv;
			};
			
			// The Vertex Shader
			void vertexShader(inout appdata_full IN, out Input OUT)
			{
				_AnimationTime *= _Speed;
				float xPos = floor(_AnimationTime) % _TextureColumns; 
				float yPos = floor(_AnimationTime / _TextureColumns) % _TextureRows;

				float texWidth = (1.0 / _TextureColumns);
				float texHeight = (1.0 / _TextureRows);

				float uu = (xPos * texWidth) + (texWidth * IN.texcoord.x);
				float vv = (yPos * texHeight) + (texHeight * IN.texcoord.y);

				OUT.image_uv = float2(uu,vv);
			}
			
			void surfaceShader(Input IN, inout SurfaceOutput OUT) 
			{
				half4 c = tex2D (_MainTex, IN.image_uv);
				OUT.Albedo = c.rgb;
				OUT.Alpha = c.a;
			}
		ENDCG
	}

    Fallback off
}