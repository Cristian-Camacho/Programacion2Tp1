// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Item Healt Shader"
{
	Properties
	{
		[HideInInspector] __dirty( "", Int ) = 1
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
			fixed filler;
		};

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float4 _Color0 = float4(0.2527033,0.9044118,0.4190013,0);
			o.Albedo = _Color0.rgb;
			o.Emission = ( _Color0 * (0.3 + (_SinTime.w - -1.0) * (0.5 - 0.3) / (1.0 - -1.0)) ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=5105
-1273;85;1266;988;1237.2;468.6999;1.4;False;True
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;2;Float;ASEMaterialInspector;Standard;Item Healt Shader;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;0;False;0;0;Opaque;0.5;True;True;0;False;Opaque;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;False;0;255;255;0;0;0;0;False;0;4;10;25;False;0.5;True;0;Zero;Zero;0;Zero;Zero;Add;Add;0;False;0;0,0,0,0;VertexOffset;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0.0;False;4;FLOAT;0.0;False;5;FLOAT;0.0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0.0;False;9;FLOAT;0.0;False;10;OBJECT;0.0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;13;OBJECT;0.0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False
Node;AmplifyShaderEditor.ColorNode;2;-601.6013,7.10004;Float;False;Constant;_Color0;Color 0;1;0;0.2527033,0.9044118,0.4190013,0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;4;-267.0008,157.1002;Float;False;0;COLOR;0.0;False;1;FLOAT;0.0,0,0,0;False
Node;AmplifyShaderEditor.SinTimeNode;3;-714.9995,221.5002;Float;False
Node;AmplifyShaderEditor.RangedFloatNode;6;-694.0011,397.9003;Float;False;Constant;_Float0;Float 0;0;0;-1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-692.6012,476.2991;Float;False;Constant;_Float1;Float 1;0;0;0.3;0;0
Node;AmplifyShaderEditor.RangedFloatNode;8;-692.6002,554.6992;Float;False;Constant;_Float2;Float 2;0;0;1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;9;-691.2005,637.2993;Float;False;Constant;_Float3;Float 3;0;0;0.5;0;0
Node;AmplifyShaderEditor.TFHCRemap;5;-457.3998,397.9002;Float;False;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;1.0;False;3;FLOAT;0.0;False;4;FLOAT;1.0;False
WireConnection;0;0;2;0
WireConnection;0;2;4;0
WireConnection;4;0;2;0
WireConnection;4;1;5;0
WireConnection;5;0;3;4
WireConnection;5;1;6;0
WireConnection;5;2;8;0
WireConnection;5;3;7;0
WireConnection;5;4;9;0
ASEEND*/
//CHKSM=42C1A83EA5566983A4D25B965D8F6ABFEEA53AE4