using UnityEngine;
using System.Collections;

public class VolumetricExplosion : MonoBehaviour
{
	[SerializeField] protected float duration;
	[SerializeField] protected Vector3 endSize; 

	protected float startTime = 0f;
	protected Material mat = null;

	// Use this for initialization
	void Start()
	{
		startTime = Time.time;

		Renderer r = GetComponent<Renderer>();
		mat = new Material(r.sharedMaterial);
		r.material = mat;
	}
	
	// Update is called once per frame
	void Update()
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
}
