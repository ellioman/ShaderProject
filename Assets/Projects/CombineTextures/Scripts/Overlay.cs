using UnityEngine;
using System.Collections;

[ExecuteInEditMode]
public class Overlay : MonoBehaviour
{
	// Unity Editor Variables
	[SerializeField] protected float minRandomVal;
	[SerializeField] protected float maxRandomVal;
	[SerializeField] protected Material mat;
	[SerializeField] protected Texture2D[] textures;

	// Protected Const Variables
	protected string BLEND_VALUE_NAME = "_SecondTex";

//	// Protected Instance Variables
	protected int texIndex = 0;
	protected float time = 0;
	protected float delay = 0;


	void Start()
	{
		mat.SetTexture(BLEND_VALUE_NAME, textures[texIndex]);
		time = Time.time;
		texIndex = (texIndex + 1) % textures.Length;
	}

	// Called once every fram
	protected void Update()
	{
		if (Time.time - time > delay)
		{
			mat.SetTexture(BLEND_VALUE_NAME, textures[texIndex]);

			time = Time.time;
			delay = Random.Range(minRandomVal, maxRandomVal);

			int curIndex = texIndex;
			while (texIndex == curIndex)
			{
				texIndex = Random.Range(0, textures.Length);
			}

		}
	}

	// Called after all rendering is complete to render image. Postprocessing effects.
	public void OnRenderImage(RenderTexture source, RenderTexture destination)
	{
		// Copy the source Render Texture to the destination,
		// applying the material along the way.
		Graphics.Blit(source, destination, mat);
	}
}
