// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Target Hexagon Shader"
{
	Properties
	{
		[HideInInspector] __dirty( "", Int ) = 1
		_MaskClipValue( "Mask Clip Value", Float ) = 0.5
		_Mask("Mask", 2D) = "white" {}
		_Ramp("Ramp", 2D) = "white" {}
		_Transition("Transition", Range( 0.2 , 1)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _Ramp;
		uniform float4 _Ramp_ST;
		uniform float _Transition;
		uniform sampler2D _Mask;
		uniform float4 _Mask_ST;
		uniform float _MaskClipValue = 0.5;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Ramp = i.uv_texcoord * _Ramp_ST.xy + _Ramp_ST.zw;
			float temp_output_12_0 = ( 1.0 - ( ( tex2D( _Ramp,uv_Ramp).r * 3.273872 ) * _Transition ) );
			float4 temp_output_11_0 = ( float4(1,0.6624746,0.05882353,0) * temp_output_12_0 );
			o.Albedo = temp_output_11_0.rgb;
			o.Emission = temp_output_11_0.rgb;
			o.Alpha = 1;
			float2 uv_Mask = i.uv_texcoord * _Mask_ST.xy + _Mask_ST.zw;
			clip( ( temp_output_12_0 * tex2D( _Mask,uv_Mask).r ) - _MaskClipValue );
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=5105
-1273;85;1266;988;1369.166;75.95842;1.3;True;True
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;2;Float;ASEMaterialInspector;Standard;Target Hexagon Shader;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;0;False;0;0;Custom;0.5;True;True;0;True;Transparent;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;False;0;255;255;0;0;0;0;False;0;4;10;25;False;0.5;True;0;Zero;Zero;0;Zero;Zero;Add;Add;0;False;0;0,0,0,0;VertexOffset;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0.0;False;4;FLOAT;0.0;False;5;FLOAT;0.0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0.0;False;9;FLOAT;0.0;False;10;OBJECT;0.0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;13;OBJECT;0.0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False
Node;AmplifyShaderEditor.ColorNode;9;-604.4022,-146.3996;Float;False;Constant;_Color0;Color 0;2;0;1,0.6624746,0.05882353,0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;-237.3041,-69.69974;Float;False;0;COLOR;0.0;False;1;FLOAT;0.0,0,0,0;False
Node;AmplifyShaderEditor.OneMinusNode;12;-386.106,90.30039;Float;False;0;FLOAT;0.0;False
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;4;-481.6999,237.4007;Float;True;0;FLOAT;0.0;False;1;FLOAT;0.0;False
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;16;-237.3058,242.3;Float;True;0;FLOAT;0.0;False;1;FLOAT;0.0;False
Node;AmplifyShaderEditor.TFHCRemap;18;-921.4055,764.4001;Float;True;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;1.0;False;3;FLOAT;0.0;False;4;FLOAT;1.0;False
Node;AmplifyShaderEditor.RangedFloatNode;19;-1183.406,805.4001;Float;False;Constant;_Float2;Float 2;4;0;-1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;20;-1183.406,888.4001;Float;False;Constant;_Float3;Float 3;4;0;0;0;0
Node;AmplifyShaderEditor.RangedFloatNode;21;-1181.406,968.4001;Float;False;Constant;_Float4;Float 4;4;0;1;0;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;26;-572.1075,1196.202;Float;False;0;FLOAT;0.0;False;1;FLOAT;1.0;False;2;FLOAT;0.0;False
Node;AmplifyShaderEditor.RangedFloatNode;25;-954.5071,1321.001;Float;True;Constant;_Speed;Speed;4;0;1.682917;0;3
Node;AmplifyShaderEditor.RangedFloatNode;23;-567.3097,1018.601;Float;False;Constant;_Float5;Float 5;4;0;0;0;0
Node;AmplifyShaderEditor.SinTimeNode;22;-949.3077,1135.401;Float;False
Node;AmplifyShaderEditor.LerpOp;27;-333.7075,1021.801;Float;True;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False
Node;AmplifyShaderEditor.SinTimeNode;17;-1176.407,625.9995;Float;False
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;-675.5067,236.5005;Float;False;0;FLOAT;0.0;False;1;FLOAT;0.0;False
Node;AmplifyShaderEditor.SamplerNode;2;-1007.701,209.3;Float;True;Property;_Ramp;Ramp;0;0;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False
Node;AmplifyShaderEditor.SamplerNode;3;-504.8002,513.4004;Float;True;Property;_Mask;Mask;0;0;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False
Node;AmplifyShaderEditor.RangedFloatNode;24;-564.1094,1108.202;Float;False;Constant;_Float6;Float 6;4;0;1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;10;-814.5026,507.0989;Float;True;Property;_Transition;Transition;2;0;0;0.2;1
Node;AmplifyShaderEditor.RangedFloatNode;15;-989.5067,414.0005;Float;False;Constant;_MaskAdjust;Mask Adjust;3;0;3.273872;0;30
WireConnection;0;0;11;0
WireConnection;0;2;11;0
WireConnection;0;10;16;0
WireConnection;11;0;9;0
WireConnection;11;1;12;0
WireConnection;12;0;4;0
WireConnection;4;0;14;0
WireConnection;4;1;10;0
WireConnection;16;0;12;0
WireConnection;16;1;3;1
WireConnection;18;0;17;4
WireConnection;18;1;19;0
WireConnection;18;2;21;0
WireConnection;18;3;20;0
WireConnection;18;4;21;0
WireConnection;26;0;22;1
WireConnection;26;1;25;0
WireConnection;26;2;25;0
WireConnection;27;0;23;0
WireConnection;27;1;24;0
WireConnection;27;2;26;0
WireConnection;14;0;2;1
WireConnection;14;1;15;0
ASEEND*/
//CHKSM=70DDFB087862033D10D6E66EB53264C0A8EB787D