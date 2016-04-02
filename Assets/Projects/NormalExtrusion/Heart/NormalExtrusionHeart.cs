using UnityEngine;
using System.Collections;

public class NormalExtrusionHeart : MonoBehaviour
{
	#region Variables

	[SerializeField] protected float max;
	[SerializeField] protected float min;
	[SerializeField] protected float speed;

	// Protected Instance Variables
	protected Material mat = null;
	protected float startTime = 0f;

	#endregion


	#region MonoBehaviour

	// Called on the frame when a script is enabled just before 
	// any of the Update methods is called the first time.
	protected void Start()
	{
		Renderer r = GetComponent<Renderer>();
		mat = new Material(r.sharedMaterial);
		r.material = mat;

		startTime = Time.time;
	}
	
	// Update is called once per frame
	protected void Update()
	{
		float val = (Mathf.Sin(Time.time * speed) * 0.5f + 0.5f) * max + min;
		mat.SetFloat("_Amount", val);
	}

	#endregion
}
