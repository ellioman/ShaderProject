#pragma strict

var pickMaterials : Material[];
var currentMaterialID : int = 0;
var chooseMeshRenderer : SkinnedMeshRenderer;

function Start () {

}

function Update () {
	if(Input.GetMouseButtonDown(0)){
		if( GetComponent.<GUITexture>().HitTest(Input.mousePosition)){
			currentMaterialID ++;
			if(currentMaterialID >= pickMaterials.Length){
				currentMaterialID = 0;
			}
			chooseMeshRenderer.material = pickMaterials[currentMaterialID];
		}
	}
}