using UnityEngine;
using System.Collections;

public class VolumetricExplosionController : MonoBehaviour
{
	#region Variables

	// Unity Editor Variables
	[SerializeField] Transform explosionPrefab;

	#endregion


	#region MonoBehaviour

	// Update is called once per frame
	protected void Update ()
	{
		if (Input.GetKeyUp(KeyCode.A))
		{
			Instantiate(explosionPrefab);
		}
	}

	#endregion
}
