using UnityEngine;
using UnityEngine.UI;
using System.Collections;

public class BootScene : MonoBehaviour {
	
	[SerializeField] CanvasScaler CanvasScaler;
	[SerializeField] Canvas MainCanvas;

	// Use this for initialization
	void Start () {
		Application.targetFrameRate = 60;
		StartCoroutine(CoroutineStart());
	}

	private IEnumerator CoroutineStart() {
		GameSceneManager.Instance.Initialize();
		GameObjectCacheManager.Instance.Initialize();
		ResourceManager.Instance.Init();
		
		float factor = MainCanvas.scaleFactor;
		
		yield return StartCoroutine(UnityUtility.Instance.Init(factor));
	}
}
