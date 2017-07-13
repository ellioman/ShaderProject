using UnityEngine;
using UnityEngine.Rendering;
using UnityEditor;

[ExecuteInEditMode]
public class BasicShaderMaterialEditor : MaterialEditor
{
	#region Variables

	private class ShaderProperties
	{
		// Shader Properties Names
		public const string MAIN_TEXTURE = "_MainTex";
		public const string COLOR = "_Color";
		public const string SOURCE_COLOR_BLEND_MODE = "_BlendModeSourceColor";
		public const string DESTINATION_COLOR_BLEND_MODE = "_BlendModeDestinationColor";
		public const string SOURCE_ALPHA_BLEND_MODE = "_BlendModeSourceAlpha";
		public const string DESTINATION_ALPHA_BLEND_MODE = "_BlendModeDestinationAlpha";
		public const string CULL_MODE = "_CullMode";
		public const string Z_WRITE_MODE = "_ZWriteMode";
		public const string Z_TEST_MODE = "_ZTestMode";
		public const string DEPTH_OFFSET_FACTOR = "_DepthOffsetFactor";
		public const string DEPTH_OFFSET_UNITS = "_DepthOffsetUnits";
		public const string BLEND_OP_COLOR = "_BlendOpColor";
		public const string BLEND_OP_ALPHA = "_BlendOpAlpha";

		// Shader Property IDs
		public int mainTextureID = -1;
		public int colorID = -1;
		public int sourceColorBlendModeID = -1;
		public int destinationColorBlendModeID = -1;
		public int sourceAlphaBlendModeID = -1;
		public int destinationAlphaBlendModeID = -1;
		public int cullModeID = -1;
		public int zWriteModeID = -1;
		public int zTestModeID = -1;
		public int depthOffsetFactorID = -1;
		public int depthOffsetUnitsID = -1;
		public int blendOpColorID = -1;
		public int blendOpAlphaID = -1;

		// Descriptions for the OnGUI buttons
		public const string MAIN_TEXTURE_DESCRIPTION = "Main Texture";
		public const string COLOR_DESCRIPTION = "Color";
		public const string SOURCE_COLOR_BLEND_MODE_DESCRIPTION = "Source BlendMode:";
		public const string DESTINATION_COLOR_BLEND_MODE_DESCRIPTION = "Destination BlendMode:";
		public const string SOURCE_ALPHA_BLEND_MODE_DESCRIPTION = "Source BlendMode:";
		public const string DESTINATION_ALPHA_BLEND_MODE_DESCRIPTION = "Destination BlendMode:";
		public const string CULL_MODE_DESCRIPTION = "Cull Mode: ";
		public const string Z_WRITE_MODE_DESCRIPTION = "Z Write Mode: ";
		public const string Z_TEST_MODE_DESCRIPTION = "Z Test Mode: ";
		public const string DEPTH_OFFSET_FACTOR_DESCRIPTION = "Depth Offset Factor: ";
		public const string DEPTH_OFFSET_UNITS_DESCRIPTION = "Depth Offset Units: ";
		public const string BLEND_OP_COLOR_DESCRIPTION = "BlendOp: ";
		public const string BLEND_OP_ALPHA_DESCRIPTION = "BlendOp: ";

		public override string ToString()
		{
			System.Text.StringBuilder sb = new System.Text.StringBuilder ();
			sb.AppendLine(MAIN_TEXTURE + ": " + mainTextureID);
			sb.AppendLine(COLOR + ": " + colorID);
			sb.AppendLine(SOURCE_COLOR_BLEND_MODE + ": " + sourceColorBlendModeID);
			sb.AppendLine(DESTINATION_COLOR_BLEND_MODE + ": " + destinationColorBlendModeID);
			sb.AppendLine(SOURCE_ALPHA_BLEND_MODE + ": " + sourceAlphaBlendModeID);
			sb.AppendLine(DESTINATION_ALPHA_BLEND_MODE + ": " + destinationAlphaBlendModeID);
			sb.AppendLine(CULL_MODE + ": " + cullModeID);
			sb.AppendLine(Z_WRITE_MODE + ": " + zWriteModeID);
			sb.AppendLine(Z_TEST_MODE + ": " + zTestModeID);
			sb.AppendLine(DEPTH_OFFSET_FACTOR + ": " + depthOffsetFactorID);
			sb.AppendLine(DEPTH_OFFSET_UNITS + ": " + depthOffsetUnitsID);
			sb.AppendLine(BLEND_OP_COLOR + ": " + blendOpColorID);
			sb.AppendLine(BLEND_OP_ALPHA + ": " + blendOpAlphaID);
			return sb.ToString ();
		}
	}
	ShaderProperties shaderProperties = new ShaderProperties();

	enum ZWriteMode {
		On = 0, 
		Off = 1,
	}

	enum ZTestMode
	{
		Less = 0,
		Greater = 1,
		LEqual = 2,
		GEqual = 3,
		Equal = 4,
		NotEqual = 5,
		Always = 6
	}

	private BlendMode sourceColorBlendMode;
	private BlendMode destinationColorBlendMode;
	private BlendMode sourceAlphaBlendMode;
	private BlendMode destinationAlphaBlendMode;
	private CullMode cullMode;
	private ZWriteMode zWriteMode;
	private ZTestMode zTestMode;
	private float depthOffsetFactor;
	private float depthOffsetUnits;
	private BlendOp blendOpColor;
	private BlendOp blendOpAlpha;
	private Color color;

	#endregion

	#region MonoBehaviour

	public override void OnInspectorGUI()
	{
		if (!isVisible)
		{
			return;
		}

		// Make sure we have all that we need to continue...
		Init();

		// Get the material..
		Material material = target as Material;

		// Get the current state of the variables in the Material/Shader
		GetMaterialProperties(material);

		// Expose the properties in the editor
		ExposeMaterialProperties();

		// Update the Material/Shader if needed
		UpdateMaterialProperties(material);
	}

	private void Init()
	{
		if (shaderProperties.sourceColorBlendModeID == -1)
		{
			shaderProperties.mainTextureID = Shader.PropertyToID(ShaderProperties.MAIN_TEXTURE);
			shaderProperties.colorID = Shader.PropertyToID(ShaderProperties.COLOR);
			shaderProperties.sourceColorBlendModeID = Shader.PropertyToID(ShaderProperties.SOURCE_COLOR_BLEND_MODE);
			shaderProperties.destinationColorBlendModeID = Shader.PropertyToID(ShaderProperties.DESTINATION_COLOR_BLEND_MODE);
			shaderProperties.sourceAlphaBlendModeID = Shader.PropertyToID(ShaderProperties.SOURCE_ALPHA_BLEND_MODE);
			shaderProperties.destinationAlphaBlendModeID = Shader.PropertyToID(ShaderProperties.DESTINATION_ALPHA_BLEND_MODE);
			shaderProperties.cullModeID = Shader.PropertyToID(ShaderProperties.CULL_MODE);
			shaderProperties.zWriteModeID = Shader.PropertyToID(ShaderProperties.Z_WRITE_MODE);
			shaderProperties.zTestModeID = Shader.PropertyToID(ShaderProperties.Z_TEST_MODE);
			shaderProperties.depthOffsetFactorID = Shader.PropertyToID(ShaderProperties.DEPTH_OFFSET_FACTOR);
			shaderProperties.depthOffsetUnitsID = Shader.PropertyToID(ShaderProperties.DEPTH_OFFSET_UNITS);
			shaderProperties.blendOpColorID = Shader.PropertyToID(ShaderProperties.BLEND_OP_COLOR);
			shaderProperties.blendOpAlphaID = Shader.PropertyToID(ShaderProperties.BLEND_OP_ALPHA);
			//Debug.Log (shaderProperties.ToString ());
		}
	}

	private void GetMaterialProperties(Material material)
	{
		color = material.GetColor (shaderProperties.colorID);
		sourceColorBlendMode = (BlendMode) material.GetInt(shaderProperties.sourceColorBlendModeID);
		destinationColorBlendMode = (BlendMode) material.GetInt(shaderProperties.destinationColorBlendModeID);
		sourceAlphaBlendMode = (BlendMode) material.GetInt(shaderProperties.sourceAlphaBlendModeID);
		destinationAlphaBlendMode = (BlendMode) material.GetInt(shaderProperties.destinationAlphaBlendModeID);
		cullMode = (CullMode)material.GetInt(shaderProperties.cullModeID);
		zWriteMode = (ZWriteMode)material.GetInt(shaderProperties.zWriteModeID);
		zTestMode = (ZTestMode)material.GetInt(shaderProperties.zTestModeID);
		depthOffsetFactor = material.GetFloat (shaderProperties.depthOffsetFactorID);
		depthOffsetUnits = material.GetFloat (shaderProperties.depthOffsetUnitsID);
		blendOpColor = (BlendOp)material.GetInt (shaderProperties.blendOpColorID);
		blendOpAlpha = (BlendOp)material.GetInt (shaderProperties.blendOpAlphaID);
	}

	private void ExposeMaterialProperties()
	{
		// Create a style for the titles
		GUIStyle guiStyle = new GUIStyle();
		guiStyle.fontStyle = FontStyle.Bold;
		guiStyle.normal.textColor = Color.white;

		// Start the check if anything has changed...
		EditorGUI.BeginChangeCheck();

		// Show the properties
		EditorGUILayout.LabelField ("Main texture and color", guiStyle);
		//TexturePropertySingleLine(new GUIContent(ShaderProperties.MAIN_TEXTURE_DESCRIPTION), GetMaterialProperties(targets)[0]);
		TextureProperty(GetMaterialProperties(targets)[0], ShaderProperties.MAIN_TEXTURE_DESCRIPTION);
		color = EditorGUILayout.ColorField(ShaderProperties.COLOR_DESCRIPTION, color);
		EditorGUILayout.Separator();

		EditorGUILayout.LabelField ("Color Blending", guiStyle);
		sourceColorBlendMode = (BlendMode) EditorGUILayout.EnumPopup(ShaderProperties.SOURCE_COLOR_BLEND_MODE_DESCRIPTION, sourceColorBlendMode);
		destinationColorBlendMode = (BlendMode) EditorGUILayout.EnumPopup(ShaderProperties.DESTINATION_COLOR_BLEND_MODE_DESCRIPTION, destinationColorBlendMode);
		blendOpColor = (BlendOp)EditorGUILayout.EnumPopup(ShaderProperties.BLEND_OP_COLOR_DESCRIPTION, blendOpColor);
		EditorGUILayout.Separator();

		EditorGUILayout.LabelField ("Alpha Blending", guiStyle);
		sourceAlphaBlendMode = (BlendMode) EditorGUILayout.EnumPopup(ShaderProperties.SOURCE_ALPHA_BLEND_MODE_DESCRIPTION, sourceAlphaBlendMode);
		destinationAlphaBlendMode = (BlendMode) EditorGUILayout.EnumPopup(ShaderProperties.DESTINATION_ALPHA_BLEND_MODE_DESCRIPTION, destinationAlphaBlendMode);
		blendOpAlpha = (BlendOp)EditorGUILayout.EnumPopup(ShaderProperties.BLEND_OP_ALPHA_DESCRIPTION, blendOpAlpha);
		EditorGUILayout.Separator();

		EditorGUILayout.LabelField ("Culling", guiStyle);
		cullMode = (CullMode)EditorGUILayout.EnumPopup(ShaderProperties.CULL_MODE_DESCRIPTION, cullMode);
		EditorGUILayout.Separator();

		EditorGUILayout.LabelField ("Z Write/Test/Depth", guiStyle);
		zWriteMode = (ZWriteMode)EditorGUILayout.EnumPopup(ShaderProperties.Z_WRITE_MODE_DESCRIPTION, zWriteMode);
		zTestMode = (ZTestMode)EditorGUILayout.EnumPopup(ShaderProperties.Z_TEST_MODE_DESCRIPTION, zTestMode);
		depthOffsetFactor = EditorGUILayout.FloatField(ShaderProperties.DEPTH_OFFSET_FACTOR_DESCRIPTION, depthOffsetFactor);
		depthOffsetUnits = EditorGUILayout.FloatField(ShaderProperties.DEPTH_OFFSET_UNITS_DESCRIPTION, depthOffsetUnits);
	}

	private void UpdateMaterialProperties(Material material)
	{
		// End the check if anything had changed
		if (EditorGUI.EndChangeCheck())
		{
			material.SetColor(shaderProperties.colorID, color);
			material.SetInt(shaderProperties.sourceColorBlendModeID, (int)sourceColorBlendMode);
			material.SetInt(shaderProperties.destinationColorBlendModeID, (int)destinationColorBlendMode);
			material.SetInt(shaderProperties.sourceAlphaBlendModeID, (int)sourceAlphaBlendMode);
			material.SetInt(shaderProperties.destinationAlphaBlendModeID, (int)destinationAlphaBlendMode);
			material.SetInt(shaderProperties.blendOpColorID, (int) blendOpColor);
			material.SetInt(shaderProperties.blendOpAlphaID, (int) blendOpAlpha);
			material.SetInt(shaderProperties.cullModeID, (int) cullMode);
			material.SetInt(shaderProperties.zWriteModeID, (int) zWriteMode);
			material.SetInt(shaderProperties.zTestModeID, (int) zTestMode);
			material.SetFloat(shaderProperties.depthOffsetFactorID, depthOffsetFactor);
			material.SetFloat(shaderProperties.depthOffsetUnitsID, depthOffsetUnits);

			EditorUtility.SetDirty(material);
		}
	}

	#endregion
}
