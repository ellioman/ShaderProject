using UnityEngine;
using System.Collections;

public class SendWorldPosToShader : MonoBehaviour
{
	[SerializeField] Material mat; 

	// Protected Instance Variables
	protected Transform tr = null;

	protected void Awake()
	{
		tr = transform;
	}

	// Update is called once per frame
	protected void Update ()
	{
		if (mat)
		{
			mat.SetVector("_WorldPos1", tr.position);

//			var materialProperty = new MaterialPropertyBlock();
//			float[] floatArray= new float[] {0f, 1f};
//
//			materialProperty.SetFloatArray("arrayName", floatArray);
//			gameObject.GetComponent<Renderer> ().SetPropertyBlock (materialProperty);
			//uniform float arrayName[2];
		}
	}
}
