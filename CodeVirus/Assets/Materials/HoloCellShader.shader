// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Holo Cell Shader"
{
	Properties
	{
		[HideInInspector] __dirty( "", Int ) = 1
		_MaskClipValue( "Mask Clip Value", Float ) = 0.5
		_ColorBad("Color Bad", Color) = (0.7981448,0.4890246,0.9926471,0)
		_Opacity("Opacity", 2D) = "white" {}
		_ColorChange("Color Change", Range( 0 , 1)) = 0
		_Colorgood("Color good", Color) = (0,0,0,0)
		_Emission("Emission", Range( 0 , 3)) = 0
		_DisolveNoise("Disolve Noise", 2D) = "white" {}
		_DisolveValue("Disolve Value", Range( 0 , 3)) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Standard keepalpha  
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float4 _ColorBad;
		uniform float4 _Colorgood;
		uniform float _ColorChange;
		uniform float _Emission;
		uniform sampler2D _Opacity;
		uniform float4 _Opacity_ST;
		uniform sampler2D _DisolveNoise;
		uniform float4 _DisolveNoise_ST;
		uniform float _DisolveValue;
		uniform float _MaskClipValue = 0.5;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float4 temp_output_21_0 = lerp( _ColorBad , _Colorgood , _ColorChange );
			o.Albedo = temp_output_21_0.rgb;
			float4 temp_output_31_0 = ( temp_output_21_0 * _Emission );
			o.Emission = temp_output_31_0.rgb;
			o.Alpha = temp_output_31_0.r;
			float2 uv_Opacity = i.uv_texcoord * _Opacity_ST.xy + _Opacity_ST.zw;
			float2 uv_DisolveNoise = i.uv_texcoord * _DisolveNoise_ST.xy + _DisolveNoise_ST.zw;
			clip( ( tex2D( _Opacity,uv_Opacity).r * ( 1.0 - ( tex2D( _DisolveNoise,uv_DisolveNoise).r * _DisolveValue ) ) ) - _MaskClipValue );
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=5105
315;48;1266;988;1699.638;614.6547;2;True;True
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;2;Float;ASEMaterialInspector;Standard;Holo Cell Shader;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;0;False;0;0;Custom;0.5;True;False;0;True;Transparent;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;False;0;255;255;0;0;0;0;False;0;4;10;25;False;0.5;True;0;SrcAlpha;OneMinusSrcAlpha;0;Zero;Zero;Add;Add;0;False;0;0,0,0,0;VertexOffset;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0.0;False;4;FLOAT;0.0;False;5;FLOAT;0.0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0.0;False;9;FLOAT;0.0;False;10;OBJECT;0.0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;13;OBJECT;0.0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False
Node;AmplifyShaderEditor.LerpOp;21;-393.8407,-324.4719;Float;True;0;COLOR;0.0;False;1;COLOR;0.0;False;2;FLOAT;0.0;False
Node;AmplifyShaderEditor.ColorNode;2;-871.8885,-392.3307;Float;False;Property;_ColorBad;Color Bad;1;0;0.7981448,0.4890246,0.9926471,0
Node;AmplifyShaderEditor.RangedFloatNode;22;-865.8459,-13.80364;Float;False;Property;_ColorChange;Color Change;6;0;0;0;1
Node;AmplifyShaderEditor.ColorNode;20;-870.2724,-213.8155;Float;False;Property;_Colorgood;Color good;6;0;0,0,0,0
Node;AmplifyShaderEditor.SamplerNode;9;-859.5034,375.667;Float;True;Property;_Opacity;Opacity;3;0;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False
Node;AmplifyShaderEditor.SamplerNode;26;-1094.938,601.3445;Float;True;Property;_DisolveNoise;Disolve Noise;7;0;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False
Node;AmplifyShaderEditor.RangedFloatNode;27;-1093.34,820.5432;Float;False;Property;_DisolveValue;Disolve Value;8;0;1;0;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;28;-771.7391,628.743;Float;True;0;FLOAT;0.0;False;1;FLOAT;0.0;False
Node;AmplifyShaderEditor.OneMinusNode;30;-558.5366,628.3424;Float;True;0;FLOAT;0.0;False
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;29;-353.9362,402.3435;Float;True;0;FLOAT;0.0;False;1;FLOAT;0.0;False
Node;AmplifyShaderEditor.RangedFloatNode;32;-645.6379,151.3453;Float;False;Property;_Emission;Emission;6;0;0;0;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;31;-231.6379,21.34528;Float;False;0;COLOR;0.0;False;1;FLOAT;0.0;False
WireConnection;0;0;21;0
WireConnection;0;2;31;0
WireConnection;0;9;31;0
WireConnection;0;10;29;0
WireConnection;21;0;2;0
WireConnection;21;1;20;0
WireConnection;21;2;22;0
WireConnection;28;0;26;1
WireConnection;28;1;27;0
WireConnection;30;0;28;0
WireConnection;29;0;9;1
WireConnection;29;1;30;0
WireConnection;31;0;21;0
WireConnection;31;1;32;0
ASEEND*/
//CHKSM=1D4C155E645A23EDC8C63F636459135EA57B4514