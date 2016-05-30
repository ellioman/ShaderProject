using UnityEngine;
using System.Collections;

[ExecuteInEditMode]
public class Zoom : MonoBehaviour
{
	#region Variables

	// Unity Editor Variables
	[SerializeField] protected Shader shader;
	[SerializeField] protected Transform obj;

	// Protected Const Variables
	protected string ZOOM_POS = "_ZoomViewPointPos";

	// Protected Instance Variables
	protected float xMin = 0f;
	protected float xMax = 0f;
	protected float yMin = 0f;
	protected float yMax = 0f;
	protected Material mat;

	// Public Properties
	public Material Mat
	{
		get
		{
			if (mat == null)
			{
				mat = new Material(shader);
				mat.hideFlags = HideFlags.HideAndDontSave;
			}
			return mat;
		}
	}

	#endregion


	#region MonoBehaviour

	// Called on the frame when a script is enabled just before 
	// any of the Update methods is called the first time.
	protected void Start()
	{
		if (!SystemInfo.supportsImageEffects)
		{
			enabled = false; 
			return;
		}

		if (!shader || !shader.isSupported)
		{
			enabled = false;
			return;
		}

		float dist = Vector3.Distance(transform.position, Vector3.zero);
		Vector2 leftBottom = Camera.main.ViewportToWorldPoint(new Vector3(0f, 0f, dist));
		Vector2 rightTop = Camera.main.ViewportToWorldPoint(new Vector3(1f, 1f, dist));

		xMin = leftBottom.x;
		xMax = rightTop.x;
		yMin = leftBottom.y;
		yMax = rightTop.y;
	}

	// Update is called once per frame
	protected void Update()
	{
		Vector3 pos = obj.position;
		pos.x = Mathf.Clamp(pos.x, xMin, xMax);
		pos.y = Mathf.Clamp(pos.y, yMin, yMax);
		obj.position = pos;

		Vector3 viewPortPos = Camera.main.WorldToViewportPoint(obj.position);

		Mat.SetFloat("_T", viewPortPos.x);
		Mat.SetFloat("_V", viewPortPos.y);
	}

	// Called after all rendering is complete to render image. Postprocessing effects.
	protected void OnRenderImage(RenderTexture sourceTexture, RenderTexture destTexture)
	{
		if (shader != null)
		{
			// Copy the source Render Texture to the destination,
			// applying the material along the way.
			Graphics.Blit(sourceTexture, destTexture, Mat);
		}
		else
		{
			Graphics.Blit(sourceTexture, destTexture);
		}

		Vector3 viewPortPos = Camera.main.WorldToViewportPoint(obj.position);
		Debug.Log(viewPortPos);
	}

	// Called when the behaviour becomes disabled, inactive or when 
	// the object is destroyed and can be used for any cleanup code
	protected void OnDisable()
	{
		if (mat)
		{
			DestroyImmediate(mat);
		}
	}

	#endregion
}
