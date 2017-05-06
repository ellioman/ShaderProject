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
			if (Input.GetKeyUp(KeyCode.A))
			{
				Vector2 viewportPos = Vector2.one * 0.5f;
				camFader.CloseCircle(1f, viewportPos);
			}
			else if (Input.GetKeyUp(KeyCode.S))
			{
				Vector2 viewportPos = Vector2.one * 0.5f;
				camFader.OpenCircle(1.5f, viewportPos);
			}
			else if (Input.GetKeyUp(KeyCode.D))
			{
				camFader.CloseBars(3f);
			}
			else if (Input.GetKeyUp(KeyCode.F))
			{
				camFader.OpenBars(1.5f);
			}
			else if (Input.GetKeyUp(KeyCode.G))
			{
				camFader.SetBarVal(Random.Range(0f, 1f));
			}
		}
	}

	private float leftMargin = 10f;
	private float topMargin = 10f;
	private float yPosChange = 15f;
	private float width = 200;
	private float height = 100;
	private void OnGUI()
	{
		GUI.Label(
			new Rect(leftMargin, topMargin, 100, 100),
			"A: Close Circle"
		);

		GUI.Label(
			new Rect(leftMargin, topMargin + yPosChange * 1, width, height),
			"S: Open Circle"
		);

		GUI.Label(
			new Rect(leftMargin, topMargin + yPosChange * 2, width, height),
			"D: Close Bars"
		);

		GUI.Label(
			new Rect(leftMargin, topMargin + yPosChange * 3, width, height),
			"F: Open Bars"
		);

		GUI.Label(
			new Rect(leftMargin, topMargin + yPosChange * 4, width, height),
			"G: Random Bars Pos"
		);
	}

	#endregion
}
