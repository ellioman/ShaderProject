using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LerpColor : MonoBehaviour
{
	// Unity Editor Variables
	[SerializeField] private Color from;
	[SerializeField] private Color to;
	[SerializeField] private float timeMultiplier;
	[Space(5f)]
	[SerializeField] private string shaderPropertyName;
	[SerializeField] private Material material;

	// Private Instance Variables
	private int colorID = -1;

	private void Start()
	{
		if (material == null)
		{
			enabled = false;
			return;
		}

		colorID = Shader.PropertyToID(shaderPropertyName);
	}

	// Update is called once per frame
	private void Update ()
	{
		material.SetColor(colorID, 
			Color.Lerp(
				from, 
				to, 
				Mathf.SmoothStep (0f, 1f, Mathf.PingPong(Time.realtimeSinceStartup * timeMultiplier, 1f))
			)
		);
	}
}
