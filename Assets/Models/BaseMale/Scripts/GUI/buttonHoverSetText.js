#pragma strict

@script RequireComponent(GUITexture);

var chooseText : GUIText;
var textValue : String;
var offset : float = 30;

function Start () {
}

function Update () {
	if(GetComponent.<GUITexture>().HitTest(Input.mousePosition)){
		chooseText.text = textValue;
		chooseText.pixelOffset.x = Input.mousePosition.x + offset;
		chooseText.pixelOffset.y = Input.mousePosition.y;
	}
}