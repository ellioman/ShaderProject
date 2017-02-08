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


	private void Start()
	{
		if (numOfObjects <= 0 || spaceSize <= 0f)
		{
			return;
		}

		Camera cam = FindObjectOfType<Camera>();
		if (cam)
		{
			cam.transform.position = new Vector3(spaceSize * 0.75f, cam.transform.position.y, -spaceSize * 0.75f);
		}
		
		int numObjectsEachLine = (int) Mathf.Sqrt(numOfObjects);
		float spacing = spaceSize / ((float)numObjectsEachLine);
		objects = new GameObject[numOfObjects];

		MaterialPropertyBlock props = new MaterialPropertyBlock();
		MeshRenderer renderer;
		int i = 0;
		float startPos = - spaceSize * 0.5f;
		for (int xIter = 0; xIter < numObjectsEachLine; xIter++)
		{
			for (int zIter = 0; zIter < numObjectsEachLine; zIter++)
			{
				objects[i] = Instantiate(objPrefab) as GameObject;
				objects[i].name = "Object" + i;
				objects[i].transform.parent = transform;
				objects[i].transform.localScale = new Vector3(
					spacing,
					spacing,
					spacing
				);
				props.SetColor("_Color", new Color(
					Random.Range(0.0f, 1.0f), 
					Random.Range(0.0f, 1.0f), 
					Random.Range(0.0f, 1.0f)
				));
				renderer = objects[i].GetComponent<MeshRenderer>();
				renderer.SetPropertyBlock(props);

				objects[i].transform.position = new Vector3(
					startPos + xIter * spacing, 
					0f, 
					startPos + zIter * spacing
				);
				i++;
			}
		}
	}
}
