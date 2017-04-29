using UnityEngine;
using System.Collections;
using System.IO;

[ExecuteInEditMode]
public class DeferredTexturesScript : MonoBehaviour
{
	[SerializeField] private Shader shader;

	private Material mat = null;

	private void OnEnable()
	{
		if (mat == null)
		{
			mat = new Material(shader);
		}

		FindObjectOfType<Camera>().depthTextureMode = DepthTextureMode.DepthNormals;
	}

	void OnRenderImage (RenderTexture source, RenderTexture destination)
	{
		if (mat == null)
		{
			Graphics.Blit(source, destination);
			return;
		}

		Graphics.Blit(source, destination, mat);
	}
}