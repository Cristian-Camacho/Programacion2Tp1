// Upgrade NOTE: replaced 'UNITY_INSTANCE_ID' with 'UNITY_VERTEX_INPUT_INSTANCE_ID'

// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Minion 01 Shader"
{
	Properties
	{
		_MaskClipValue( "Mask Clip Value", Float ) = 0.5
		[HideInInspector] __dirty( "", Int ) = 1
		_DissolveTexture("Dissolve Texture", 2D) = "white" {}
		_DisolveValue("Disolve Value", Range( 0 , 3)) = 0
		_Emission("Emission", 2D) = "white" {}
		_MainColor("Main Color", Color) = (0.483153,0.04233348,0.6397059,0)
		_EmissionColor("Emission Color", Color) = (0.9926471,0.2262651,0.2262651,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float4 _MainColor;
		uniform sampler2D _Emission;
		uniform float4 _Emission_ST;
		uniform float4 _EmissionColor;
		uniform sampler2D _DissolveTexture;
		uniform float4 _DissolveTexture_ST;
		uniform float _DisolveValue;
		uniform float _MaskClipValue = 0.5;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			o.Albedo = _MainColor.rgb;
			float2 uv_Emission = i.uv_texcoord * _Emission_ST.xy + _Emission_ST.zw;
			o.Emission = ( ( tex2D( _Emission,uv_Emission).r * _EmissionColor ) * 1.0 ).rgb;
			float2 uv_DissolveTexture = i.uv_texcoord * _DissolveTexture_ST.xy + _DissolveTexture_ST.zw;
			float temp_output_19_0 = ( 1.0 - ( tex2D( _DissolveTexture,uv_DissolveTexture).r * _DisolveValue ) );
			o.Alpha = temp_output_19_0;
			clip( temp_output_19_0 - _MaskClipValue );
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
				float3 worldPos = IN.worldPos;
				fixed3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
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
-1273;85;1266;988;1079.501;176.9999;1.4;True;True
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;2;Float;ASEMaterialInspector;Standard;Minion 01 Shader;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;0;False;0;0;Custom;0.5;True;True;0;True;Transparent;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;False;0;255;255;0;0;0;0;False;0;4;10;25;False;0.5;True;0;Zero;Zero;0;Zero;Zero;Add;Add;0;False;0;0,0,0,0;VertexOffset;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0.0;False;4;FLOAT;0.0;False;5;FLOAT;0.0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0.0;False;9;FLOAT;0.0;False;10;OBJECT;0.0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;13;OBJECT;0.0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False
Node;AmplifyShaderEditor.SamplerNode;11;-863.2999,9.700354;Float;True;Property;_Emission;Emission;5;0;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;13;-543.6984,101.5002;Float;False;0;FLOAT;0.0;False;1;COLOR;0.0;False
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;15;-237.6981,121.9002;Float;False;0;COLOR;0,0,0,0;False;1;FLOAT;0.0,0,0,0;False
Node;AmplifyShaderEditor.ColorNode;12;-776.5986,210.3001;Float;False;Property;_EmissionColor;Emission Color;6;0;0.9926471,0.2262651,0.2262651,0
Node;AmplifyShaderEditor.ColorNode;9;-473.9991,-100.7997;Float;False;Property;_MainColor;Main Color;5;0;0.483153,0.04233348,0.6397059,0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;-463.1003,405.2012;Float;True;0;FLOAT;0.0;False;1;FLOAT;0.0,0,0,0;False
Node;AmplifyShaderEditor.OneMinusNode;19;-250.3001,406.6014;Float;False;0;FLOAT;0.0;False
Node;AmplifyShaderEditor.RangedFloatNode;17;-822.9022,613.8009;Float;False;Property;_DisolveValue;Disolve Value;5;0;0;0;3
Node;AmplifyShaderEditor.SamplerNode;16;-824.3025,405.2013;Float;True;Property;_DissolveTexture;Dissolve Texture;4;0;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False
Node;AmplifyShaderEditor.RangedFloatNode;14;-531.7987,273.2003;Float;False;Constant;_EmissionPower;Emission Power;6;0;1;0;1
WireConnection;0;0;9;0
WireConnection;0;2;15;0
WireConnection;0;9;19;0
WireConnection;0;10;19;0
WireConnection;13;0;11;1
WireConnection;13;1;12;0
WireConnection;15;0;13;0
WireConnection;15;1;14;0
WireConnection;18;0;16;1
WireConnection;18;1;17;0
WireConnection;19;0;18;0
ASEEND*/
//CHKSM=65FF999DDABBEAE08A692BAC599B832AC869D111