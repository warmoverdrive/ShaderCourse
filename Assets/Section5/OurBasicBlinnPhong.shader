Shader "Holistic/OurBasicBlinnPhong"
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
            #pragma surface surf BasicBlinnPhong

            // Lighting function must be called "LightingXXXX", where XXXX is the name
            // of the model.
            // Inputs: Surface info, light direction, view direction, and attenuation (intensity)
            half4 LightingBasicBlinnPhong (SurfaceOutput s, half3 lightDir, half3 viewDir, half atten) {

                // calculate halfway vector between light direction and view direction
                half3 h = normalize(lightDir + viewDir);

                // calculate diffuse value based on sixe of angle btween surface normal and light dir
                // max function forces negative numbers to clamp to 0
                half diff = max(0, dot(s.Normal, lightDir));

                // calculate falloff of specular by calculating angle between surface normal
                // and halfway vector
                // max function forces negative numbers to clamp to 0
                float nh = max (0, dot(s.Normal, h));
                // specualr value is the above calc to the power of 48 because Unity...?
                float spec = pow(nh, 48.0);

                // Multiply all values together to get pixel color and return
                half4 c;
                c.rgb = (s.Albedo * _LightColor0.rgb * diff + _LightColor0.rgb * spec) * atten;
                c.a  = s.Alpha;
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
