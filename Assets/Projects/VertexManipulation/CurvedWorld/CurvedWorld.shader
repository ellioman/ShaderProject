// Code from https://alastaira.wordpress.com/2013/10/25/animal-crossing-curved-world-shader/
Shader "Ellioman/CurvedWorld"
{
	Properties
	{
		_MainTex ("Base (RGB)", 2D) = "white" {} // Diffuse texture
		_Curvature ("Curvature", Float) = 0.001 // Degree of curvature
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
			#pragma surface surfaceShader Lambert vertex:vertexShader addshadow
			
			// User Defined Variables
			uniform sampler2D _MainTex;
			uniform float _Curvature;
			
			// Base Input Structs
			struct Input
			{
				float2 uv_MainTex;
			};
			
			// The Vertex Shader 
			void vertexShader(inout appdata_full IN)
			{
				// Transform the vertex coordinates from model space into world space
				float4 vv = mul( _Object2World, IN.vertex );
				
				// Now adjust the coordinates to be relative to the camera position
				vv.xyz -= _WorldSpaceCameraPos.xyz;
				
				// Reduce the y coordinate (i.e. lower the "height") of each vertex based
				// on the square of the distance from the camera in the z axis, multiplied
				// by the chosen curvature factor
				//vv = float4( 0.0f, (vv.z * vv.z) * - _Curvature, 0.0f, 0.0f );
				vv = float4( 0.0f, ((vv.z * vv.z) + (vv.x * vv.x)) * - _Curvature, 0.0f, 0.0f );
				
				// Now apply the offset back to the vertices in model space
				IN.vertex += mul(_World2Object, vv);
			}
			
			// The Surface Shader
			void surfaceShader(Input IN, inout SurfaceOutput o)
			{
				half4 c = tex2D (_MainTex, IN.uv_MainTex);
				o.Albedo = c.rgb;
				o.Alpha = c.a;
			}
		ENDCG
	}
}