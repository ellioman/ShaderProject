// 
Shader "Ellioman/WorldSpace2"
{
	// What variables do we want sent in to the shader?
	Properties
	{
		_MainTex ("Texture (RGB)", 2D) = "white" {}
		_HeightScale ("Height Scale", range(0, 300)) = 50
		_TargetPosition("Target Position", vector) = (0,0,0,0)
		_Position1("Position 1", vector) = (0,0,0,0)
		_Position2("Position 2", vector) = (0,0,0,0)
		_Position3("Position 3", vector) = (0,0,0,0)
		_Position4("Position 4", vector) = (0,0,0,0)
	}

	SubShader
    {
    	cull off

        Pass
        {
            CGPROGRAM
 			
	 			// Pragmas
	            #pragma vertex vert
	            #pragma fragment frag

	            // Include some commonly used helper functions
	            #include "UnityCG.cginc"

	            // User Defined Variables
	            uniform sampler2D _MainTex;
	 			uniform float4 _MainTex_ST;
	 			uniform float _HeightScale;
	 			uniform float4 _Position1;
	 			uniform float4 _Position2;
	 			uniform float4 _Position3;
	 			uniform float4 _Position4;

	            // Base Input Structs
	            struct vertexInput
	            {
            	    float4 vertex : POSITION;
            	    float4 texcoord0 : TEXCOORD0;
	            };

	            struct vertexOutput
	            {
	                float4 position : SV_POSITION;
	                float2 texcoord0 : TEXCOORD0;
	            };

				// The Vertex Shader 
	            vertexOutput vert(vertexInput i)
	            {
	                vertexOutput o;
	                o.texcoord0 = TRANSFORM_TEX(i.texcoord0, _MainTex);


//	                float3 worldSpace = mul(_Object2World, i.vertex).rgb;
//
//	                float3 closestPos = _Position1.rgb;
//	                if (distance(worldSpace, _Position2) < distance(worldSpace, closestPos)) closestPos = _Position2.rgb;
//	                if (distance(worldSpace, _Position3) < distance(worldSpace, closestPos)) closestPos = _Position3.rgb;
//	                if (distance(worldSpace, _Position4) < distance(worldSpace, closestPos)) closestPos = _Position4.rgb;
//
//	                closestPos.x += 100.0;
//	                i.vertex.rgb = mul(_World2Object, closestPos);
	                o.position = mul(UNITY_MATRIX_MVP, i.vertex);



//	                // transformation of input.vertex from object coordinates to world coordinates
//	                float4 v = i.vertex;
//
//	                // (+, +)
////	                if (i.texcoord0.x == 0.0 && i.texcoord0.y == 0.0)
////	                {
////	                	_Position1.w = 1.0;
////	                	v = mul(_World2Object, _Position1);
////	                }
////	                // (+, -)
////	                else if (i.texcoord0.x == 0.0 && i.texcoord0.y == 1.0)
////	                {
////	                	_Position2.w = 1.0;
////	                	v = mul(_World2Object, _Position2);
////	                }
////	                // (-, -)
////	                else if (i.texcoord0.x == 1.0 && i.texcoord0.y == 1.0)
////	                {
////	                	_Position3.w = 1.0;
////	                	v = mul(_World2Object, _Position3);
////	                }
////	                // (-, +)
////	                else if (i.texcoord0.x == 1.0 && i.texcoord0.y == 0.0)
////	                {
////	                	_Position4.w = 1.0;
////	                	v = mul(_World2Object, _Position4);
////	                }
//
//	                float x = 0;
//	                float xMult = i.texcoord0.x;
//	                float xMult2 = 1.0 - i.texcoord0.x * 2.0;
//	                float y = 0;
//	                float yMult = i.texcoord0.y;
//	                float z = 0;
//	                if (i.texcoord0.x < 0.5)
//	                {
//	                	float temp = xMult;
//	                	xMult = xMult2;
//	                	xMult2 = xMult;
//	                }
//
////	                if (i.texcoord0.y >= 0.5)
////	                {
////	                	float yMult = 1.0 - i.texcoord0.y * 2.0;
////	                }
//
////	                v.x = xMult * _Position1.x + xMult * _Position2.x + xMult2 * _Position3.x + xMult2 * _Position4.x;
////	                v.x /= 4.0;
////	                v.x /= 2.0;
////	                z = yMult * _Position1.x + yMult * _Position2.x + xMult * _Position3.x + xMult * _Position4.x;
//
//
//				if (i.texcoord0.x > 0.0 && i.texcoord0.x < 1 &&
//					i.texcoord0.y > 0.0 && i.texcoord0.y < 1 
//					)
//				{
////					v = _Position1 + _Position2 + _Position3 + _Position4;
//					v.x = _Position1.x * xMult + _Position2.x * xMult2 + _Position3.x * xMult + _Position4.x * xMult2;
//					v.y = 400;
//					v.z = _Position1.z * xMult + _Position2.z * xMult2 + _Position3.z * xMult + _Position4.z * xMult2;
//					v /= 4.0;
//					v.w = 1.0;
//					v = mul(_World2Object, v);
//				}
////				 else
////				 {
////				 v = i.vertex;
////				 }
////	                float4 worldSpacePos = mul(_Object2World, i.vertex);
////					float dist = distance(_TargetPosition, worldSpacePos);
//
////	                v.y = mul(_World2Object, float4(_TargetPosition.xyz, 1.0)).y;
////					float dist = distance(i.texcoord0, float2(0.5, 0.5));
////					v.y *= 1.0 - dist;
//
//					v.w = 1.0;
//					o.position = mul(UNITY_MATRIX_MVP, v);

	                return o;
	            }

	            // The Fragment Shader
	            fixed4 frag(vertexOutput i) : COLOR
	            {
	          		return float4(1.0, 0.0, 0.0, 1.0);//tex2D(_MainTex, i.texcoord0);
	            }
 			
            ENDCG
        }
    }
    Fallback "VertexLit"
}