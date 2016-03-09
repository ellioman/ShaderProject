using UnityEngine;
using System.Collections;

public class MouseSmoke : MonoBehaviour {

    public Material material;

	// Update is called once per frame
	void Update ()
	{
        Vector3 mouse = Input.mousePosition;
        mouse.z = transform.position.z;
        material.SetVector("_SmokeCentre",
            Camera.main.ScreenToWorldPoint(mouse)
        );
    }
}
