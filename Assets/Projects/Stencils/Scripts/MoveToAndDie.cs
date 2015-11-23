using UnityEngine;
using System.Collections;

public class MoveToAndDie : MonoBehaviour
{
	#region Variables

	// Unity Editor Variables
	[SerializeField] protected float speed;
	[SerializeField] protected Vector3 targetPos;

	// Protected Instance Variables
	protected Vector3 direction = Vector3.zero;

	#endregion
	
	// Update is called once per frame
	protected void Update ()
	{
		direction = (targetPos - transform.position).normalized;
		transform.Translate(direction * Time.deltaTime * speed);

		// Reset once we've reached our target position...
		if ((targetPos - transform.position).magnitude < 1f)
		{
			Destroy(gameObject);
			enabled = false;
		}
	}


}
