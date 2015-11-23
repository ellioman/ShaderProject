using UnityEngine;
using UnityEngine.Assertions;
using System.Collections;

public class MaskFactory : MonoBehaviour
{
	#region Variables
	
	// Unity Editor Variables
	[SerializeField] protected GameObject[] maskPrefabs;
	[SerializeField] protected float spawnDelay;

	// Protected Instance Variables
	protected int maskIndex = 0;
	protected float lastSpawnTime = 0f;

	#endregion

	// Constructor
	protected void Awake()
	{
		Assert.IsTrue(maskPrefabs.Length > 0);
	}

	// Use this for initialization
	protected void Start()
	{
		//SpawnObject();
		lastSpawnTime = Time.time;
	}
	
	// Update is called once per frame
	protected void Update()
	{
		if (Time.time - lastSpawnTime > spawnDelay)
		{
			SpawnObject();
		}
	}

	protected void SpawnObject()
	{
		lastSpawnTime = Time.time;
		GameObject mask = Instantiate(maskPrefabs[maskIndex]);
		mask.transform.position = transform.position;
		mask.transform.parent = transform;
		maskIndex = (maskIndex + 1) % maskPrefabs.Length;
	}
}
