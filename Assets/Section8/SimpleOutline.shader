﻿Shader "Holistic/FX/SimpleOutline"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _OutlineColor ("Outline Color", Color) = (0,0,0,1)
        _Outline ("Outline Width", Range(0.002, 0.1)) = 0.005
    }
    SubShader
    {
        Tags { "Queue" = "Transparent" }
        ZWrite off
        CGPROGRAM
            #pragma surface surf Lambert vertex:vert
            
            sampler2D _MainTex;
            float _Outline;
            float4 _OutlineColor;

            struct Input {
                float2 uv_MainTex;
            };

            void vert (inout appdata_full v) {
                v.vertex.xyz += v.normal * _Outline;
            }

            void surf (Input IN, inout SurfaceOutput o) {
                o.Emission = _OutlineColor.rgb;
            }

        ENDCG

        ZWrite on
        CGPROGRAM
            #pragma surface surf Lambert
            sampler2D _MainTex;

            struct Input {
                float2 uv_MainTex;
            };

            //sampler2D _MainTex;

            void surf (Input IN, inout SurfaceOutput o) {
                o.Albedo = tex2D(_MainTex, IN.uv_MainTex).rgb;
            }
        ENDCG
    }
    FallBack "Diffuse"
}
