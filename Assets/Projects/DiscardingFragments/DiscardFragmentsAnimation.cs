using UnityEngine;
using System.Collections;

public class DiscardFragmentsAnimation : MonoBehaviour
{
	#region Variables

	// Unity Editor Variables
	[SerializeField] protected Material discardMaterial;
	[SerializeField] protected float speed;
	[SerializeField] protected float lowLimit;
	[SerializeField] protected float upperLimit;

	// Protected Const Variables
	const string DISCARD_LIMIT_NAME = "_DiscardLimit";

	#endregion


	#region MonoBehaviour

	// Update is called once per frame
	protected void Update ()
	{
		if (discardMaterial)
		{
			discardMaterial.SetFloat(
				DISCARD_LIMIT_NAME,
				lowLimit + (Mathf.Sin(Time.time * speed) * 0.5f + 0.5f) * upperLimit
			);
		}
	}

	#endregion
}
