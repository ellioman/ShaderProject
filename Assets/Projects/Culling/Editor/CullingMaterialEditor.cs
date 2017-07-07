using UnityEngine;
using UnityEngine.Rendering;
using UnityEditor;

[ExecuteInEditMode]
public class CullingMaterialEditor : MaterialEditor
{
	#region Variables

	// Consts
	private const string CULL_MODE_EDITOR_NAME = "Cull mode:";
	private const string CULLING_SHADER_PROPERTY_NAME = "_CullMode";

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
		CullMode cullMode = (CullMode) material.GetInt(CULLING_SHADER_PROPERTY_NAME);

		// Start the check if anything has changed...
		EditorGUI.BeginChangeCheck();

		// Show the Main Texture
		TexturePropertySingleLine(new GUIContent(properties[0].displayName), properties[0]);

		EditorGUILayout.Separator();

		// Show the Culling dropdown
		cullMode = (CullMode) EditorGUILayout.EnumPopup(CULL_MODE_EDITOR_NAME, cullMode);

		// End the check if anything had changed
		if (EditorGUI.EndChangeCheck())
		{
			// Save...
			material.SetInt(CULLING_SHADER_PROPERTY_NAME, (int)cullMode);
			EditorUtility.SetDirty(material);
		}
	}

	#endregion
}
