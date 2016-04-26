using UnityEngine;
using System.Collections;

public class TextureAtlas : MonoBehaviour
{
	#region Variables

	// Unity Editor Variables
	[SerializeField] protected Shader shader;

	// Protected Instance Variables
	protected Material mat;

	#endregion

	#region MonoBehaviour

	// Called on the frame when a script is enabled just before 
	// any of the Update methods is called the first time.
	protected void Start()
	{
		Renderer rend = GetComponent<Renderer>();
		if (rend && rend.material)
		{
			mat = rend.material;
		}
		else
		{
			enabled = false;
		}
	}
	
	// Update is called once per frame
	protected void Update ()
	{
		mat.SetFloat("_AlphaAmount", Mathf.Sin(Time.time));
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
