#pragma strict

var buttonList : buttonPosition[];
var startPosition : Vector2;
var separation : float;
var minButtonSize : float = 0.99;
var buttonSize : float = 200.0;
var mouseInfluence : float = 0.7;

function Start () {

}

function Update () {
	var dynamicSeparation : float = 0.0;
	for(var i = 0; i < buttonList.Length; i++){
		buttonList[i].buttonPosition.x = startPosition.x;
		buttonList[i].buttonPosition.y = startPosition.y + dynamicSeparation;
		
		buttonList[i].yPositionFromTop = true;
		var buttonPosition : Vector3;
		buttonPosition.x = buttonList[i].getGuiTexture.pixelInset.x - buttonList[i].getGuiTexture.texture.width * 0.5;
		buttonPosition.y = buttonList[i].getGuiTexture.pixelInset.y + buttonList[i].getGuiTexture.texture.height * 0.5;
		var mouseDistance : float = Vector3.Distance(Input.mousePosition, buttonPosition);
		var buttonSize : float = buttonSize/ Mathf.Max(mouseDistance/mouseInfluence,buttonSize);
		buttonSize = Mathf.Max(buttonSize, minButtonSize);
		buttonList[i].buttonSize = buttonSize;
		dynamicSeparation += separation * buttonSize;
	}
}