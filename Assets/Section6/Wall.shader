Shader "Holistic/Wall" 
{
	Properties {
		_MainTex ("Diffuse", 2D) = "white" {}
	}
	SubShader {
		Tags {"Queue" = "Geometry"}

		Stencil {
			Ref 1
			Comp notequal
			Pass keep
		}

		CGPROGRAM
			#pragma surface surf Lambert

			sampler2D _MainTex;

			struct Input {
				float2 uv_MainTex;
			};

			void surf(Input IN, inout SurfaceOutput o) {
				fixed4 a = tex2D(_MainTex, IN.uv_MainTex);
				o.Albedo = a.rgb;
			}
			ENDCG
	}
	FallBack "Diffuse"
}