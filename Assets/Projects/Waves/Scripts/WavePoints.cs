using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class WavePoints : MonoBehaviour
{
	#region Variables

	// Unity Editor Variables
	[SerializeField] protected Material _material;
	[SerializeField] protected Vector3 centerPos = new Vector3(0f, 2f, 0f);
	[SerializeField] protected float waveheight;
	[SerializeField] protected float speed;
	[SerializeField] protected float size;
	[SerializeField] protected Color color;
	[SerializeField] protected float distortion;

	// Protected Instance Variables
	protected float radius = 5f;
	protected int numOfPoints = 360;
	protected List<Wave> waves = new List<Wave>();
	protected class Wave
	{
		public Mesh _mesh;
		public Vector3[] points = null;
		public Vector3[] pointsDir = null;
		public Vector3[] vtx = null;
		public Vector3[] nrm = null;
		public Vector2[] uv0 = null;
		public int[] idx = null;
	}

	#endregion


	#region MonoBehaviour

	// Called on the frame when a script is enabled just before 
	// any of the Update methods is called the first time.
	protected void Start()
	{
		_material.hideFlags = HideFlags.DontSave;
	}

	// Called every fixed framerate frame
	protected void FixedUpdate()
	{
		for (int w = 0; w < waves.Count; w++)
		{
			for (int i = 0; i < waves[w].points.Length; i++)
			{
				waves[w].points[i] += waves[w].pointsDir[i] * Time.fixedDeltaTime * speed;
			}
		}
	}

	// Update is called once per frame
	protected void Update()
	{
		_material.SetFloat("_Distortion", distortion);
		_material.SetColor("_Color", color);

		for (int w = 0; w < waves.Count; w++)
		{
			CalculateVertices(waves[w]);
		}


		if (Input.GetKeyUp(KeyCode.A))
		{
			CreateWaveBatchAndPoints();
		}
	}

	#endregion


	#region Protected Functions

	// Creates the wave and calculates the points on the wave
	protected void CreateWaveBatchAndPoints()
	{
		Wave wave = new Wave();
		wave.points = new Vector3[numOfPoints];
		wave.pointsDir = new Vector3[numOfPoints];

		float theta = numOfPoints * Mathf.Deg2Rad;
		for(int i = 0; i < numOfPoints; i++)
		{
			theta -= 1f * Mathf.Deg2Rad;
			wave.points[i] = centerPos + new Vector3(radius * Mathf.Cos(theta), 0f, radius * Mathf.Sin(theta));
			wave.pointsDir[i] = (wave.points[i] - centerPos).normalized;
		}

		wave.vtx = new Vector3[numOfPoints * 6]; // 
		wave.nrm = new Vector3[wave.vtx.Length];		// Each vertice needs a normal
		wave.uv0 = new Vector2[wave.vtx.Length];		// 
		wave.idx = new int[numOfPoints * 12];		// 

		int indTemp = 0;
		for (int i = 0; i < numOfPoints; i++)
		{
			wave.nrm[indTemp + 0] = Vector3.up;
			wave.nrm[indTemp + 1] = Vector3.up;
			wave.nrm[indTemp + 2] = Vector3.up;
			wave.nrm[indTemp + 3] = Vector3.up;
			wave.nrm[indTemp + 4] = Vector3.up;
			wave.nrm[indTemp + 5] = Vector3.up;

			wave.uv0[indTemp + 0] = new Vector2(((i + 0) / ((float) numOfPoints)), 0f);
			wave.uv0[indTemp + 1] = new Vector2(((i + 0) / ((float) numOfPoints)), 0.5f);
			wave.uv0[indTemp + 2] = new Vector2(((i + 0) / ((float) numOfPoints)), 1f);
			wave.uv0[indTemp + 3] = new Vector2(((i + 1) / ((float) numOfPoints)), 0f);
			wave.uv0[indTemp + 4] = new Vector2(((i + 1) / ((float) numOfPoints)), 0.5f);
			wave.uv0[indTemp + 5] = new Vector2(((i + 1) / ((float) numOfPoints)), 1f);

			indTemp += 6;
		}

		indTemp = 0;
		int k = 0;
		for (int i = 0; i < numOfPoints; i++)
		{
			wave.idx[indTemp + 0] = k + 0;
			wave.idx[indTemp + 1] = k + 1;
			wave.idx[indTemp + 2] = k + 3;

			wave.idx[indTemp + 3] = k + 1;
			wave.idx[indTemp + 4] = k + 4;
			wave.idx[indTemp + 5] = k + 3;

			wave.idx[indTemp + 6] = k + 1;
			wave.idx[indTemp + 7] = k + 2;
			wave.idx[indTemp + 8] = k + 4;

			wave.idx[indTemp + 9] = k + 2;
			wave.idx[indTemp +10] = k + 5;
			wave.idx[indTemp +11] = k + 4;

			indTemp += 12;
			k += 6;
		}

		wave._mesh = new Mesh();
		CalculateVertices(wave);
		wave._mesh.hideFlags = HideFlags.DontSave;
		wave._mesh.vertices = wave.vtx;
		wave._mesh.normals = wave.nrm;
		wave._mesh.uv = wave.uv0;
		wave._mesh.SetIndices(wave.idx, MeshTopology.Triangles, 0);
		wave._mesh.bounds = new Bounds(Vector3.zero, Vector3.one * 1000);

		waves.Add(wave);
	}

	protected void CalculateVertices(Wave wave)
	{
		int indTemp = 0;
		for (int i = 0; i < numOfPoints; i++)
		{
			wave.vtx[indTemp + 0] = wave.points[(i + 0)              ] - wave.pointsDir[i] * size;
			wave.vtx[indTemp + 1] = wave.points[(i + 0)              ] + new Vector3(0f, waveheight, 0f);
			wave.vtx[indTemp + 2] = wave.points[(i + 0)              ] + wave.pointsDir[i] * size;
			wave.vtx[indTemp + 3] = wave.points[(i + 1) % numOfPoints] - wave.pointsDir[(i + 1) % numOfPoints] * size;
			wave.vtx[indTemp + 4] = wave.points[(i + 1) % numOfPoints] + new Vector3(0f, waveheight, 0f);
			wave.vtx[indTemp + 5] = wave.points[(i + 1) % numOfPoints] + wave.pointsDir[(i + 1) % numOfPoints] * size;

			indTemp += 6;
		}

		wave._mesh.vertices = wave.vtx;
		Graphics.DrawMesh(wave._mesh, transform.localToWorldMatrix, _material, 0);
	}

	#endregion
}
