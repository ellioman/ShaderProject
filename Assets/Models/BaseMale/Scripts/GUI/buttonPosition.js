#pragma strict
@script RequireComponent(GUITexture)

var yPositionFromTop : boolean = true;
var xPositionFromRight : boolean = false;
var buttonPosition : Vector2;
var buttonSize : float = 1.0;
var getGuiTexture : GUITexture;

function Start () {
	getGuiTexture = GetComponent(GUITexture);
	transform.position = Vector3.zero;
}

function Update () {
	if(xPositionFromRight){
		GetComponent.<GUITexture>().pixelInset.x = Screen.width - buttonPosition.x - GetComponent.<GUITexture>().texture.width * .5 * buttonSize;
	}
	else{
		GetComponent.<GUITexture>().pixelInset.x = buttonPosition.x - GetComponent.<GUITexture>().texture.width * .5 * buttonSize;
	}
	if(yPositionFromTop){
		GetComponent.<GUITexture>().pixelInset.y = Screen.height - buttonPosition.y - GetComponent.<GUITexture>().texture.height * .5 * buttonSize;
	}
	else{
		GetComponent.<GUITexture>().pixelInset.y = buttonPosition.y - GetComponent.<GUITexture>().texture.height * .5 * buttonSize;
	}
	GetComponent.<GUITexture>().pixelInset.width = GetComponent.<GUITexture>().texture.width * buttonSize;
	GetComponent.<GUITexture>().pixelInset.height = GetComponent.<GUITexture>().texture.height * buttonSize;
}