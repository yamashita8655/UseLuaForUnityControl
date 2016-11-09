/*
 * シーンマネージャ
 */

using UnityEngine;
using UnityEngine.SceneManagement;
using System.Text;
using System.Collections;
using System.Collections.Generic;
using System;

/// <summary>
/// シーンの管理を行う
/// シーンの切り替えを行うが、基本的にはサブシーンの切り替えに使う事が多いと思う。
/// </summary>
public class GameSceneManager : Singleton<GameSceneManager>
{
	Dictionary<string, GameObject> SceneCacheDict = new Dictionary<string, GameObject>();
	GameObject CurrentSceneObject = null;

		private readonly string SceneObjectPath = "Prefabs/{0}Scene";

	/// <summary>
	/// シーンマネージャ初期化処理
	/// </summary>
	public void Initialize()	{
		DontDestroyOnLoad(this);
	}
	
	/// <summary>
	/// シーン切り替え
	/// </summary>
	public void ChangeScene(string sceneName, GameObject parent) {
		if (CurrentSceneObject != null) {
			CurrentSceneObject.SetActive(false);
		}
		
		GameObject nextSceneObject = null;
		if (SceneCacheDict.TryGetValue(sceneName, out nextSceneObject)) {
		} else {
			string path = string.Format(SceneObjectPath, sceneName);
			GameObject loadObj = Resources.Load<GameObject>(path);
			nextSceneObject = Instantiate(loadObj);
			nextSceneObject.transform.SetParent(parent.transform);
			nextSceneObject.transform.localPosition = Vector3.zero;
			nextSceneObject.transform.localScale = Vector3.one;
			SceneCacheDict.Add(sceneName, nextSceneObject);
		}
		
		nextSceneObject.SetActive(true);
		CurrentSceneObject = nextSceneObject;
	}
}
