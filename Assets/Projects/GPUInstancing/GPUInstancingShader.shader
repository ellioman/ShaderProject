// Upgrade NOTE: replaced 'UNITY_INSTANCE_ID' with 'UNITY_VERTEX_INPUT_INSTANCE_ID'

Shader "Ellioman/GPUInstancing"
{
    Properties
    {
        _Color ("Color", Color) = (1, 1, 1, 1)
    }

    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            // multi_compile_instancing generates a Shader with two variants: 
            // - one with built-in keyword INSTANCING_ON defined (allowing instancing), 
            // - the other with nothing defined. 
            // This allows the Shader to fall back to a non-instanced version 
            // if instancing isn’t supported on the GPU.
            #pragma multi_compile_instancing

            #include "UnityCG.cginc"

            // UNITY_INSTANCE_ID is used in the vertex Shader input/output structure 
            // to define an instance ID. See SV_InstanceID for more information.
            // You don’t have to define per-instance properties, but setting up an 
            // instance ID is mandatory, because world matrices need it to work correctly.
            struct appdata
            {
                float4 vertex : POSITION;
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            // UNITY_INSTANCING_CBUFFER_START(name) / UNITY_INSTANCING_CBUFFER_END 
            // Every per-instance property must be defined in a specially named constant buffer. 
            // Use this pair of macros to wrap the properties you want to be made unique to each instance.
            UNITY_INSTANCING_CBUFFER_START (MyProperties)
            // This defines a per-instance Shader property with a type and a name. In this example, the _color property is unique.
            UNITY_DEFINE_INSTANCED_PROP (float4, _Color)
            UNITY_INSTANCING_CBUFFER_END

            // Vertex Shader
            v2f vert (appdata v)
            {
                v2f o;

                // This makes the instance ID accessible to Shader functions. 
                // It must be used at the very beginning of a vertex Shader, 
                // and is optional for fragment Shaders.
                UNITY_SETUP_INSTANCE_ID (v);

                // This copies the instance ID from the input structure to the output structure in the vertex Shader. 
                // This is only necessary if you need to access per-instance data in the fragment Shader.
                UNITY_TRANSFER_INSTANCE_ID (v, o);

                // UnityObjectToClipPos(v.vertex) is always preferred where mul(UNITY_MATRIX_MVP,v.vertex) would otherwise be used. 
                // While you can continue to use UNITY_MATRIX_MVP as normal in instanced Shaders, UnityObjectToClipPos is the most 
                // efficient way of transforming vertex positions from object space into clip space.
                // UnityObjectToClipPos is optimized to perform two matrix-vector multiplications simultaneously, and is therefore
                // more efficient than performing the multiplication manually, because the Shader compiler does not automatically
                // perform this optimization.
                o.vertex = UnityObjectToClipPos (v.vertex);

                return o;
            }
           
            fixed4 frag(v2f i) : SV_Target
            {
                // Same as in the Vertex Shader. 
                // Makes the instance ID accessible to Shader functions. 
                UNITY_SETUP_INSTANCE_ID (i);

                // This accesses a per-instance Shader property. It uses an instance ID to index into the instance data array.
                return UNITY_ACCESS_INSTANCED_PROP (_Color);
            }
            ENDCG
        }
    }
}