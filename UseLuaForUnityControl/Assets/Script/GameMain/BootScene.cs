using UnityEngine;
using System.Collections;

public class BootScene : MonoBehaviour {

	// Use this for initialization
	void Start () {
		GameSceneManager.Instance.Initialize();
		GameObjectCacheManager.Instance.Initialize();
		UnityUtility.Instance.Init();
	}
	
	// Update is called once per frame
	void Update () {
	}
}
