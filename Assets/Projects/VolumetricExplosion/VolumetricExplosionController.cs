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
		if (Input.GetKeyUp(KeyCode.Space))
		{
			Instantiate(explosionPrefab);
		}
	}

	private void OnGUI()
	{
		GUI.Label (
			new Rect (10, 10, 1000, 100),
			"Space: Create Explosion"
		);
	}

	#endregion
}
