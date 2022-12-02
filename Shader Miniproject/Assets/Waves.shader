Shader "Custom/Waves"
{
    Properties
    {
        //these are where we set our properties for our shader.
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0
        _Amplitude ("Amplitude", Float) = 1
        _Wavelenght ("Wavelenght", Float) = 10
        _Speed ("Speed", Float) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200
        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows vertex:vert addshadow

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
        };

        half _Glossiness;
        half _Metallic;
        fixed4 _Color;
        float _Amplitude, _Wavelenght, _Speed;

        void vert (inout appdata_full vertexData){
            // here we assign our P value to make our vertices final position, regarding the xyz axes.
            float3 P = vertexData.vertex.xyz;

            // Using the default way of calculating the wavelenght, so we can adjust it ourselves.
            // assigning our k to our wavelenght.
            float k = 2 * UNITY_PI / _Wavelenght;


            float f = k * (P.x - _Speed * _Time.y);
            //float f2 = k * (P.z - _Speed * _Time.y);

            // Using Amplitude for our sinus wave so we dont limit ourselves to Sin function of 1.
            P.y = _Amplitude * sin(f);
            //P.y = _Amplitude * cos(f);

            // we are using our normal vectors in order for us to get shadows into our wave.
            // in order for us to get all of our tangent vectors, we have to normalize our surface tangent.
            float3 tangent = normalize (float3(1, k * _Amplitude * cos(f), 0));

            //we make our tangent components normalized, in order for the shadows to come in.
            float3 normal = float3(-tangent.y, tangent.x, 0);

            vertexData.vertex.xyz = P;

            vertexData.normal = normal;

        }

        UNITY_INSTANCING_BUFFER_START(Props)
            // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            // Albedo comes from a texture tinted by color
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = c.rgb;
            // Metallic and smoothness come from slider variables
            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
