using UnityEngine;
using System.Collections;

[ExecuteInEditMode]
public class Pixels : MonoBehaviour
{
	// Unity Editor Variables
	[SerializeField] protected Material mat;
	[SerializeField] protected int endPixelSizeVal;
	[SerializeField] protected int speed;

	// Protected Instance Variables
	protected float pixelSizeVal = 1024;


	protected void Update()
	{
		if (pixelSizeVal > endPixelSizeVal)
		{
			mat.SetFloat("_PixelSize", pixelSizeVal);
			pixelSizeVal -= speed * Time.deltaTime;
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
