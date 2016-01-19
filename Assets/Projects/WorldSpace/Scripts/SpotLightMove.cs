using UnityEngine;
using System.Collections;

public class SpotLightMove : MonoBehaviour
{
	[SerializeField] protected  float speed;

	// Protected Instance Variables
	protected float vertExtent = 0f;
	protected float horzExtent = 0f;
	protected Vector3 target = Vector2.zero;

	// Use this for initialization
	protected void Start()
	{
		vertExtent = Camera.main.orthographicSize;    
		horzExtent = vertExtent * Screen.width / Screen.height;
		Debug.Log(horzExtent + " : " + vertExtent);

		SetNewTarget();
	}
	
	// Update is called once per frame
	protected void Update()
	{
		if (Vector2.Distance(transform.position, target) < 0.2f)
		{
			SetNewTarget();
		}

		transform.position += (target - transform.position).normalized * speed * Time.deltaTime;
	}

	protected void SetNewTarget()
	{
		target.x = Random.Range(-horzExtent, horzExtent);
		target.z = Random.Range(-vertExtent, vertExtent);
		target = target.normalized * 20f;;
		target.x = Mathf.Clamp(target.x, -horzExtent, horzExtent);
		target.z = Mathf.Clamp(target.z, -vertExtent, vertExtent);
	}
}
