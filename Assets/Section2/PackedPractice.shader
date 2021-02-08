﻿Shader "Holistic/PackedPractice"
{
    Properties
    {
        _myColor ("Example Color", Color) = (1,1,1,1)

    }
    SubShader
    {
        CGPROGRAM
            #pragma surface surf Lambert

            struct Input
            {
                float2 uv_MainTex;
            };

            fixed4 _myColor;

            void surf (Input IN, inout SurfaceOutput o)
            {
                o.Albedo = _myColor.rgb;
            }
        ENDCG
    }
    FallBack "Diffuse"
}
