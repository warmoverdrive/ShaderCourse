Shader "Holistic/Transparent" 
{
	Properties {
		_MainTex ("Texture", 2D) = "black" {}
	}
	SubShader {
		Tags {"Queue" = "Transparent"}

		Blend SrcAlpha OneMinusSrcAlpha
		// turn off backside culling
		Cull Off

		Pass {
			SetTexture [_MainTex] { combine texture}
		}
	}
}