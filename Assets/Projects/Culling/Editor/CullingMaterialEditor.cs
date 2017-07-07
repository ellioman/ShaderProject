using UnityEngine;
using UnityEngine.Rendering;
using UnityEditor;

[ExecuteInEditMode]
public class CullingMaterialEditor : MaterialEditor
{
	public override void OnInspectorGUI()
	{
		if (!isVisible)
		{
			return;
		}

		// Const strings
		const string CULLING_ON_EDITOR_NAME = "Culling mode:";
		const string CULLING_SHADER_PROPERTY_NAME = "_CullMode";

		// Get the current state
		Material material = target as Material;
		MaterialProperty[] properties = GetMaterialProperties(targets);
		UnityEngine.Rendering.CullMode cullMode = (UnityEngine.Rendering.CullMode) material.GetInt(CULLING_SHADER_PROPERTY_NAME);

		// Start the check if anything has changed...
		EditorGUI.BeginChangeCheck();

		// Show the Main Texture
		TexturePropertySingleLine(new GUIContent(properties[0].displayName), properties[0]);

		EditorGUILayout.Separator();

		// Show the Culling dropdown
		cullMode = (UnityEngine.Rendering.CullMode) EditorGUILayout.EnumPopup(CULLING_ON_EDITOR_NAME, cullMode);

		// End the check if anything had changed
		if (EditorGUI.EndChangeCheck())
		{
			// Save...
			material.SetInt(CULLING_SHADER_PROPERTY_NAME, (int)cullMode);
			EditorUtility.SetDirty(material);
		}
	}
}
