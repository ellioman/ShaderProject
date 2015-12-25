using UnityEngine;
using System.Collections;

[ExecuteInEditMode]
public class Pixels : MonoBehaviour
{
	// Unity Editor Variables
	[SerializeField] protected Material mat;
	[SerializeField] protected int startPixelSizeVal;
	[SerializeField] protected int endPixelSizeVal;
	[SerializeField] protected int speed;

	// Protected Const Variables
	protected string PIXEL_SIZE_NAME = "_PixelSize";

	// Protected Instance Variables
	protected bool isDoneAnimating = false;
	protected float pixelSizeVal = 100;

	// Constructor
	protected void Awake()
	{
		mat.SetFloat(PIXEL_SIZE_NAME, startPixelSizeVal);
	}

	// Called once every fram
	protected void Update()
	{
		if (!isDoneAnimating)
		{
			float curVal = mat.GetFloat(PIXEL_SIZE_NAME);
			if (curVal != endPixelSizeVal)
			{
				mat.SetFloat(PIXEL_SIZE_NAME, pixelSizeVal);
				pixelSizeVal = Mathf.Clamp(pixelSizeVal - speed * Time.deltaTime, endPixelSizeVal, startPixelSizeVal);
			}
			else
			{
				isDoneAnimating = true;
			}
		}
	}

	// Called after all rendering is complete to render image.
	public void OnRenderImage(RenderTexture source, RenderTexture destination)
	{
		// Copy the source Render Texture to the destination,
		// applying the material along the way.
		Graphics.Blit(source, destination, mat);
	}
}
