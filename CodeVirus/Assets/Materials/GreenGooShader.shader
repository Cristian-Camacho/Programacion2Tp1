// Upgrade NOTE: replaced 'UNITY_INSTANCE_ID' with 'UNITY_VERTEX_INPUT_INSTANCE_ID'

// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Green Goo Shader"
{
	Properties
	{
		[HideInInspector] __dirty( "", Int ) = 1
		_MaskClipValue( "Mask Clip Value", Float ) = 0.5
		_Normal("Normal", 2D) = "white" {}
		_Smoothness("Smoothness", Range( 0 , 1)) = 0
		_Metalic("Metalic", Range( 0 , 1)) = 0
		_Matcap("Matcap", 2D) = "white" {}
		_DissolveTexture("Dissolve Texture", 2D) = "white" {}
		_Dissolve("Dissolve", Range( 0 , 3)) = 0.1773347
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
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

		uniform sampler2D _Normal;
		uniform float4 _Normal_ST;
		uniform sampler2D _Matcap;
		uniform float _Metalic;
		uniform float _Smoothness;
		uniform sampler2D _DissolveTexture;
		uniform float4 _DissolveTexture_ST;
		uniform float _Dissolve;
		uniform float _MaskClipValue = 0.5;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Normal = i.uv_texcoord * _Normal_ST.xy + _Normal_ST.zw;
			o.Normal = tex2D( _Normal,uv_Normal);
			float3 temp_cast_1 = 0.5;
			o.Emission = tex2D( _Matcap,( ( mul( UNITY_MATRIX_V , float4( WorldNormalVector( i, float3(0,0,1) ) , 0.0 ) ) * 0.5 ) + temp_cast_1 ).xy).xyz;
			o.Metallic = _Metalic;
			o.Smoothness = _Smoothness;
			float2 uv_DissolveTexture = i.uv_texcoord * _DissolveTexture_ST.xy + _DissolveTexture_ST.zw;
			o.Alpha = ( 1.0 - ( tex2D( _DissolveTexture,uv_DissolveTexture).r * _Dissolve ) );
			clip( ( 1.0 - ( tex2D( _DissolveTexture,uv_DissolveTexture).r * _Dissolve ) ) - _MaskClipValue );
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha 

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
				half alphaRef = tex3D( _DitherMaskLOD, float3( vpos.xy * 0.25, o.Alpha * 0.9375 ) ).a;
				clip( alphaRef - 0.01 );
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
493;85;1266;988;1726.395;633.3051;1.972063;True;True
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;6;Float;ASEMaterialInspector;Standard;Green Goo Shader;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;0;False;0;0;Custom;0.5;True;True;0;True;Transparent;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;False;0;255;255;0;0;0;0;False;0;4;10;25;False;0.5;True;0;Zero;Zero;0;Zero;Zero;Add;Add;0;False;0;0,0,0,0;VertexOffset;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0.0;False;4;FLOAT;0.0;False;5;FLOAT;0.0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0.0;False;9;FLOAT;0.0;False;10;OBJECT;0.0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;13;OBJECT;0.0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False
Node;AmplifyShaderEditor.RangedFloatNode;4;-759.3029,162.9236;Float;False;Property;_Smoothness;Smoothness;2;0;0;0;1
Node;AmplifyShaderEditor.RangedFloatNode;3;-759.3021,76.22369;Float;False;Property;_Metalic;Metalic;2;0;0;0;1
Node;AmplifyShaderEditor.SamplerNode;2;-758.5022,-241.7186;Float;True;Property;_Normal;Normal;1;0;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;16;-1608.444,-32.84188;Float;False;0;FLOAT3;0.0;False;1;FLOAT;0.0,0,0;False
Node;AmplifyShaderEditor.SimpleAddOpNode;17;-1406.842,-32.8419;Float;False;0;FLOAT3;0.0;False;1;FLOAT;0.0;False
Node;AmplifyShaderEditor.ViewMatrixNode;12;-1995.843,-108.2419;Float;False
Node;AmplifyShaderEditor.WorldNormalVector;13;-1992.044,-20.24193;Float;False;0;FLOAT3;0,0,0;False
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;-1779.245,-108.4419;Float;False;0;FLOAT4x4;0,0,0;False;1;FLOAT3;0.0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;False
Node;AmplifyShaderEditor.RangedFloatNode;15;-1794.645,90.35809;Float;False;Constant;_Float0;Float 0;7;0;0.5;0;0
Node;AmplifyShaderEditor.SamplerNode;18;-1247.242,-28.64189;Float;True;Property;_Matcap;Matcap;7;0;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;27;-426.8321,270.5596;Float;False;0;FLOAT;0.0;False;1;FLOAT;0.0,0,0,0;False
Node;AmplifyShaderEditor.OneMinusNode;28;-286.2319,271.7592;Float;True;0;FLOAT;0.0;False
Node;AmplifyShaderEditor.SamplerNode;25;-1171.431,242.3596;Float;True;Property;_DissolveTexture;Dissolve Texture;8;0;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False
Node;AmplifyShaderEditor.RangedFloatNode;30;-1027.722,5.526703;Float;False;Constant;_Float1;Float 1;10;0;0;0;0
Node;AmplifyShaderEditor.RangedFloatNode;31;-839.4224,392.3268;Float;False;Property;_Dissolve;Dissolve;10;0;0.1773347;0;3
WireConnection;0;1;2;0
WireConnection;0;2;18;0
WireConnection;0;3;3;0
WireConnection;0;4;4;0
WireConnection;0;9;28;0
WireConnection;0;10;28;0
WireConnection;16;0;14;0
WireConnection;16;1;15;0
WireConnection;17;0;16;0
WireConnection;17;1;15;0
WireConnection;14;0;12;0
WireConnection;14;1;13;0
WireConnection;18;1;17;0
WireConnection;27;0;25;1
WireConnection;27;1;31;0
WireConnection;28;0;27;0
ASEEND*/
//CHKSM=C4FB197C411F7F5BA2CAE23F04A4A01737DE353E