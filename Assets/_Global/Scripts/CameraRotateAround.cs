using UnityEngine;
using System.Collections;

public class CameraRotateAround : MonoBehaviour
{
	#region Variables

	// Unity Editor Variables
	[SerializeField] protected Transform target;    //target to which camera will look always
	[SerializeField] protected float distance;         //distance of camera from target
	[SerializeField] protected float X_Smooth;
	[SerializeField] protected float Y_Smooth;
	[SerializeField] protected float height;
	[SerializeField] protected float speed;

	// Protected Instance Variables
	protected float rotX = 0f;
	protected float desiredDistance = 0f; //desired distance of camera from target
	protected float velDistance = 0f;    
	protected float velX = 0f;
	protected float velY = 0f;
	protected float velZ = 0f;
	protected Vector3 position = Vector3.zero;
	protected Vector3 desiredPosition = Vector3.zero; 

	#endregion

	#region MonoBehaviour

	void Start()
	{
		position = transform.position;
	}
	protected void FixedUpdate () 
	{
		if (target == null)
		{
			return;
		}

		// Update the position
		UpdatePosition();
	}

	#endregion

	#region Protected Functions

	protected Vector3 CalculatePosition(float rotationX, float rotationY, float distance)
	{
		Vector3 direction = new Vector3(0, 0, -distance);
		Quaternion rotation = Quaternion.Euler(rotationX, rotationY, 0);
		return target.position + rotation * direction;
	}

	protected void UpdatePosition()
	{
		// Calculate the rotation
		rotX += Time.deltaTime * speed;

		// Calculate the desired position();
		desiredPosition = CalculatePosition(height, rotX, distance);

		var posX = Mathf.SmoothDamp(position.x, desiredPosition.x, ref velX, X_Smooth);
		var posY = Mathf.SmoothDamp(position.y, desiredPosition.y, ref velY, Y_Smooth);
		var posZ = Mathf.SmoothDamp(position.z, desiredPosition.z, ref velZ, X_Smooth);

		position = new Vector3(posX, posY, posZ);
		transform.position = position;
		transform.LookAt(target);
	}

	#endregion
}
