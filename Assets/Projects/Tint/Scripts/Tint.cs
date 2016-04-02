using UnityEngine;
using System.Collections;

[ExecuteInEditMode]
public class Tint : MonoBehaviour
{
	#region Variables

	// Unity Editor Variables
	[SerializeField] protected Shader shader;
	[SerializeField] protected Color tintColor;

	// Protected Instance Variables
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
	}

	// Called after all rendering is complete to render image. Postprocessing effects.
	public void OnRenderImage(RenderTexture sourceTexture, RenderTexture destTexture)
	{
		if (shader != null)
		{
			// Copy the source Render Texture to the destination,
			// applying the material along the way.
			Mat.SetColor("_Tint", tintColor);
			Graphics.Blit(sourceTexture, destTexture, Mat);
		}
		else
		{
			Graphics.Blit(sourceTexture, destTexture);
		}
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
