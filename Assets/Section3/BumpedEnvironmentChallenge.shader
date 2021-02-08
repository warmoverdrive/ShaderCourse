Shader "Holistic/BumpedEnvironmentChallenge"
{
    Properties
    {
        _normal ("Normal Map", 2D) = "bump" {}
        _cubemap ("Cube Map", CUBE) = "white" {}
    }
    SubShader
    {
        CGPROGRAM

        #pragma surface surf Lambert

        sampler2D _normal;
        samplerCUBE _cubemap;

        struct Input
        {
            float2 uv_normal;
            float3 worldRefl; INTERNAL_DATA
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
            o.Normal = UnpackNormal(tex2D(_normal, IN.uv_normal));
            o.Normal *= 0.3;
            o.Albedo = texCUBE(_cubemap, WorldReflectionVector (IN, o.Normal)).rgb;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
