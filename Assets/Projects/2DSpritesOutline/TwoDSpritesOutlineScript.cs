using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class TwoDSpritesOutlineScript : MonoBehaviour
{
	// Unity Editor Variables
	[SerializeField] private Color color = Color.white;
	[SerializeField] [Range(0, 16)] private int outlineSize = 1;

	// Private Variables
	private SpriteRenderer spriteRenderer;


	void OnEnable()
	{
		spriteRenderer = GetComponent<SpriteRenderer>();
		UpdateOutline(true);
	}

	void OnDisable()
	{
		UpdateOutline(false);
	}

	void Update()
	{
		UpdateOutline(true);
	}

	void UpdateOutline(bool outline)
	{
		MaterialPropertyBlock mpb = new MaterialPropertyBlock();
		spriteRenderer.GetPropertyBlock(mpb);
		mpb.SetFloat("_Outline", outline ? 1f : 0);
		mpb.SetColor("_OutlineColor", color);
		mpb.SetFloat("_OutlineSize", outlineSize);
		spriteRenderer.SetPropertyBlock(mpb);
	}
}