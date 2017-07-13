using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;

public class ChangeCullingScript : MonoBehaviour
{
	// Unity Editor Variables
	[SerializeField] private float changeDelay;
	[Space(5f)]
	[SerializeField] private string shaderPropertyName = "_CullMode";
	[SerializeField] private Material material;

	// Private Instance Variables
	private int cullModeID = -1;
	private CullMode cullMode = CullMode.Back;

	private void Start()
	{
		if (material == null)
		{
			enabled = false;
			return;
		}

		cullModeID = Shader.PropertyToID(shaderPropertyName);
		StartCoroutine(ChangeCulling());
	}

	// Update is called once per frame
	private IEnumerator ChangeCulling()
	{
		UpdateCullMode();

		while (true)
		{
			yield return new WaitForSeconds(changeDelay);

			switch (cullMode)
			{
				case CullMode.Off:
					cullMode = CullMode.Front;
					break;
				case CullMode.Front:
					cullMode = CullMode.Back;
					break;
				case CullMode.Back:
					cullMode = CullMode.Off;
					break;
			}
			UpdateCullMode();
		}
	}

	private void UpdateCullMode()
	{
		material.SetInt(cullModeID, (int) cullMode);
	}

	private void OnDisable()
	{
		cullMode = CullMode.Back;
		UpdateCullMode();
	}
}
