Shader "Holistic/ToonRamp"
{
    Properties
    {
        _AlbedoTex ("Albedo Texture", 2D) = "white" {}
        _RampTex ("Ramp Texture", 2D) = "white" {}
        _NormalTex ("Normal Texture", 2D) = "bump" {}
        _NormAmt ("Normal Amount", Range(0,10)) = 1
    }
    SubShader
    {
        Tags{
            "Queue" = "Geometry"
        }

        CGPROGRAM
            #pragma surface surf ToonRamp

            sampler2D _AlbedoTex;
            sampler2D _RampTex;
            sampler2D _NormalTex;
            half _NormAmt;

            float4 LightingToonRamp (SurfaceOutput s, half3 lightDir, half atten) {
                float diff = dot(s.Normal, lightDir);
                float h = diff * 0.5 + 0.5;
                float2 rh = h;
                float3 ramp = tex2D(_RampTex, rh).rgb;

                float4 c;
                c.rgb = s.Albedo * _LightColor0.rgb * (ramp);
                c.a = s.Alpha;
                return c;
            }

            struct Input
            {
                float2 uv_AlbedoTex;
                float2 uv_NormalTex;
            };

            void surf (Input IN, inout SurfaceOutput o)
            {
                o.Albedo = tex2D(_AlbedoTex, IN.uv_AlbedoTex).rgb;
                o.Normal = UnpackNormal(tex2D(_NormalTex, IN.uv_NormalTex));
                o.Normal *= float3(_NormAmt, _NormAmt, 1);
            }
        ENDCG
    }
    FallBack "Diffuse"
}
