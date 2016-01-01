using UnityEngine;
using System.Collections;

[ExecuteInEditMode]
public class Tint : MonoBehaviour
{
	// Unity Editor Variables
	[SerializeField] protected Material mat;

	// Called after all rendering is complete to render image.
	public void OnRenderImage(RenderTexture source, RenderTexture destination)
	{
		// Copy the source Render Texture to the destination,
		// applying the material along the way.
		Graphics.Blit(source, destination, mat);
	}
}
