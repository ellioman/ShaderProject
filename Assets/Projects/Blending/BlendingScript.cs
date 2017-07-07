using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;

public class BlendingScript : MonoBehaviour
{
	#region Variables

	// Private Instance Variables
	private int sourceBlendModePropertyID = 0;
	private int destinationBlendModePropertyID = 0;
	private Material material = null;
	private BlendMode sourceBlendMode = BlendMode.SrcAlpha;
	private BlendMode destinationBlendMode = BlendMode.OneMinusSrcAlpha;

	// Consts
	private const string SOURCE_BLEND_SHADER_PROPERTY_NAME = "_SourceBlendMode";
	private const string DESTINATION_BLEND_SHADER_PROPERTY_NAME = "_DestinationBlendMode";

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

				sourceBlendModePropertyID = Shader.PropertyToID(SOURCE_BLEND_SHADER_PROPERTY_NAME);
				destinationBlendModePropertyID = Shader.PropertyToID(DESTINATION_BLEND_SHADER_PROPERTY_NAME);

				sourceBlendMode = (BlendMode) material.GetInt(sourceBlendModePropertyID);
				destinationBlendMode = (BlendMode) material.GetInt(destinationBlendModePropertyID);
			}
			else
			{
				return;
			}
		}

		if (GUI.Button(
			new Rect(5f, 5f, 300f, 40f),
			"Source Blend Mode: " + sourceBlendMode.ToString())
		)
		{
			sourceBlendMode = (BlendMode)(((int)sourceBlendMode + 1) % Enum.GetValues(typeof(BlendMode)).Length);
			material.SetInt(sourceBlendModePropertyID, (int) sourceBlendMode);
		}

		if (GUI.Button(
			new Rect(5f, 50f, 300f, 40f),
			"Destination Blend Mode: " + destinationBlendMode.ToString())
		)
		{
			destinationBlendMode = (BlendMode)(((int)destinationBlendMode + 1) % Enum.GetValues(typeof(BlendMode)).Length);
			material.SetInt(destinationBlendModePropertyID, (int) destinationBlendMode);
		}
	}

	#endregion
}
