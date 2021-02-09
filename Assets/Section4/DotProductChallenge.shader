Shader "Holistic/DotProductChallege"
{
    Properties
    {
        _diffuse ("Diffuse Texture", 2D) = "white" {}
        _RimColor ("Rim Color", Color) = (0,0.5,0.5,0)
        _RimPower ("Rim Power", Range(0.5, 8.0)) = 3.0
        _sWidth ("Stripe Width", Range(0, 20)) = 10
    }
    SubShader
    {
        CGPROGRAM
        #pragma surface surf Lambert

        struct Input
        {
            float2 uv_diffuse;
            float3 viewDir;
            float3 worldPos;
        };

        sampler2D _diffuse;
        float4 _RimColor;
        float _RimPower;
        float _sWidth;

        void surf (Input IN, inout SurfaceOutput o)
        {
            o.Albedo = tex2D(_diffuse, IN.uv_diffuse);
            
            half rim = 1- saturate(dot(normalize(IN.viewDir), o.Normal));

            o.Emission = frac(IN.worldPos.y * (20 - _sWidth) * 0.5) > 0.4 ?
                            float3(0,1,0)*pow(rim, _RimPower) : float3(1,0,0)*pow(rim, _RimPower);
        }
        ENDCG
    }
    FallBack "Diffuse"
}
