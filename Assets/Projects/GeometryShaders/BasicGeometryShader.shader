Shader "Ellioman/GeometryShaders/Basic" 
 {        
     Properties 
     {
         _MainTex ("TileTexture", 2D) = "white" {}
         _PointSize("Point Size", Float) = 1.0
     }
     
     SubShader 
     {
         LOD 200
         
         Pass 
         {
             CGPROGRAM
 
             #pragma only_renderers d3d11
             #pragma target 4.0
             
             #include "UnityCG.cginc"
 
             #pragma vertex   myVertexShader
             #pragma geometry myGeometryShader
             #pragma fragment myFragmentShader
             
             #define TAM 36
                         
             struct vIn // Into the vertex shader
             {
                 float4 vertex : POSITION;
                 float4 color  : COLOR0;
             };
             
             struct gIn // OUT vertex shader, IN geometry shader
             {
                 float4 pos : SV_POSITION;
                 float4 col : COLOR0;
             };
             
              struct v2f // OUT geometry shader, IN fragment shader 
             {
                 float4 pos           : SV_POSITION;
                 float2 uv_MainTex : TEXCOORD0;
                 float4 col : COLOR0;
             };
             
             float4       _MainTex_ST;
             sampler2D _MainTex; 
             float     _PointSize;            
             // ----------------------------------------------------
             gIn myVertexShader(vIn v)
             {
                 gIn o; // Out here, into geometry shader
                 // Passing on color to next shader (using .r/.g there as tile coordinate)
                 o.col = v.color;                
                 // Passing on center vertex (tile to be built by geometry shader from it later)
                 o.pos = v.vertex;
  
                 return o;
             }
             
             // ----------------------------------------------------
             
             [maxvertexcount(TAM)] 
             // ----------------------------------------------------
             // Using "point" type as input, not "triangle"
             void myGeometryShader(point gIn vert[1], inout TriangleStream<v2f> triStream)
             {                            
                 float f = _PointSize/20.0f;  //half size
                 
                 const float4 vc[TAM] = { float4( -f,  f,  f, 0.0f), float4(  f,  f,  f, 0.0f), float4(  f,  f, -f, 0.0f),    //Top                                 
                                          float4(  f,  f, -f, 0.0f), float4( -f,  f, -f, 0.0f), float4( -f,  f,  f, 0.0f),    //Top
                                          
                                          float4(  f,  f, -f, 0.0f), float4(  f,  f,  f, 0.0f), float4(  f, -f,  f, 0.0f),     //Right
                                          float4(  f, -f,  f, 0.0f), float4(  f, -f, -f, 0.0f), float4(  f,  f, -f, 0.0f),     //Right
                                          
                                          float4( -f,  f, -f, 0.0f), float4(  f,  f, -f, 0.0f), float4(  f, -f, -f, 0.0f),     //Front
                                          float4(  f, -f, -f, 0.0f), float4( -f, -f, -f, 0.0f), float4( -f,  f, -f, 0.0f),     //Front
                                          
                                          float4( -f, -f, -f, 0.0f), float4(  f, -f, -f, 0.0f), float4(  f, -f,  f, 0.0f),    //Bottom                                         
                                          float4(  f, -f,  f, 0.0f), float4( -f, -f,  f, 0.0f), float4( -f, -f, -f, 0.0f),     //Bottom
                                          
                                          float4( -f,  f,  f, 0.0f), float4( -f,  f, -f, 0.0f), float4( -f, -f, -f, 0.0f),    //Left
                                          float4( -f, -f, -f, 0.0f), float4( -f, -f,  f, 0.0f), float4( -f,  f,  f, 0.0f),    //Left
                                          
                                          float4( -f,  f,  f, 0.0f), float4( -f, -f,  f, 0.0f), float4(  f, -f,  f, 0.0f),    //Back
                                          float4(  f, -f,  f, 0.0f), float4(  f,  f,  f, 0.0f), float4( -f,  f,  f, 0.0f)     //Back
                                          };
                                          
                 
                 const float2 UV1[TAM] = { float2( 0.0f,    0.0f ), float2( 1.0f,    0.0f ), float2( 1.0f,    0.0f ),         //Esta em uma ordem
                                           float2( 1.0f,    0.0f ), float2( 1.0f,    0.0f ), float2( 1.0f,    0.0f ),         //aleatoria qualquer.
                                           
                                           float2( 0.0f,    0.0f ), float2( 1.0f,    0.0f ), float2( 1.0f,    0.0f ), 
                                           float2( 1.0f,    0.0f ), float2( 1.0f,    0.0f ), float2( 1.0f,    0.0f ),
                                           
                                           float2( 0.0f,    0.0f ), float2( 1.0f,    0.0f ), float2( 1.0f,    0.0f ), 
                                           float2( 1.0f,    0.0f ), float2( 1.0f,    0.0f ), float2( 1.0f,    0.0f ),
                                           
                                           float2( 0.0f,    0.0f ), float2( 1.0f,    0.0f ), float2( 1.0f,    0.0f ), 
                                           float2( 1.0f,    0.0f ), float2( 1.0f,    0.0f ), float2( 1.0f,    0.0f ),
                                           
                                           float2( 0.0f,    0.0f ), float2( 1.0f,    0.0f ), float2( 1.0f,    0.0f ), 
                                           float2( 1.0f,    0.0f ), float2( 1.0f,    0.0f ), float2( 1.0f,    0.0f ),
                                           
                                           float2( 0.0f,    0.0f ), float2( 1.0f,    0.0f ), float2( 1.0f,    0.0f ), 
                                           float2( 1.0f,    0.0f ), float2( 1.0f,    0.0f ), float2( 1.0f,    0.0f )                                            
                                             };    
                                                             
                 const int TRI_STRIP[TAM]  = {  0, 1, 2,  3, 4, 5,
                                                6, 7, 8,  9,10,11,
                                               12,13,14, 15,16,17,
                                               18,19,20, 21,22,23,
                                               24,25,26, 27,28,29,
                                               30,31,32, 33,34,35  
                                               }; 
                                                             
                 v2f v[TAM];
                 int i;
                 
                 // Assign new vertices positions 
                 for (i=0;i<TAM;i++) { v[i].pos = vert[0].pos + vc[i]; v[i].col = vert[0].col;    }
 
                 // Assign UV values
                 for (i=0;i<TAM;i++) v[i].uv_MainTex = TRANSFORM_TEX(UV1[i],_MainTex); 
                 
                 // Position in view space
                 for (i=0;i<TAM;i++) { v[i].pos = mul(UNITY_MATRIX_MVP, v[i].pos); }
                     
                 // Build the cube tile by submitting triangle strip vertices
                 for (i=0;i<TAM/3;i++)
                 { 
                     triStream.Append(v[TRI_STRIP[i*3+0]]);
                     triStream.Append(v[TRI_STRIP[i*3+1]]);
                     triStream.Append(v[TRI_STRIP[i*3+2]]);    
                                     
                     triStream.RestartStrip();
                 }
              }
              
              // ----------------------------------------------------
             float4 myFragmentShader(v2f IN) : COLOR
             {
                 //return float4(1.0,0.0,0.0,1.0);
                 return IN.col;
             }
 
             ENDCG
         }
     } 
 }