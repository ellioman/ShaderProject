using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class MultipleRenderTargets : MonoBehaviour
{
	[SerializeField] Shader _shader;

	private Material material;
	private RenderBuffer[] multipleRenderTargetsArray;

	private void OnEnable()
	{
		Shader shader = Shader.Find("Ellioman/MultipleRenderTargets");
		material = new Material(shader);
		material.hideFlags = HideFlags.DontSave;
		multipleRenderTargetsArray = new RenderBuffer[3];
	}

	private void OnDisable()
	{
		DestroyImmediate(material);
		material = null;
		multipleRenderTargetsArray = null;
	}

	private void OnRenderImage(RenderTexture source, RenderTexture destination)
	{
		RenderTexture rt1 = RenderTexture.GetTemporary(source.width, source.height, 0, RenderTextureFormat.Default);
		RenderTexture rt2 = RenderTexture.GetTemporary(source.width, source.height, 0, RenderTextureFormat.DefaultHDR);
		RenderTexture rt3 = RenderTexture.GetTemporary(source.width, source.height, 0, RenderTextureFormat.DefaultHDR);

		multipleRenderTargetsArray[0] = rt1.colorBuffer;
		multipleRenderTargetsArray[1] = rt2.colorBuffer;
		multipleRenderTargetsArray[2] = rt3.colorBuffer;

		// Blit with a MRT.
		Graphics.SetRenderTarget(multipleRenderTargetsArray, rt1.depthBuffer);
		Graphics.Blit(null, material, 0);

		// Combine them and output to the destination.
		material.SetTexture("_SecondTex", rt1);
		material.SetTexture("_ThirdTex", rt2);
		material.SetTexture("_FourthTex", rt3);
		Graphics.Blit(source, destination, material, 1);

		RenderTexture.ReleaseTemporary(rt1);
		RenderTexture.ReleaseTemporary(rt2);
		RenderTexture.ReleaseTemporary(rt3);
	}

	void OnGUI()
	{
		var text = "Supported MRT count: ";
		text += SystemInfo.supportedRenderTargetCount;
		GUI.Label(new Rect(0, 0, 200, 200), text);
	}
}