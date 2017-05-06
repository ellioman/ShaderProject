using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SendTimeToShader : MonoBehaviour
{
	[SerializeField] private Material[] mats;

	private void Awake()
	{
		if (mats == null || mats.Length == 0)
		{
			enabled = false;
		}
	}

	// Update is called once per frame
	private void Update ()
	{
		for (int i = 0; i < mats.Length; i++)
		{
			mats[i].SetFloat("_AnimationTime", Time.time);
		}
	}
}
