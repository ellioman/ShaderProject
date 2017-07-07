using UnityEngine;
using UnityEngine.Rendering;
using UnityEditor;

[ExecuteInEditMode]
public class BlendingMaterialEditor : MaterialEditor
{
	#region Variables

	// Consts
	private const string SOURCE_BLENDING_MODE_EDITOR_NAME = "Source BlendMode:";
	private const string DESTINATION_BLENDING_MODE_EDITOR_NAME = "Destination BlendMode:";
	private const string SOURCE_BLEND_SHADER_PROPERTY_NAME = "_SourceBlendMode";
	private const string DESTINATION_BLEND_SHADER_PROPERTY_NAME = "_DestinationBlendMode";

	#endregion

	#region MonoBehaviour

	public override void OnInspectorGUI()
	{
		if (!isVisible)
		{
			return;
		}

		// Get the current state
		Material material = target as Material;
		MaterialProperty[] properties = GetMaterialProperties(targets);
		BlendMode sourceCullMode = (BlendMode) material.GetInt(SOURCE_BLEND_SHADER_PROPERTY_NAME);
		BlendMode destinationCullMode = (BlendMode) material.GetInt(DESTINATION_BLEND_SHADER_PROPERTY_NAME);

		// Start the check if anything has changed...
		EditorGUI.BeginChangeCheck();

		// Show the Main Texture
		TexturePropertySingleLine(new GUIContent(properties[0].displayName), properties[0]);

		EditorGUILayout.Separator();

		// Show the Culling dropdown
		sourceCullMode = (BlendMode) EditorGUILayout.EnumPopup(SOURCE_BLENDING_MODE_EDITOR_NAME, sourceCullMode);
		destinationCullMode = (BlendMode) EditorGUILayout.EnumPopup(DESTINATION_BLENDING_MODE_EDITOR_NAME, destinationCullMode);

		// End the check if anything had changed
		if (EditorGUI.EndChangeCheck())
		{
			// Save...
			material.SetInt(SOURCE_BLEND_SHADER_PROPERTY_NAME, (int)sourceCullMode);
			material.SetInt(DESTINATION_BLEND_SHADER_PROPERTY_NAME, (int)destinationCullMode);
			EditorUtility.SetDirty(material);
		}
	}

	#endregion
}
