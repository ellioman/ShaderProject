using UnityEngine;
using System.Collections;

public class CameraFaderExample : MonoBehaviour
{
	#region Variables

	// Unity Editor Variables
	[SerializeField] CameraFader camFader;

	#endregion


	#region MonoBehaviour

	// Update is called once per frame
	private void Update() 
	{
		if (camFader)
		{
			if (Input.GetKeyUp(KeyCode.Space))
			{
				Vector2 viewportPos = Vector2.one * 0.5f;
				camFader.CloseCircle(1f, viewportPos);
			}
			else if (Input.GetKeyUp(KeyCode.Return))
			{
				Vector2 viewportPos = Vector2.one * 0.5f;
				camFader.OpenCircle(1f, viewportPos);
			}
			else if (Input.GetKeyUp(KeyCode.B))
			{
				camFader.OpenBars(1f);
			}
			else if (Input.GetKeyUp(KeyCode.V))
			{
				camFader.CloseBars(3f);
			}
			else if (Input.GetKeyUp(KeyCode.C))
			{
				camFader.SetBarVal(Random.Range(0f, 1f));
			}
		}
	}

	#endregion
}
