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
		_Emission("Emission", Range( 0 , 1)) = 0
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
		uniform float _MaskClipValue = 0.5;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float4 temp_output_21_0 = lerp( _ColorBad , _Colorgood , _ColorChange );
			o.Albedo = temp_output_21_0.rgb;
			o.Emission = ( temp_output_21_0 * _Emission ).rgb;
			float temp_output_23_0 = _Emission;
			o.Alpha = temp_output_23_0;
			float2 uv_Opacity = i.uv_texcoord * _Opacity_ST.xy + _Opacity_ST.zw;
			clip( tex2D( _Opacity,uv_Opacity).r - _MaskClipValue );
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=5105
-1217;136;1266;988;1681.738;575.4569;1.9;False;True
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;2;Float;ASEMaterialInspector;Standard;Holo Cell Shader;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;0;False;0;0;Custom;0.5;True;False;0;True;Transparent;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;False;0;255;255;0;0;0;0;False;0;4;10;25;False;0.5;True;0;SrcAlpha;OneMinusSrcAlpha;0;Zero;Zero;Add;Add;0;False;0;0,0,0,0;VertexOffset;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0.0;False;4;FLOAT;0.0;False;5;FLOAT;0.0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0.0;False;9;FLOAT;0.0;False;10;OBJECT;0.0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;13;OBJECT;0.0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False
Node;AmplifyShaderEditor.LerpOp;21;-393.8407,-324.4719;Float;False;0;COLOR;0.0;False;1;COLOR;0.0;False;2;FLOAT;0.0;False
Node;AmplifyShaderEditor.ColorNode;2;-871.8885,-392.3307;Float;False;Property;_ColorBad;Color Bad;1;0;0.7981448,0.4890246,0.9926471,0
Node;AmplifyShaderEditor.RangedFloatNode;22;-865.8459,-13.80364;Float;False;Property;_ColorChange;Color Change;6;0;0;0;1
Node;AmplifyShaderEditor.ColorNode;20;-870.2724,-213.8155;Float;False;Property;_Colorgood;Color good;6;0;0,0,0,0
Node;AmplifyShaderEditor.RangedFloatNode;23;-859.0206,263.151;Float;False;Property;_Emission;Emission;6;0;0;0;1
Node;AmplifyShaderEditor.SinTimeNode;25;-863.9296,61.89859;Float;False
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;24;-201.92,47.05091;Float;False;0;COLOR;0.0;False;1;FLOAT;0.0;False
Node;AmplifyShaderEditor.SamplerNode;9;-859.5034,375.667;Float;True;Property;_Opacity;Opacity;3;0;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False
Node;AmplifyShaderEditor.RangedFloatNode;11;-1548.17,38.61969;Float;False;Constant;_Float0;Float 0;4;0;0;0;0
Node;AmplifyShaderEditor.RangedFloatNode;12;-1546.769,117.0207;Float;False;Constant;_Float1;Float 1;4;0;1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;13;-1544.17,201.2208;Float;False;Constant;_Float2;Float 2;4;0;-1;0;0
Node;AmplifyShaderEditor.SinTimeNode;6;-1548.869,-165.8788;Float;False
Node;AmplifyShaderEditor.SamplerNode;1;-1546.069,-382.6794;Float;True;Property;_Emision;Emision;0;0;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;16;-1126.066,-378.1786;Float;False;0;FLOAT;0.0;False;1;FLOAT;0.0,0,0,0;False
Node;AmplifyShaderEditor.RangedFloatNode;14;-1544.97,442.1203;Float;False;Property;_GlowStrenght;Glow Strenght;4;0;0;0;3
Node;AmplifyShaderEditor.RangedFloatNode;17;-1542.963,283.0202;Float;False;Constant;_Float3;Float 3;5;0;0.5;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;15;-1127.97,290.1201;Float;True;0;FLOAT;0.0;False;1;FLOAT;0.0;False
Node;AmplifyShaderEditor.TFHCRemap;10;-1296.669,71.41969;Float;True;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;1.0;False;3;FLOAT;0.0;False;4;FLOAT;1.0;False
WireConnection;0;0;21;0
WireConnection;0;2;24;0
WireConnection;0;9;23;0
WireConnection;0;10;9;1
WireConnection;21;0;2;0
WireConnection;21;1;20;0
WireConnection;21;2;22;0
WireConnection;24;0;21;0
WireConnection;24;1;23;0
WireConnection;16;0;1;1
WireConnection;16;1;15;0
WireConnection;15;0;10;0
WireConnection;15;1;14;0
WireConnection;10;0;6;4
WireConnection;10;1;13;0
WireConnection;10;2;12;0
WireConnection;10;3;11;0
WireConnection;10;4;12;0
ASEEND*/
//CHKSM=49ABBF66A970D4F066B422ABEA68AEB169923FDF