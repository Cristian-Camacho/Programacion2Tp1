// Upgrade NOTE: replaced 'UNITY_INSTANCE_ID' with 'UNITY_VERTEX_INPUT_INSTANCE_ID'

// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Green Goo Shader"
{
	Properties
	{
		[HideInInspector] __dirty( "", Int ) = 1
		_NoiseMap("Noise Map", 2D) = "white" {}
		_Normal("Normal", 2D) = "white" {}
		_Displacement("Displacement", Range( 0 , 1)) = 0
		_Tesselation("Tesselation", Range( 0.1 , 20)) = 0
		_Metalic("Metalic", Range( 0 , 1)) = 0
		_Smoothness("Smoothness", Range( 0 , 1)) = 0
		_Matcap("Matcap", 2D) = "white" {}
		_DistortSpeed("Distort Speed", Range( 1 , 5)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "Tessellation.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 4.6
		#ifdef UNITY_PASS_SHADOWCASTER
			#undef INTERNAL_DATA
			#undef WorldReflectionVector
			#undef WorldNormalVector
			#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
			#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
			#define WorldNormalVector(data,normal) fixed3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
		#endif
		struct Input
		{
			float2 uv_texcoord;
			float3 worldNormal;
			INTERNAL_DATA
		};

		struct appdata
		{
			float4 vertex : POSITION;
			float4 tangent : TANGENT;
			float3 normal : NORMAL;
			float4 texcoord : TEXCOORD0;
			float4 texcoord1 : TEXCOORD1;
			float4 texcoord2 : TEXCOORD2;
			float4 texcoord3 : TEXCOORD3;
			fixed4 color : COLOR;
			UNITY_VERTEX_INPUT_INSTANCE_ID
		};

		uniform sampler2D _Normal;
		uniform float4 _Normal_ST;
		uniform sampler2D _Matcap;
		uniform float _Metalic;
		uniform float _Smoothness;
		uniform sampler2D _NoiseMap;
		uniform float _DistortSpeed;
		uniform float _Displacement;
		uniform float _Tesselation;

		float4 tessFunction( appdata v0, appdata v1, appdata v2 )
		{
			float4 temp_cast_2 = _Tesselation;
			return temp_cast_2;
		}

		void vertexDataFunc( inout appdata v )
		{
			v.texcoord.xy = v.texcoord.xy * float2( 1,1 ) + float2( 0,0 );
			v.vertex.xyz += ( ( tex2Dlod( _NoiseMap,float4( (abs( v.texcoord.xy+( _Time * _DistortSpeed ).x * float2(1,1 ))), 0.0 , 0.0 )).r * v.normal ) * _Displacement );
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Normal = i.uv_texcoord * _Normal_ST.xy + _Normal_ST.zw;
			o.Normal = tex2D( _Normal,uv_Normal);
			float3 temp_cast_1 = 0.5;
			o.Emission = tex2D( _Matcap,( ( mul( UNITY_MATRIX_V , float4( WorldNormalVector( i, float3(0,0,1) ) , 0.0 ) ) * 0.5 ) + temp_cast_1 ).xy).xyz;
			o.Metallic = _Metalic;
			o.Smoothness = _Smoothness;
			o.Alpha = 1;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha vertex:vertexDataFunc tessellate:tessFunction nolightmap 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_instancing
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			# include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES3 )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			sampler3D _DitherMaskLOD;
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float3 worldPos : TEXCOORD6;
				float4 tSpace0 : TEXCOORD1;
				float4 tSpace1 : TEXCOORD2;
				float4 tSpace2 : TEXCOORD3;
				float4 texcoords01 : TEXCOORD4;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				vertexDataFunc( v );
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				fixed3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				fixed tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				fixed3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.texcoords01 = float4( v.texcoord.xy, v.texcoord1.xy );
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			fixed4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.texcoords01.xy;
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				fixed3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=5105
-1292;95;1266;988;2323.032;130.9426;1.6;True;True
Node;AmplifyShaderEditor.CommentaryNode;11;-764.709,258.0453;Float;False;604.1625;566.9166;Heightmap Distortion;6;9;10;6;5;8;7;
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;6;Float;ASEMaterialInspector;Standard;Green Goo Shader;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;0;False;0;0;Opaque;0.5;True;True;0;False;Opaque;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;False;0;255;255;0;0;0;0;True;0;4;10;25;False;0.5;True;0;Zero;Zero;0;Zero;Zero;Add;Add;0;False;0;0,0,0,0;VertexOffset;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0.0;False;4;FLOAT;0.0;False;5;FLOAT;0.0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0.0;False;9;FLOAT;0.0;False;10;OBJECT;0.0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;13;OBJECT;0.0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False
Node;AmplifyShaderEditor.NormalVertexDataNode;8;-600.7526,499.7882;Float;False
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;10;-307.1526,571.1329;Float;False;0;FLOAT3;0.0;False;1;FLOAT;0.0,0,0;False
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;-405.2532,448.7894;Float;False;0;FLOAT;0.0;False;1;FLOAT3;0.0;False
Node;AmplifyShaderEditor.RangedFloatNode;5;-735.3537,662.9862;Float;False;Property;_Displacement;Displacement;2;0;0;0;1
Node;AmplifyShaderEditor.RangedFloatNode;4;-759.3029,162.9236;Float;False;Property;_Smoothness;Smoothness;2;0;0;0;1
Node;AmplifyShaderEditor.RangedFloatNode;3;-759.3021,76.22369;Float;False;Property;_Metalic;Metalic;2;0;0;0;1
Node;AmplifyShaderEditor.SamplerNode;1;-759.8522,-433.9191;Float;True;Property;_Albedo;Albedo;0;0;Assets/Img/green goo.jpg;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False
Node;AmplifyShaderEditor.SamplerNode;2;-758.5022,-241.7186;Float;True;Property;_Normal;Normal;1;0;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False
Node;AmplifyShaderEditor.SamplerNode;7;-746.9532,300.887;Float;True;Property;_NoiseMap;Noise Map;1;0;Assets/Img/noise_simplex.png;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False
Node;AmplifyShaderEditor.RangedFloatNode;6;-441.3024,738.8861;Float;False;Property;_Tesselation;Tesselation;2;0;0;0.1;20
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;16;-1608.444,-32.84188;Float;False;0;FLOAT3;0.0;False;1;FLOAT;0.0,0,0;False
Node;AmplifyShaderEditor.SimpleAddOpNode;17;-1406.842,-32.8419;Float;False;0;FLOAT3;0.0;False;1;FLOAT;0.0;False
Node;AmplifyShaderEditor.ViewMatrixNode;12;-1995.843,-108.2419;Float;False
Node;AmplifyShaderEditor.WorldNormalVector;13;-1992.044,-20.24193;Float;False;0;FLOAT3;0,0,0;False
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;-1779.245,-108.4419;Float;False;0;FLOAT4x4;0,0,0;False;1;FLOAT3;0.0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;False
Node;AmplifyShaderEditor.RangedFloatNode;15;-1794.645,90.35809;Float;False;Constant;_Float0;Float 0;7;0;0.5;0;0
Node;AmplifyShaderEditor.SamplerNode;18;-1247.242,-28.64189;Float;True;Property;_Matcap;Matcap;7;0;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False
Node;AmplifyShaderEditor.TextureCoordinatesNode;22;-1743.533,342.0573;Float;False;0;-1;2;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False
Node;AmplifyShaderEditor.TimeNode;21;-1723.039,506.4576;Float;False
Node;AmplifyShaderEditor.PannerNode;19;-1218.738,469.7581;Float;True;1;1;0;FLOAT2;0,0;False;1;FLOAT;0.0;False
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;23;-1426.033,508.6573;Float;False;0;FLOAT4;0.0;False;1;FLOAT;0.0;False
Node;AmplifyShaderEditor.RangedFloatNode;24;-1722.033,675.6573;Float;False;Property;_DistortSpeed;Distort Speed;8;0;0;1;5
WireConnection;0;1;2;0
WireConnection;0;2;18;0
WireConnection;0;3;3;0
WireConnection;0;4;4;0
WireConnection;0;11;10;0
WireConnection;0;14;6;0
WireConnection;10;0;9;0
WireConnection;10;1;5;0
WireConnection;9;0;7;1
WireConnection;9;1;8;0
WireConnection;7;1;19;0
WireConnection;16;0;14;0
WireConnection;16;1;15;0
WireConnection;17;0;16;0
WireConnection;17;1;15;0
WireConnection;14;0;12;0
WireConnection;14;1;13;0
WireConnection;18;1;17;0
WireConnection;19;0;22;0
WireConnection;19;1;23;0
WireConnection;23;0;21;0
WireConnection;23;1;24;0
ASEEND*/
//CHKSM=B4B1EC52BBB5C4031C3AC409EA553BDE61885629