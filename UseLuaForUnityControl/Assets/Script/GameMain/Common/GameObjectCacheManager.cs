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
	Dictionary<string, GameObject> GameObjectCacheDict = new Dictionary<string, GameObject>();
	/// <summary>
	/// シーンマネージャ初期化処理
	/// </summary>
	public void Initialize()	{
		DontDestroyOnLoad(this);
	}
	
	public GameObject FindGameObject(string objectName) {
		GameObject output = null;
		if (GameObjectCacheDict.TryGetValue(objectName, out output)) {
			return output;
		}

		output = GameObject.Find(objectName);
		return output;
	}
}
