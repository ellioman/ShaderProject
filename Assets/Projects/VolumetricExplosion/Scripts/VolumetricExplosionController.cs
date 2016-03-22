using UnityEngine;
using System.Collections;

public class VolumetricExplosionController : MonoBehaviour
{
	[SerializeField] Transform explosionPrefab;

	// Use this for initialization
	protected void Start()
	{
	
	}
	
	// Update is called once per frame
	protected void Update ()
	{
		if (Input.GetKeyUp(KeyCode.A))
		{
			Instantiate(explosionPrefab);
		}
	}
}
