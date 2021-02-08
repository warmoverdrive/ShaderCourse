Shader "Holistic/PropertiesChallenge4"
{
    Properties
    {
        // Its important that all variable names are consistenent throughout the shader
        _myTex ("Albedo Texture", 2D) = "white" {}
        _myEmis ("Emissive Texture", 2D) = "black" {}
    }
    SubShader
    {
        CGPROGRAM
            #pragma surface surf Lambert

            sampler2D _myTex;
            sampler2D _myEmis;

            struct Input
            {
                // these must share names with textures for some reason
                float2 uv_myTex;
                float2 uv_myEmis;
            };

            void surf (Input IN, inout SurfaceOutput o)
            {
                o.Albedo = tex2D(_myTex, IN.uv_myTex).rgb;
                o.Emission = tex2D(_myEmis, IN.uv_myEmis).rgba;
            }
        ENDCG
    }
    FallBack "Diffuse"
}
