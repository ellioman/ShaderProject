#pragma strict

@script RequireComponent(buttonPosition);
@script RequireComponent(GUITexture);

private var flashStartTime : float;
private var changeCurve : AnimationCurve;

function Start () {
	changeCurve = new AnimationCurve(Keyframe(0.0,0.0), Keyframe(0.1,0.3), Keyframe(0.3,-0.1), Keyframe(0.6,0.0));
}

function Update () {
	if(Input.GetMouseButtonDown(0)){
		if( GetComponent.<GUITexture>().HitTest(Input.mousePosition)){
			flashStartTime = Time.time;
		}
	}
	
	var buttonPositionScript : buttonPosition = GetComponent(buttonPosition);
	var sizeChange : float;
	if(Time.time > flashStartTime && Time.time < flashStartTime + changeCurve.length){
		var elapsedTime : float = Time.time - flashStartTime;
		//Size.
		sizeChange = changeCurve.Evaluate(elapsedTime);
		buttonPositionScript.buttonSize += sizeChange;
		//Color.
		var colorChange : float = 0.5 + changeCurve.Evaluate(elapsedTime) * 0.3;
		var colorChangeBlue : float = 0.5 + changeCurve.Evaluate(elapsedTime) * 0.5;
		GetComponent.<GUITexture>().color = Color(colorChange, colorChange, colorChangeBlue);
	}
}