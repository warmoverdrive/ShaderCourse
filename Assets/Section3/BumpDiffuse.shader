Shader "Holistic/BumpDiffuse"
{
    Properties
    {
        _myDiffuse ("Diffuse Texture", 2D) = "white" {}
        _myNormal ("Normal Texture", 2D) = "bump" {}
        _mySlider ("Normal Amount", Range(0,10)) = 1
        _texScale ("Texture Scale", Range(0,10)) = 1
    }
    SubShader
    {
        CGPROGRAM
        #pragma surface surf Lambert

        sampler2D _myDiffuse;
        sampler2D _myNormal;
        half _mySlider;
        half _texScale;

        struct Input
        {
            float2 uv_myDiffuse;
            float2 uv_myNormal;
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
            o.Albedo = tex2D(_myDiffuse, IN.uv_myDiffuse * _texScale).rgb;
            o.Normal = UnpackNormal(tex2D(_myNormal, IN.uv_myNormal * _texScale));
            o.Normal *= float3(_mySlider, _mySlider, 1);
        }
        ENDCG
    }
    FallBack "Diffuse"
}
