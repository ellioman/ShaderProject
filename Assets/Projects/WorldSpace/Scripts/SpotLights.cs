using UnityEngine;
using System.Collections;

[ExecuteInEditMode]
public class SpotLights : MonoBehaviour
{
	[System.Serializable]
	protected class SpotLight
	{
		public Transform tr;
		public float size;
	}

	[SerializeField] protected SpotLight spotlight1;
	[SerializeField] protected SpotLight spotlight2;
	[SerializeField] protected SpotLight spotlight3;
	[SerializeField] protected Material mat;


	// Update is called once per frame
	protected void Update()
	{
		if (mat)
		{
			if (spotlight1 != null)
			{
				mat.SetVector("_WorldPos1", spotlight1.tr.position);
				mat.SetFloat("_Size1", spotlight1.size);
			}

			if (spotlight2 != null)
			{
				mat.SetVector("_WorldPos2", spotlight2.tr.position);
				mat.SetFloat("_Size2", spotlight2.size);
			}

			if (spotlight3 != null)
			{
				mat.SetVector("_WorldPos3", spotlight3.tr.position);
				mat.SetFloat("_Size3", spotlight3.size);
			}
		}
	}
}
