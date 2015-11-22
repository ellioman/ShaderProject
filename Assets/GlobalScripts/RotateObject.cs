using UnityEngine;
using System.Collections;

public class RotateObject : MonoBehaviour
{
	#region Variables

	// Unity Editor Variables
	[SerializeField] protected float speed;
	[SerializeField] protected Vector3 axis;

	#endregion


	#region Monobehaviour

	// Update is called once per frame
	protected void Update ()
	{
		// Rotate the object around the axis
		transform.Rotate(axis.normalized * Time.deltaTime * speed);
	}

	#endregion
}
