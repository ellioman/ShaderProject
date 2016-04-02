using UnityEngine;
using System.Collections;

[ExecuteInEditMode]
public class BlackWhite : MonoBehaviour
{
	// Unity Editor Variables
	[SerializeField] protected Material mat;
	[SerializeField] protected float speed;

	// Protected Const Variables
	protected string BLEND_VALUE_NAME = "_bwBlend";

	// Protected Instance Variables
	protected float bwBlendVal = 0;

	// Called once every fram
	protected void Update()
	{
		bwBlendVal = Mathf.Sin(Time.time * speed) * 0.5f + 0.5f;
		mat.SetFloat(BLEND_VALUE_NAME, bwBlendVal);
	}

	// Called after all rendering is complete to render image. Postprocessing effects.
	public void OnRenderImage(RenderTexture source, RenderTexture destination)
	{
		// Copy the source Render Texture to the destination,
		// applying the material along the way.
		Graphics.Blit(source, destination, mat);
	}
}
