using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;

[ExecuteInEditMode]
public class CullingScript : MonoBehaviour
{
	#region Variables

	// Private Instance Variables
	private int cullModePropertyID = 0;
	private Material material = null;
	private CullMode cullMode = CullMode.Off;

	// Consts
	private const string CULLING_SHADER_PROPERTY_NAME = "_CullMode";

	#endregion

	#region MonoBehaviour

	private void OnGUI()
	{
		if (material == null)
		{
			Renderer r = GetComponent<Renderer>();
			if (r)
			{
				material = r.sharedMaterial;
				cullModePropertyID = Shader.PropertyToID(CULLING_SHADER_PROPERTY_NAME);
			}
			else
			{
				return;
			}
		}

		if (GUI.Button(
			new Rect(5f, 5f, 300f, 40f),
			"Culling Mode: " + cullMode.ToString())
		)
		{
			cullMode = (CullMode)(((int)cullMode + 1) % Enum.GetValues(typeof(CullMode)).Length);
			material.SetInt(cullModePropertyID, (int) cullMode);
		}
	}

	#endregion
}
