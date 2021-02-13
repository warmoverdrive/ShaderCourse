Shader "Holistic/Volumetrics/PrimitiveSphere"
{
    SubShader
    {
        Tags  { "Queue" = "Transparent" 
                "LightMode" = "ForwardBase" }

        Blend SrcAlpha OneMinusSrcAlpha

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            #include "UnityLightingCommon.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float3 wPos : TEXCOORD0;
                float4 pos : SV_POSITION;
            };

            v2f vert (appdata v)
            {
                v2f o;
                // clip space pos of vertex
                o.pos = UnityObjectToClipPos(v.vertex);
                // world space pos of vertex
                o.wPos = mul(unity_ObjectToWorld, v.vertex).xyz;
                return o;
            }

            #define STEPS       128
            #define STEP_SIZE   0.01

            bool SphereHit(float3 p, float3 center, float radius)
            {
                return distance(p, center) < radius;
            }

            float3 RaymarchHit(float3 position, float3 direction)
            {
                for(int i = 0; i < STEPS; i++)
                {
                    if ( SphereHit(position, float3(0,0,0), 0.5))
                        return position;

                    position += direction * STEP_SIZE;
                }
                return float3(0,0,0);
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float3 viewDirection = normalize(i.wPos - _WorldSpaceCameraPos);
                float3 worldPosition = i.wPos;
                float3 depth = RaymarchHit(worldPosition, viewDirection);

                half3 worldNormal = depth - float3(0,0,0);
                half nl = max(0, dot(worldNormal, _WorldSpaceLightPos0.xyz));

                if (length(depth) != 0) // aka if the ray hit the sphere
                {
                    depth *= nl * _LightColor0 * 2;
                    return fixed4(depth, 1) ; // make a solid pixel
                }
                else   
                    return fixed4(1,1,1,0); // make a transparent pixel
            }
            ENDCG
        }
    }
}
