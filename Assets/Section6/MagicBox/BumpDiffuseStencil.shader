Shader "Holistic/MagicBox/BumpDiffuseStencil"
{
    Properties
    {
        _myColor ("Color", Color) = (1,1,1,1)
        _myDiffuse ("Diffuse Texture", 2D) = "white" {}
        _myNormal ("Normal Texture", 2D) = "bump" {}
        _mySlider ("Normal Amount", Range(0,10)) = 1
        
                                                        _SRef ("Stencil Ref", Float)    = 1
		[Enum(UnityEngine.Rendering.CompareFunction)]	_SComp ("Stencil Comp", Float)	= 8
		[Enum(UnityEngine.Rendering.StencilOp)]			_SOp ("Stencil Op", Float)		= 2
    }
    SubShader
    {
        Stencil 
        {
			Ref [_SRef]
			Comp [_SComp]
			Pass [_SOp]
		}

        CGPROGRAM
        #pragma surface surf Lambert

        float4      _myColor;
        sampler2D   _myDiffuse;
        sampler2D   _myNormal;
        half        _mySlider;

        struct Input
        {
            float2  uv_myDiffuse;
            float2  uv_myNormal;
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
            o.Albedo = tex2D(_myDiffuse, IN.uv_myDiffuse).rgb * _myColor.rgb;
            o.Normal = UnpackNormal(tex2D(_myNormal, IN.uv_myNormal));
            o.Normal *= float3(_mySlider, _mySlider, 1);
        }
        ENDCG
    }
    FallBack "Diffuse"
}
