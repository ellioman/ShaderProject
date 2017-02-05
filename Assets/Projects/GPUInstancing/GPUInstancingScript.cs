using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GPUInstancingScript : MonoBehaviour
{
	// Unity Editor Variables
	[SerializeField] private GameObject objPrefab;
	[SerializeField] private int numOfObjects;
	[SerializeField] private int spaceSize;

	// Private Variables
	private GameObject[] objects = null;

	// Use this for initialization
	private void Start ()
	{
		if (numOfObjects <= 0 || spaceSize <= 0f)
		{
			return;
		}

		Camera cam = FindObjectOfType<Camera>();
		if (cam)
		{
			cam.transform.position = new Vector3(spaceSize * 0.5f, 17.5f, -spaceSize * 0.5f);
		}

		objects = new GameObject[numOfObjects];
		MaterialPropertyBlock props = new MaterialPropertyBlock();
		MeshRenderer renderer;

		float x = 0f;
		float z = 0f;
		float space = 2.0f;
		for (int i = 0; i < numOfObjects; i++)
		{
			objects[i] = Instantiate(objPrefab) as GameObject;

			float r = Random.Range(0.0f, 1.0f);
			float g = Random.Range(0.0f, 1.0f);
			float b = Random.Range(0.0f, 1.0f);
			props.SetColor("_Color", new Color(r, g, b));
			renderer = objects[i].GetComponent<MeshRenderer>();
			renderer.SetPropertyBlock(props);

			x = - spaceSize * 0.5f + i % spaceSize * space;
			z = - spaceSize * 0.5f + Mathf.Floor(i / spaceSize) * space;
			objects[i].transform.position = new Vector3(x, 0f, z);
		}	
	}
}
