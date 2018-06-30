// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Outer Ring Shader"
{
	Properties
	{
		[HideInInspector] __dirty( "", Int ) = 1
		_AlbedoMap("Albedo Map", 2D) = "white" {}
		_EmissionMap("Emission Map", 2D) = "white" {}
		_EmissionStrenght("Emission Strenght", Range( 0 , 1)) = 0.4847849
		_EmissionColor("Emission Color", Color) = (0.9779412,0.1294334,0.1294334,0)
		_Smoothness("Smoothness", Range( 0 , 1)) = 0
		_Metalic("Metalic", Range( 0 , 1)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _AlbedoMap;
		uniform float4 _AlbedoMap_ST;
		uniform sampler2D _EmissionMap;
		uniform float4 _EmissionMap_ST;
		uniform float4 _EmissionColor;
		uniform float _EmissionStrenght;
		uniform float _Metalic;
		uniform float _Smoothness;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_AlbedoMap = i.uv_texcoord * _AlbedoMap_ST.xy + _AlbedoMap_ST.zw;
			o.Albedo = tex2D( _AlbedoMap,uv_AlbedoMap).xyz;
			float2 uv_EmissionMap = i.uv_texcoord * _EmissionMap_ST.xy + _EmissionMap_ST.zw;
			o.Emission = ( ( ( ( 1.0 - tex2D( _EmissionMap,uv_EmissionMap).b ) * (0.0 + (_SinTime.w - -1.0) * (1.0 - 0.0) / (1.0 - -1.0)) ) * _EmissionColor ) * _EmissionStrenght ).rgb;
			o.Metallic = _Metalic;
			o.Smoothness = _Smoothness;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=5105
-1273;85;1266;988;1309.299;376.1001;1.6;True;True
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;2;Float;ASEMaterialInspector;Standard;Outer Ring Shader;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;0;False;0;0;Opaque;0.5;True;True;0;False;Opaque;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;False;0;255;255;0;0;0;0;False;0;4;10;25;False;0.5;True;0;Zero;Zero;0;Zero;Zero;Add;Add;0;False;0;0,0,0,0;VertexOffset;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0.0;False;4;FLOAT;0.0;False;5;FLOAT;0.0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0.0;False;9;FLOAT;0.0;False;10;OBJECT;0.0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;13;OBJECT;0.0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;10;-725.3051,50.49963;Float;True;0;FLOAT;0.0;False;1;FLOAT;0.0;False
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;4;-484.3989,49.59997;Float;True;0;FLOAT;0.0;False;1;COLOR;0.0;False
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;-222.7021,48.09965;Float;True;0;COLOR;0.0;False;1;FLOAT;0.0,0,0,0;False
Node;AmplifyShaderEditor.RangedFloatNode;12;-497.1019,322.499;Float;False;Property;_EmissionStrenght;Emission Strenght;2;0;0.4847849;0;1
Node;AmplifyShaderEditor.SamplerNode;1;-571.6,-166.2005;Float;True;Property;_AlbedoMap;Albedo Map;0;0;Assets/Img/cboard_black.jpg;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False
Node;AmplifyShaderEditor.RangedFloatNode;6;-1258.802,210.0006;Float;False;Constant;_Float0;Float 0;2;0;-1;0;0
Node;AmplifyShaderEditor.SinTimeNode;5;-1254.802,32.99976;Float;False
Node;AmplifyShaderEditor.RangedFloatNode;7;-1253.802,291.0011;Float;False;Constant;_Float2;Float 2;2;0;0;0;0
Node;AmplifyShaderEditor.RangedFloatNode;8;-1253.802,373.0013;Float;False;Constant;_Float4;Float 4;2;0;1;0;0
Node;AmplifyShaderEditor.TFHCRemap;9;-1061.202,227.0007;Float;False;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;1.0;False;3;FLOAT;0.0;False;4;FLOAT;1.0;False
Node;AmplifyShaderEditor.SamplerNode;2;-1248.201,-200.1001;Float;True;Property;_EmissionMap;Emission Map;1;0;Assets/Img/cboard_black.jpg;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False
Node;AmplifyShaderEditor.OneMinusNode;13;-926.6964,-198.0008;Float;True;0;FLOAT;0.0;False
Node;AmplifyShaderEditor.RangedFloatNode;15;-498.0998,507.101;Float;False;Property;_Smoothness;Smoothness;4;0;0;0;1
Node;AmplifyShaderEditor.ColorNode;3;-760.401,280.2021;Float;False;Property;_EmissionColor;Emission Color;2;0;0.9779412,0.1294334,0.1294334,0
Node;AmplifyShaderEditor.RangedFloatNode;14;-496.4997,417.4998;Float;False;Property;_Metalic;Metalic;4;0;0;0;1
WireConnection;0;0;1;0
WireConnection;0;2;11;0
WireConnection;0;3;14;0
WireConnection;0;4;15;0
WireConnection;10;0;13;0
WireConnection;10;1;9;0
WireConnection;4;0;10;0
WireConnection;4;1;3;0
WireConnection;11;0;4;0
WireConnection;11;1;12;0
WireConnection;9;0;5;4
WireConnection;9;1;6;0
WireConnection;9;2;8;0
WireConnection;9;3;7;0
WireConnection;9;4;8;0
WireConnection;13;0;2;3
ASEEND*/
//CHKSM=D09DBCAB0327BF520B3EC9C63B359FFEE07DF433