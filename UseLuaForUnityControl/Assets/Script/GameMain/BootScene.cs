using UnityEngine;
using UnityEngine.UI;
using System.Collections;

public class BootScene : MonoBehaviour {
	
	[SerializeField] CanvasScaler CanvasScaler;

	// Use this for initialization
	void Start () {
		GameSceneManager.Instance.Initialize();
		GameObjectCacheManager.Instance.Initialize();
		UnityUtility.Instance.Init();
		UnityUtility.Instance.SetUnityData(CanvasScaler.referenceResolution);
	}
	
	// Update is called once per frame
	void Update () {
	}
}
