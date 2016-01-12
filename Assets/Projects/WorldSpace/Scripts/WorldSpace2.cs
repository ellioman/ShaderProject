using UnityEngine;
using System.Collections;

public class WorldSpace2 : MonoBehaviour
{
	[SerializeField] protected Transform obj1;
	[SerializeField] protected Transform obj2;
	[SerializeField] protected Transform obj3;
	[SerializeField] protected Transform obj4;
	[SerializeField] protected Shader shader;

	protected Material mat;
	protected Mesh mesh;
	protected bool shouldReset = true;


	// Update is called once per frame
	protected void Update()
	{
		if (shouldReset)
		{
			ResetResources();
			shouldReset = false;
		}

//		mat.SetVector("_Position1", obj1.position);
//		mat.SetVector("_Position2", obj2.position);
//		mat.SetVector("_Position3", obj3.position);
//		mat.SetVector("_Position4", obj4.position);


		Graphics.DrawMesh(mesh, transform.localToWorldMatrix, mat, 0); 
	}

	protected void ResetResources()
	{
		if (mesh) DestroyImmediate(mesh);
		if (mat) DestroyImmediate(mat);

		BuildBulkMesh();

		mat = new Material(shader);
		mat.hideFlags = HideFlags.DontSave;

//		_rotation = 60.0f + _randomSeed * 30;
//		_noiseOffset = Vector3.one * _randomSeed * 11.1f;
	}

	protected void BuildBulkMesh()
	{
//		var instanceCount = 65000 / 8;
		var instanceCount = 8 / 8;

		var verts = new Vector3[instanceCount * 8];
		var norms = new Vector3[verts.Length];
		var uvs = new Vector2[verts.Length];

		var i_tmp = 0;
		for (var instance = 0; instance < instanceCount; instance++)
		{
			var uv0 = new Vector2(
				(float)(instance % 40) / 40,
				(float)(instance / 40) * 40 / instanceCount
			);

			Vector3 mov = new Vector3(3.0f * instance, 0f, 0f);
			verts[i_tmp + 0] = verts[i_tmp + 4] = new Vector3(-1, 0, -1) + mov;
			verts[i_tmp + 1] = verts[i_tmp + 5] = new Vector3(+1, 0, -1) + mov;
			verts[i_tmp + 2] = verts[i_tmp + 6] = new Vector3(-1, 0, +1) + mov;
			verts[i_tmp + 3] = verts[i_tmp + 7] = new Vector3(+1, 0, +1) + mov;

			norms[i_tmp + 0] = norms[i_tmp + 1] =
				norms[i_tmp + 2] = norms[i_tmp + 3] = Vector3.up;
			norms[i_tmp + 4] = norms[i_tmp + 5] =
				norms[i_tmp + 6] = norms[i_tmp + 7] = -Vector3.up;

			uvs[i_tmp + 0] = uvs[i_tmp + 1] = new Vector2(0f,0f);
			uvs[i_tmp + 2] = uvs[i_tmp + 3] = new Vector2(0f,1f);
			uvs[i_tmp + 4] = uvs[i_tmp + 5] = new Vector2(1f,0f);
			uvs[i_tmp + 6] = uvs[i_tmp + 7] = new Vector2(1f,1f);

			i_tmp += 8;
		}

		var idx_tmp = new int[12 * instanceCount];

		i_tmp = 0;
		var i_0 = 0;
		for (var instance = 0; instance < instanceCount; instance++)
		{
			idx_tmp[i_tmp++] = i_0 + 0;
			idx_tmp[i_tmp++] = i_0 + 2;
			idx_tmp[i_tmp++] = i_0 + 1;

			idx_tmp[i_tmp++] = i_0 + 3;
			idx_tmp[i_tmp++] = i_0 + 1;
			idx_tmp[i_tmp++] = i_0 + 2;

			i_0 += 4;

			idx_tmp[i_tmp++] = i_0 + 0;
			idx_tmp[i_tmp++] = i_0 + 1;
			idx_tmp[i_tmp++] = i_0 + 2;

			idx_tmp[i_tmp++] = i_0 + 3;
			idx_tmp[i_tmp++] = i_0 + 2;
			idx_tmp[i_tmp++] = i_0 + 1;

			i_0 += 4;
		}

		mesh = new Mesh();
		mesh.hideFlags = HideFlags.DontSave;
		mesh.vertices = verts;
		mesh.normals = norms;
		mesh.uv = uvs;

		mesh.SetIndices(idx_tmp, MeshTopology.Triangles, 0);
		mesh.bounds = new Bounds(Vector3.zero, Vector3.one * 1000);
	}
}
