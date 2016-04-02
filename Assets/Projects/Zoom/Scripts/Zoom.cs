using UnityEngine;
using System.Collections;

[ExecuteInEditMode]
public class Zoom : MonoBehaviour
{
	// Unity Editor Variables
	[SerializeField] protected Material mat;
	[SerializeField] protected Transform obj;

	// Protected Const Variables
	protected string ZOOM_POS = "_ZoomViewPointPos";

	// Protected Instance Variables
	float xMin = 0f;
	float xMax = 0f;
	float yMin = 0f;
	float yMax = 0f;

	// Called on the frame when a script is enabled just before 
	// any of the Update methods is called the first time.
	protected void Start()
	{
		float dist = Vector3.Distance(transform.position, Vector3.zero);
		Vector2 leftBottom = Camera.main.ViewportToWorldPoint(new Vector3(0f, 0f, dist));
		Vector2 rightTop = Camera.main.ViewportToWorldPoint(new Vector3(1f, 1f, dist));

		xMin = leftBottom.x;
		xMax = rightTop.x;
		yMin = leftBottom.y;
		yMax = rightTop.y;
	}

	// Called once every fram
	protected void Update()
	{
		Vector3 pos = obj.position;
		pos.x = Mathf.Clamp(pos.x, xMin, xMax);
		pos.y = Mathf.Clamp(pos.y, yMin, yMax);
		obj.position = pos;

		Vector3 viewPortPos = Camera.main.WorldToViewportPoint(obj.position);

		mat.SetFloat("_T", viewPortPos.x);
		mat.SetFloat("_V", viewPortPos.y);
	}

	// Called after all rendering is complete to render image. Postprocessing effects.
	public void OnRenderImage(RenderTexture source, RenderTexture destination)
	{
		// Copy the source Render Texture to the destination,
		// applying the material along the way.
		Graphics.Blit(source, destination, mat);

		Vector3 viewPortPos = Camera.main.WorldToViewportPoint(obj.position);
		Debug.Log(viewPortPos);
	}
}
