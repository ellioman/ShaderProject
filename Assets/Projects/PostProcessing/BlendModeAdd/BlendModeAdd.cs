using UnityEngine;
using System.Collections;

[ExecuteInEditMode]
public class BlendModeAdd : MonoBehaviour
{
	#region Variables

	// Unity Editor Variables
	[SerializeField] protected Shader shader;
	[SerializeField] protected Texture2D blendTexture;
	[SerializeField] [Range(0f, 1f)] protected float blendOpacity;

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

	// Update is called once per frame
	protected void Update()
	{
		blendOpacity = Mathf.Clamp(blendOpacity, 0f, 1f);
	}

	// Called after all rendering is complete to render image. Postprocessing effects.
	protected void OnRenderImage(RenderTexture sourceTexture, RenderTexture destTexture)
	{
		if (shader != null)
		{
			// Copy the source Render Texture to the destination,
			// applying the material along the way.

			Mat.SetTexture("_BlendTex", blendTexture);
			Mat.SetFloat("_Opacity", blendOpacity);
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
