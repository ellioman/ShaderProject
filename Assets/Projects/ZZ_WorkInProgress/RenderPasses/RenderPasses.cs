using UnityEngine;
using System.Collections;

public class RenderPasses : MonoBehaviour
{
	#region Variables

	// Unity Editor Variables
	[SerializeField] protected Shader shader1;
	[SerializeField] protected Texture2D blendTexture;

	// Protected Instance Variables
	protected Material mat1;

	// Public Properties
	public Material Mat1
	{
		get
		{
			if (mat1 == null)
			{
				mat1 = new Material(shader1);
				mat1.hideFlags = HideFlags.HideAndDontSave;
			}
			return mat1;
		}
	}

	#endregion


	#region MonoBehaviour

	// Called after all rendering is complete to render image. Postprocessing effects.
	protected void OnRenderImage(RenderTexture sourceTexture, RenderTexture destTexture)
	{
		RenderTexture tex1 = new RenderTexture(Screen.width, Screen.height, 24, RenderTextureFormat.ARGB32);
		tex1.Create();
		Graphics.Blit(sourceTexture, tex1, Mat1);
		Graphics.Blit(tex1, destTexture);
	}

	// Called when the behaviour becomes disabled, inactive or when 
	// the object is destroyed and can be used for any cleanup code
	protected void OnDisable()
	{
		if (mat1)
		{
			DestroyImmediate(mat1);
		}
	}

	#endregion
}
