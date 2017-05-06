using UnityEngine;
using System.Collections;

public class MoveObject : MonoBehaviour
{
	#region Variables

	// Unity Editor Variables
	[SerializeField] protected float speed;
	[SerializeField] protected Vector3 direction;

	#endregion


	#region Monobehaviour

	// Update is called once per frame
	protected void Update ()
	{
		transform.Translate(direction.normalized * Time.deltaTime * speed);
	}

	#endregion
}
