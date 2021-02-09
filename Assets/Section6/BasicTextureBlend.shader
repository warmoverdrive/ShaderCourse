Shader "Holistic/BasicTextureBlend" 
{
	Properties {
		_MainTex ("Texture", 2D) = "white" {}
		_Decal ("Decal", 2D) = "white" {}
		[Toggle] _ShowDecal("Show Decal?", Float) = 0
	}
	SubShader {
		Tags {"Queue" = "Geometry"}

		CGPROGRAM
			#pragma surface surf Lambert

			sampler2D _MainTex;
			sampler2D _Decal;
			float _ShowDecal;

			struct Input {
				float2 uv_MainTex;
			};

			void surf(Input IN, inout SurfaceOutput o) {
				fixed4 a = tex2D(_MainTex, IN.uv_MainTex);
				fixed4 b = tex2D(_Decal, IN.uv_MainTex) * _ShowDecal;
				o.Albedo = b.r > 0.9 ? b.rgb : a.rgb;
			}
			ENDCG
	}
	FallBack "Diffuse"
}