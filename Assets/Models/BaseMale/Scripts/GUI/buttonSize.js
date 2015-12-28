#pragma strict
@script RequireComponent(buttonPosition);

private var buttonPositionScript : buttonPosition;
var buttonSize : float = 1.0;

function Start () {
	buttonPositionScript = GetComponent(buttonPosition);
}

function Update () {
	buttonPositionScript.buttonSize = buttonSize;
}