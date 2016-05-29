using UnityEngine;
using System.Collections;

public class VolumetricExplosion : MonoBehaviour
{
	#region Variables

	// Unity Editor Variables
	[SerializeField] protected float duration;
	[SerializeField] protected Vector3 endSize; 

	// Protected Instance Variables
	protected float startTime = 0f;
	protected Material mat = null;

	#endregion


	#region MonoBehaviour

	// Called on the frame when a script is enabled just before 
	// any of the Update methods is called the first time.
	protected void Start()
	{
		startTime = Time.time;

		Renderer r = GetComponent<Renderer>();
		mat = new Material(r.sharedMaterial);
		r.material = mat;
	}
	
	// Update is called once per frame
	protected void Update()
	{
		float animationStatus = ((Time.time - startTime) / duration);
		transform.localScale = endSize * animationStatus;

		float ramp = (animationStatus - 0.75f);
		mat.SetFloat("_RampOffset", ramp);
		if (ramp >= 1.5f)
		{
			enabled = false;
			Destroy(gameObject);
		}
	}

	#endregion
}
