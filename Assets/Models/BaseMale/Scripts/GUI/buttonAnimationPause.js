@script RequireComponent(GUITexture);

var sampleAnimation : Animation;
var animationSpeed : float = 1.0;
var animationSpeedTarget : float = 1.0;
var pauseSpeed : float = 10.0;

function Start () {

}

function Update () {
	if(Input.GetMouseButtonDown(0) && GetComponent.<GUITexture>().HitTest(Input.mousePosition)){
		if(animationSpeedTarget > 0.9){
			animationSpeedTarget = 0.0; 
		}
		else{
			if(animationSpeedTarget < 0.1){
				animationSpeedTarget = 1.0;
			}
		}
	}
	animationSpeed = Mathf.Lerp(animationSpeed, animationSpeedTarget, Time.deltaTime * pauseSpeed);
	for (var state : AnimationState in sampleAnimation) {
  		  state.speed = animationSpeed;
	}
}