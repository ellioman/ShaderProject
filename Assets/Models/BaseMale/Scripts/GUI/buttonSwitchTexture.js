#pragma strict
@script RequireComponent(GUITexture);

var textureList : Texture[];
var currentTextureID : int = 0;

function Start () {

}

function Update () {
	if(Input.GetMouseButtonDown(0) && GetComponent.<GUITexture>().HitTest(Input.mousePosition)){
		currentTextureID ++;
		if(currentTextureID >= textureList.Length){
			currentTextureID = 0;
		}
		GetComponent.<GUITexture>().texture = textureList[currentTextureID];
	}
}