Shader "Holistic/DotProduct"
{
    SubShader
    {
        CGPROGRAM
        #pragma surface surf Lambert

        struct Input
        {
            float3 viewDir;
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
            o.Albedo.rg = float2(0, 1-dot(IN.viewDir, o.Normal));
        }
        ENDCG
    }
    FallBack "Diffuse"
}
