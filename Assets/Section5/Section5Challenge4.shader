Shader "Holistic/Section5Challenge4"
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

            half4 LightingBasicBlinnPhong (SurfaceOutput s, half3 lightDir, half3 viewDir, half atten) {

                half3 h = normalize(lightDir + viewDir);

                half diff = max(0, dot(s.Normal, lightDir));

                float nh = max (0, dot(s.Normal, h));
                float spec = pow(nh, 48.0);

                half4 c;
                c.rgb = (s.Albedo * _LightColor0.rgb * diff + _LightColor0.rgb * spec) * atten * _SinTime;
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
