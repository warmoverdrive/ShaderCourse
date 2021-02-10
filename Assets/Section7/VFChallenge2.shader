Shader "Holistic/VF/Challenge2"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        // diffuse pass
        Pass
        {
            Tags { "LightMode" = "ForwardBase" }

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_fwdbase nolightmap nodirlightmap nodynlightmap novertexlight
            #include "UnityCG.cginc"
            #include "UnityLightingCommon.cginc"
            #include "Lighting.cginc"
            #include "AutoLight.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float4 texcoord : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                fixed4 diff : COLOR0;
                // name of pos is required for shadows on model
                float4 pos : SV_POSITION;
                SHADOW_COORDS(1)
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = v.texcoord;
                // calc world normal based on vertex (local) normal
                half3 worldNormal = UnityObjectToWorldNormal(v.normal);
                // calc dot product of the world normal and light pos
                half nl = max(0, dot(worldNormal, _WorldSpaceLightPos0.xyz));
                // multiply normal by light color
                o.diff = nl * _LightColor0;

                TRANSFER_SHADOW(o)

                return o;
            }

            sampler2D _MainTex;

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                fixed shadow = SHADOW_ATTENUATION(i);

                // if the shadow value is 0 it is black, so if the value is below
                // a threshold, in this case 0.2, add red to the color, else nothing.
                // There is a harsh fringing effect around the shadows, probably caused
                // by the cut-off at 0.2 darkness. Subjectively worse looking than my
                // solution, which is smoother.
                
                // col.rgb *= i.diff * shadow + (shadow < 0.2 ? float3(1,0,0) : 0);


                // my solution, similar idea but less efficient maybe?
                // not sure if splitting calculations done over a fixed array
                // into two or more lines would be optimized at compile time
                // the result is the shadow multiplier ignoring the red channel
                // which has a softer (light source dependant) edge
                
                col.gb *= i.diff * shadow;
                col.r *= i.diff;

                return col; 
            }
            ENDCG
        }
        // shadowpass
        Pass
        {
            Tags { "LightMode" = "ShadowCaster" }

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_shadowcaster
            #include "UnityCG.cginc"

            struct appdata {
                float4 vertex   : POSITION;
                float3 normal   : NORMAL;
                float4 texcoord : TEXCOORD0;
            };

            struct v2f {
                V2F_SHADOW_CASTER;
            };

            v2f vert(appdata v)
            {
                v2f o;
                TRANSFER_SHADOW_CASTER_NORMALOFFSET(o)
                return o;
            }

            float4 frag(v2f i) : SV_Target
            {
                SHADOW_CASTER_FRAGMENT(i);
            }
            ENDCG
        }
    }
}
