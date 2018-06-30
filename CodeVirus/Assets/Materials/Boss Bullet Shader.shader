// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Boss Bullet Shader"
{
	Properties
	{
		[HideInInspector] __dirty( "", Int ) = 1
		_Albedo("Albedo", 2D) = "white" {}
		_Color0("Color 0", Color) = (0.9338235,0.1716587,0.1716587,0)
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 4.6
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc 
		struct Input
		{
			float2 texcoord_0;
		};

		uniform float4 _Color0;
		uniform sampler2D _Albedo;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			o.texcoord_0.xy = v.texcoord.xy * float2( 1,1 ) + float2( 0,0 );
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 temp_output_5_0 = (abs( i.texcoord_0+_Time.y * float2(1,1 )));
			float4 temp_output_7_0 = ( _Color0 * tex2D( _Albedo,temp_output_5_0) );
			o.Albedo = temp_output_7_0.xyz;
			o.Emission = temp_output_7_0.xyz;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=5105
-1273;85;1266;988;1356.2;526.4996;1.6;True;True
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;6;Float;ASEMaterialInspector;Standard;Boss Bullet Shader;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;0;False;0;0;Opaque;0.5;True;True;0;False;Opaque;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;False;0;255;255;0;0;0;0;False;0;1;10;25;False;0.5;True;0;Zero;Zero;0;Zero;Zero;Add;Add;0;False;0;0,0,0,0;VertexOffset;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0.0;False;4;FLOAT;0.0;False;5;FLOAT;0.0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0.0;False;9;FLOAT;0.0;False;10;OBJECT;0.0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;13;OBJECT;0.0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False
Node;AmplifyShaderEditor.PannerNode;5;-619.1001,-14.89972;Float;False;1;1;0;FLOAT2;0,0;False;1;FLOAT;0.0;False
Node;AmplifyShaderEditor.TextureCoordinatesNode;3;-915.1001,-12.89972;Float;False;0;-1;2;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False
Node;AmplifyShaderEditor.TimeNode;4;-913.1001,115.1003;Float;False
Node;AmplifyShaderEditor.SamplerNode;1;-403.0996,-43.30047;Float;True;Property;_Albedo;Albedo;0;0;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False
Node;AmplifyShaderEditor.SamplerNode;2;-404.2997,167.8006;Float;True;Property;_Glow;Glow;1;0;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;7;-104.7002,-121.6;Float;False;0;COLOR;0.0,0,0,0;False;1;FLOAT4;0.0,0,0,0;False
Node;AmplifyShaderEditor.ColorNode;6;-394.5006,-233.7996;Float;False;Property;_Color0;Color 0;2;0;0.9338235,0.1716587,0.1716587,0
WireConnection;0;0;7;0
WireConnection;0;2;7;0
WireConnection;5;0;3;0
WireConnection;5;1;4;2
WireConnection;1;1;5;0
WireConnection;2;1;5;0
WireConnection;7;0;6;0
WireConnection;7;1;1;0
ASEEND*/
//CHKSM=FCDC28F660122C4A0742BB995154CAE401C50376