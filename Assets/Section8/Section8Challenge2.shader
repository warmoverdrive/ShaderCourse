Shader "Holistic/FX/Section8Challenge2"
{
    Properties
        {
            _Tint   ("Color Tint", Color) = (1,1,1,1)
            _Speed  ("Speed", Range(1,100)) = 10
            _Scale1 ("Scale 1", Range(0.1,10)) = 2
            _Scale2 ("Scale 2", Range(0.1,10)) = 2
            _Scale3 ("Scale 3", Range(0.1,10)) = 2
            _Scale4 ("Scale 4", Range(0.1,10)) = 2
        }
    SubShader
    {
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            float4  _Tint;
            float   _Speed;
            float   _Scale1;
            float   _Scale2;
            float   _Scale3;
            float   _Scale4;

            struct appdata
            {
                float4 vertex : POSITION;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
            };

            // runs on every vertex in world space from the local origin
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                return o;
            }

            // runs on every pixel in screen space
            fixed4 frag (v2f i) : SV_Target
            {  
                const float PI = 3.14159265;
                float t = _Time.x * _Speed;

                float xPos = i.vertex.x * 0.01;
                float yPos = i.vertex.y * 0.01;

                // Vertical
                float c = sin(xPos * _Scale1 + t);

                // Horizontal
                c += sin(yPos * _Scale2 + t); 
            
                // Diagonal
                c += sin(_Scale3 * (xPos * sin(t/2.0) + yPos * cos(t/3))+t);

                // Circular
                float c1 = pow(xPos + 0.5 * sin(t/5), 2);
                float c2 = pow(yPos + 0.5 * cos(t/3), 2);
                c += sin(sqrt(_Scale4 * (c1 + c2) + 1 + t));

                fixed4 col = 0;

                col.r = sin(c / 4.0 * PI);
                col.g = sin(c / 4.0 * PI + PI/4);
                col.b = sin(c / 4.0 * PI + 1.5*PI/4);
                return col * _Tint;
            }
            ENDCG
        }
    }
}
