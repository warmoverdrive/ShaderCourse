Shader "Holistic/OurBasicLambert"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _SpecColor ("Specular Color", Color) = (1,1,1,1)
        _Spec ("Specular", Range(0,1)) = 0.5
        _Gloss ("Gloss", Range(0,1)) = 0.5
    }
    SubShader
    {
        Tags{
            "Queue" = "Geometry"
        }

        CGPROGRAM
            #pragma surface surf BasicLambert

            // Lighting function must be called "LightingXXXX", where XXXX is the name
            // of the model.
            // Takes in SurfaceOutput, light direction, and the attenuation (intensity)
            half4 LightingBasicLambert (SurfaceOutput s, half3 lightDir, half atten) {
                // get dot product between surface normal and light direction
                half NdotL = dot (s.Normal, lightDir);
                half4 c;
                // surface albedo is multiplied by the color of light and the NdotL 
                // multiplied by light intensity
                c.rgb = s.Albedo * _LightColor0.rgb * (NdotL * atten);
                c.a = s.Alpha;
                // return the color generated from lighting model
                return c;
            }

            struct Input
            {
                float2 uv_MainTex;
            };

            float4 _Color;
            half _Spec;
            fixed _Gloss;

            void surf (Input IN, inout SurfaceOutput o)
            {
                o.Albedo = _Color.rgb;
                o.Specular = _Spec;
                o.Gloss = _Gloss;
            }
        ENDCG
    }
    FallBack "Diffuse"
}
