using UnityEngine;
using System.Collections;

public class WorldSpace2 : MonoBehaviour
{
	public Material mat;
	public Transform obj1;
	public Transform obj2;
	public Transform obj3;
	public Transform obj4;
	
	// Update is called once per frame
	protected void Update()
	{
		mat.SetVector("_Position1", obj1.position);
		mat.SetVector("_Position2", obj2.position);
		mat.SetVector("_Position3", obj3.position);
		mat.SetVector("_Position4", obj4.position);

	}
}
