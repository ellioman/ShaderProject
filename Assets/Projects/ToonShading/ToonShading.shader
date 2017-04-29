// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// WATCH FULL EXPLANATION ON YOUTUBE-VIDEO: https://www.youtube.com/watch?v=3qBDTh9zWrQ 
Shader "Ellioman/ToonShader"
{
	Properties
	{
		_Color ("Diffuse Material Color", Color) = (1,1,1,1) 
		_UnlitColor ("Unlit Color", Color) = (0.5,0.5,0.5,1)
		_DiffuseThreshold ("Lighting Threshold", Range(-1.1,1)) = 0.1
		_SpecColor ("Specular Material Color", Color) = (1,1,1,1) 
		_Shininess ("Shininess", Range(0.5,1)) = 1	
		_OutlineThickness ("Outline Thickness", Range(0,1)) = 0.1
		_MainTex ("Main Texture", 2D) = "AK47" {}
	}
	
	SubShader
	{
		Pass
		{
			Tags
			{
				"LightMode" = "ForwardBase"
			}
			
			// pass for ambient light and first light source
			CGPROGRAM
				#pragma vertex vertexShader  //tells the cg to use a vertex-shader called vert
				#pragma fragment fragmentShader //tells the cg to use a fragment-shader called frag
				
				// User Defined Variables
				uniform float4 _Color;
				uniform float4 _UnlitColor;
				uniform float _DiffuseThreshold;
				uniform float4 _SpecColor;
				uniform float _Shininess;
				uniform float _OutlineThickness;
				
				// Unity Defined Variables
				uniform float4 _LightColor0;
				uniform sampler2D _MainTex;
				uniform float4 _MainTex_ST;
				
				// Base Input Structs
				struct VSInput
				{
					float4 vertex : POSITION;
					float3 normal : NORMAL;
					float4 texcoord : TEXCOORD0;
				};
				
				struct VSOutput
				{
					float4 pos : SV_POSITION;
					float3 normalDir : TEXCOORD1;
					float4 lightDir : TEXCOORD2;
					float3 viewDir : TEXCOORD3;
					float2 uv : TEXCOORD0; 
				};
				
				VSOutput vertexShader(VSInput IN)
				{
					VSOutput OUT;
					
					// normalDirection
					OUT.normalDir = normalize(mul(float4(IN.normal, 0.0 ), unity_WorldToObject).xyz );
					
					// World position
					float4 posWorld = mul(unity_ObjectToWorld, IN.vertex);
					
					// view direction
					OUT.viewDir = normalize( _WorldSpaceCameraPos.xyz - posWorld.xyz ); //vector from object to the camera
					
					// light direction
					float3 fragmentToLightSource = ( _WorldSpaceCameraPos.xyz - posWorld.xyz);
					OUT.lightDir = float4(
						normalize( lerp(_WorldSpaceLightPos0.xyz , fragmentToLightSource, _WorldSpaceLightPos0.w)),
						lerp(1.0 , 1.0/length(fragmentToLightSource), _WorldSpaceLightPos0.w)
					);
					
					// fragmentInput output;
					OUT.pos = UnityObjectToClipPos(IN.vertex);  
					
					// UV-Map
					OUT.uv = IN.texcoord;
					return OUT;
				}
				
				float4 fragmentShader(VSOutput IN) : COLOR
				{
					float nDotL = saturate(dot(IN.normalDir, IN.lightDir.xyz)); 
					
					// Diffuse threshold calculation
					float diffuseCutoff = saturate((max(_DiffuseThreshold, nDotL) - _DiffuseThreshold ) *1000 );
					
					// Specular threshold calculation
					float specularCutoff = saturate(max(_Shininess, dot(reflect(-IN.lightDir.xyz, IN.normalDir), IN.viewDir))-_Shininess ) * 1000;
					
					// Calculate Outlines
					float outlineStrength = saturate((dot(IN.normalDir, IN.viewDir ) - _OutlineThickness) * 1000 );
					
					float3 ambientLight = (1.0 - diffuseCutoff) * _UnlitColor.xyz; //adds general ambient illumination
					float3 diffuseReflection = (1.0 - specularCutoff) * _Color.xyz * diffuseCutoff;
					float3 specularReflection = _SpecColor.xyz * specularCutoff;
					float3 combinedLight = (ambientLight + diffuseReflection) * outlineStrength + specularReflection;
					
					return float4(combinedLight, 1.0) + tex2D(_MainTex, IN.uv); // DELETE LINE COMMENTS & ';' TO ENABLE TEXTURE
				}

			ENDCG
		}
	}
}