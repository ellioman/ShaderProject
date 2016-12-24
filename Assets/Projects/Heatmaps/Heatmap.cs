// Alan Zucconi
// www.alanzucconi.com
using UnityEngine;
using System.Collections;

public class Heatmap : MonoBehaviour
{
	// Unity Editor Variables
	[SerializeField] private int count = 50;
	[SerializeField] private Material material;

	// Private Instance Variables
	private Vector4[] positions;
	private Vector4[] properties;

	// Constructor
	private void Awake ()
	{
		material.SetFloatArray("_Points", new float[count]);
	}

	private void Start ()
    {
        positions = new Vector4[count];
		properties = new Vector4[count];

        for (int i = 0; i < positions.Length; i++)
        {
            positions[i] = new Vector2(Random.Range(-0.9f, 0.9f), Random.Range(-0.5f, 0.5f));
			properties[i] = new Vector2(Random.Range(0f, 0.25f), Random.Range(-0.25f, 1f)); // (Radius, Intensities)
        }
		material.SetVectorArray("_Properties", properties);
		material.SetInt("_Points_Length", positions.Length);
    }

	private void Update()
    {   
        for (int i = 0; i < positions.Length; i++)
        {
            positions[i] += new Vector4(Random.Range(-0.1f, +0.1f), Random.Range(-0.1f, +0.1f), 0f, 0f) * Time.deltaTime;
        }
		material.SetVectorArray("_Points", positions);
    }
}