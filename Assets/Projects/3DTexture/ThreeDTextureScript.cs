using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ThreeDTextureScript : MonoBehaviour
{
	public Texture3D tex;
	public int size = 16;

	void Start ()
	{
		tex = new Texture3D (size, size, size, TextureFormat.ARGB32, true);
		var cols = new Color[size*size*size];
		float mul = 1.0f / (size-1);
		int idx = 0;
		Color c = Color.white;
		for (int z = 0; z < size; ++z)
		{
			for (int y = 0; y < size; ++y)
			{
				for (int x = 0; x < size; ++x, ++idx)
				{
					c.r = ((x)!=0) ? x*mul : 1-x*mul;
					c.g = ((y)!=0) ? y*mul : 1-y*mul;
					c.b = ((z)!=0) ? z*mul : 1-z*mul;
					cols[idx] = c;
				}
			}
		}
		tex.SetPixels (cols);
		tex.Apply ();
		GetComponent<Renderer>().material.SetTexture ("_Volume", tex);
	}  
}
