using UnityEngine;
using System.Collections;

[ExecuteInEditMode]
public class CameraFader : MonoBehaviour
{
	#region Variables

	// Unity Editor Variables
	[Header("Bars Parameters")]
	[SerializeField] private Shader barsShader;
	[SerializeField] private AnimationCurve defaultBarsOpenCurve;
	[SerializeField] private AnimationCurve defaultBarsCloseCurve;

	[Header("Circle Parameters")]
	[SerializeField] private Shader circleShader;
	[SerializeField] private AnimationCurve defaultCircleOpenCurve;
	[SerializeField] private AnimationCurve defaultCircleCloseCurve;

	// Private Instance VariableS
	private bool isAnimating = false;
	private enum FadeStates { Circle, Bars, Nothing }
	private float positionX = 0.5f;
	private float positionY = 0.5f;
	private float animationVal = 0f;
	private FadeStates state = FadeStates.Nothing;
	private Vector4 ScreenResolution;

	// Properties
	private Material circleMaterial;
	private Material CircleMaterial
	{
		get
		{
			if (circleMaterial == null)
			{
				circleMaterial = new Material(circleShader);
				circleMaterial.hideFlags = HideFlags.HideAndDontSave;	
			}
			return circleMaterial;
		}
	}

	private Material barsMaterial;
	private Material BarsMaterial
	{
		get
		{
			if (barsMaterial == null)
			{
				barsMaterial = new Material(barsShader);
				barsMaterial.hideFlags = HideFlags.HideAndDontSave;	
			}
			return barsMaterial;
		}
	}

	#endregion

	#region Public Functions

	public void SetBarVal(float newVal)
	{
		if (isAnimating) StopAllCoroutines();
		state = FadeStates.Bars;
		animationVal = Mathf.Clamp01(newVal);
	}

	public void OpenBars(float durationSeconds, AnimationCurve curveToUse = null)
	{
		if (isAnimating) StopAllCoroutines();
		state = FadeStates.Bars;
		AnimationCurve curCurve = (curveToUse != null) ? curveToUse : defaultBarsOpenCurve;
		StartCoroutine(AnimationRoutine(durationSeconds, curCurve));
	}

	public void CloseBars(float durationSeconds, AnimationCurve curveToUse = null)
	{
		if (isAnimating) StopAllCoroutines();
		state = FadeStates.Bars;
		AnimationCurve curCurve = (curveToUse != null) ? curveToUse : defaultBarsCloseCurve;
		StartCoroutine(AnimationRoutine(durationSeconds, curCurve));
	}

	public void OpenCircle(float durationSeconds, Vector2 viewportPos, AnimationCurve curveToUse = null)
	{
		if (isAnimating) StopAllCoroutines();
		state = FadeStates.Circle;
		positionX = viewportPos.x;
		positionY = viewportPos.y;
		AnimationCurve curCurve = (curveToUse != null) ? curveToUse : defaultCircleOpenCurve;
		StartCoroutine(AnimationRoutine(durationSeconds, curCurve));
	}

	public void CloseCircle(float durationSeconds, Vector2 viewportPos, AnimationCurve curveToUse = null)
	{
		if (isAnimating) StopAllCoroutines();
		state = FadeStates.Circle;
		positionX = viewportPos.x;
		positionY = viewportPos.y;
		AnimationCurve curCurve = (curveToUse != null) ? curveToUse : defaultCircleCloseCurve;
		StartCoroutine(AnimationRoutine(durationSeconds, curCurve));
	}

	#endregion


	#region Private Functions

	private IEnumerator AnimationRoutine(float durationSeconds, AnimationCurve curveToUse)
	{
		isAnimating = true;
		animationVal = 0f;
		if (durationSeconds <= 0f)
		{
			animationVal = 1f;
		}
		else
		{
			float animationStatus = 0f;
			float startTime = Time.time;
			while (animationStatus < 1f)
			{
				animationStatus = (Time.time - startTime) / durationSeconds;
				animationVal = curveToUse.Evaluate(animationStatus * curveToUse[curveToUse.length - 1].time);
				yield return null;
			}
		}
		isAnimating = false;
	}

	#endregion


	#region MonoBehaviour

	private void Start() 
	{
		if (!SystemInfo.supportsImageEffects)
		{
			enabled = false;
			return;
		}
	}

	private void OnRenderImage (RenderTexture sourceTexture, RenderTexture destTexture)
	{
		if (state == FadeStates.Circle && circleShader != null)
		{
			CircleMaterial.SetFloat("_PositionX", positionX);
			CircleMaterial.SetFloat("_PositionY", positionY);

			float w = Screen.width + (Mathf.Abs(positionX * 2f - 1f) * Screen.width);
			float h = Screen.height + (Mathf.Abs(positionY * 2f - 1f) * Screen.height);
			float radius = 0.5f * Mathf.Sqrt(w * w + h * h);

			CircleMaterial.SetFloat("_Size", animationVal * radius);
			CircleMaterial.SetVector("_ScreenResolution", new Vector2(Screen.width,Screen.height));
			Graphics.Blit(sourceTexture, destTexture, CircleMaterial);
		}
		else if (state == FadeStates.Bars && barsShader != null)
		{
			BarsMaterial.SetFloat("_ClosedVal", animationVal);
			Graphics.Blit(sourceTexture, destTexture, BarsMaterial);
		}
		else
		{
			Graphics.Blit(sourceTexture, destTexture);
		}
	}

	private void OnDisable()
	{
		if (circleMaterial)
		{
			DestroyImmediate(circleMaterial);	
		}
	}

	#endregion
}
