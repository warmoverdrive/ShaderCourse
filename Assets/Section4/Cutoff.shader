Shader "Holistic/Cutoff"
{
    Properties
    {
        _RimColor ("Rim Color", Color) = (0,0.5,0.5,0)
        _RimPower ("Rim Power", Range(0.5, 8.0)) = 3.0
    }
    SubShader
    {
        CGPROGRAM
        #pragma surface surf Lambert

        struct Input
        {
            float3 viewDir;
            float3 worldPos;
        };

        float4 _RimColor;
        float _RimPower;

        void surf (Input IN, inout SurfaceOutput o)
        {
            half rim = 1- saturate(dot(normalize(IN.viewDir), o.Normal));

            // harsh rim lighting 
            //o.Emission = rim > 0.5 ? float3(1,0,0) : 0;
            //o.Emission = rim > 0.5 ? float3(1,0,0) : rim > 0.3 ? float3(0,1,0) : 0;

            // colored green above world pos Y
            //o.Emission = IN.worldPos.y > 1 ?float3(0,1,0): 0;

            // striping based of world Y pos
            // using Dot product rim calc to bring back depth
            o.Emission = frac(IN.worldPos.y * 10 * 0.5) > 0.4 ?
                            float3(0,1,0)*pow(rim, _RimPower) : float3(1,0,0)*pow(rim, _RimPower);
        }
        ENDCG
    }
    FallBack "Diffuse"
}
