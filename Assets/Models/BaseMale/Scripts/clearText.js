#pragma strict
@script RequireComponent(GUIText);
function Start () {

}

function Update () {
	GetComponent.<GUIText>().text = "";
}