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
public class GameObjectCacheManager : Singleton<GameObjectCacheManager>
{
	Dictionary<string, GameObject> RowGameObjectCacheDict = new Dictionary<string, GameObject>();
	Dictionary<string, GameObject> InstantiateGameObjectCacheDict = new Dictionary<string, GameObject>();
	/// <summary>
	/// シーンマネージャ初期化処理
	/// </summary>
	public void Initialize()	{
		DontDestroyOnLoad(this);
	}
	
	public GameObject FindGameObject(string objectName) {
		GameObject output = null;
		if (InstantiateGameObjectCacheDict.TryGetValue(objectName, out output)) {
			return output;
		}

		output = GameObject.Find(objectName);
		InstantiateGameObjectCacheDict.Add(objectName, output);
		return output;
	}
	
	public GameObject LoadGameObject(string loadPath, string objectName) {
		GameObject output = null;
		GameObject obj = null;
		if (RowGameObjectCacheDict.TryGetValue(loadPath, out obj)) {
		} else {
			obj = Resources.Load<GameObject>(loadPath);
			RowGameObjectCacheDict.Add(loadPath, obj);
		}
		
		output = UnityEngine.Object.Instantiate(obj) as GameObject;
		if (objectName != "") {
			output.name = objectName;
		} else {
			output.name = output.name.Replace("(Clone)", "");
		}
		InstantiateGameObjectCacheDict.Add(output.name, output);
		
		return output;
	}
	
	public void RemoveGameObject(string objectName) {
		GameObject output = null;
		if (InstantiateGameObjectCacheDict.TryGetValue(objectName, out output) == false) {
			return;
		}
		InstantiateGameObjectCacheDict.Remove(objectName);
		Destroy(output);
	}
}
