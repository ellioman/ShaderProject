using UnityEngine;
using System.Collections;

public class Painting : MonoBehaviour
{
	[SerializeField] Material textureAtlas;
	[SerializeField] Transform target;
	[SerializeField] float speed;

	// Protected Instance Variables
	bool isPlaying = false;
	float startTime = 0f; 

	// Use this for initialization
	protected void Start()
	{
		if (textureAtlas == null || target == null)
		{
			enabled = false;
		}
	}
	
	// Update is called once per frame
	protected void Update()
	{
		transform.position = transform.position * 0.98f + target.position * 0.02f;

		if (Vector3.Distance(transform.position, target.position) < 1f)
		{
			if (!isPlaying)
			{
				startTime = Time.time;
				isPlaying = true;
			}

			textureAtlas.SetFloat("_AnimationTime", Time.time - startTime);

			if ((Time.time - startTime) > 8f)
			{
				enabled = false;
			}
		}
		else
		{
			textureAtlas.SetFloat("_AnimationTime", 0f);
		}
	}
}
