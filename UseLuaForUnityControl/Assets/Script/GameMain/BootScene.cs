using UnityEngine;
using UnityEngine.UI;
using System.Collections;

public class BootScene : MonoBehaviour {
	
	[SerializeField] CanvasScaler CanvasScaler;
	[SerializeField] Canvas MainCanvas;

	// Use this for initialization
	void Start () {
		GameSceneManager.Instance.Initialize();
		GameObjectCacheManager.Instance.Initialize();
		UnityUtility.Instance.Init();
		float factor = MainCanvas.scaleFactor;
		UnityUtility.Instance.SetUnityData(factor);
	}
	
	// Update is called once per frame
	void Update () {
	}
}
