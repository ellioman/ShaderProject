#pragma strict

@script RequireComponent(GUITexture);

var animationChange : Animation;
var animationName : String;
var currentAnimation : String = "tPose";
var matchNormalizedTime : boolean = true;

function Start () {

}

function Update () {
	if(Input.GetMouseButtonDown(0)){
		if( GetComponent.<GUITexture>().HitTest(Input.mousePosition)){
			animationChange.CrossFade(animationName);
			if(matchNormalizedTime){
				//animationChange[animationName].normalizedTime = animationChange[currentAnimation].normalizedTime;
			}
			transform.parent.BroadcastMessage("SetCurrentAnimation", animationName);
		}
	}
}

function SetCurrentAnimation(newAnimationName : String){
	currentAnimation = newAnimationName;
}