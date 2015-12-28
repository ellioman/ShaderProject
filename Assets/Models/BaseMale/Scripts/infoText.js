#pragma strict

@script RequireComponent(GUIText);

private var lastClickTime : float;
var acknowledgeDuration : float = 0.3;
var provideHelpTime : float = 3.0;
var helpText : String;

function Start () {

}

function Update () {
	if(Input.GetMouseButtonDown(0) || Input.GetMouseButtonDown(1)){
		lastClickTime = Time.time;
	}
	if(Input.GetMouseButton(0) || Input.GetMouseButton(1)){
		if(Time.time > lastClickTime + acknowledgeDuration){
			GetComponent.<GUIText>().text = "";
			Destroy(this.gameObject);
		}
	}
	if(Time.time > provideHelpTime){
		GetComponent.<GUIText>().text = helpText;
	}
	else{
		GetComponent.<GUIText>().text = "";
	}
	
}