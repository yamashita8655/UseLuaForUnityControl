using UnityEngine;
using System;
using System.Collections;
using System.IO;
using System.Collections.Generic;

public class AssetBundleManager : SingletonMonoBehaviour<AssetBundleManager> {

	// 読み込むファイルパスリスト。このリストの頭から一件ずつ処理していく
	private Dictionary<string, AssetBundle> AssetBundleCacheDict = new Dictionary<string, AssetBundle>();
	Action<AssetBundle, string> EndCallback = null;

	public void Initialize() {
		DontDestroyOnLoad(this);
	}
	
	void Update() {
	}

	public void SaveAssetBundle(string loadPath, string savePath, string assetBundleName, Action<AssetBundle, string> endCallback) {
		StartCoroutine(SaveAssetBundleCoroutine(loadPath, savePath, assetBundleName, endCallback));
	}

	private IEnumerator SaveAssetBundleCoroutine(string loadPath, string savePath, string assetBundleName, Action<AssetBundle, string> endCallback) {
		WWW www = new WWW(loadPath);
		while (www.isDone == false) {
			yield return null;
		}

		if (string.IsNullOrEmpty(www.error) == false) {
			Debug.Log(www.error);
			yield break;
		}

		AssetBundle assetBundle = www.assetBundle;
		AssetBundleCacheDict.Add(assetBundleName, assetBundle);
		File.WriteAllBytes(savePath+"/"+assetBundleName, www.bytes);
		endCallback(assetBundle, www.error);
	}

	public void LoadAssetBundle(string assetBundlePathAndName, string assetBundleName, Action<AssetBundle, string> endCallback) {
		AssetBundle output = null;
		if (AssetBundleCacheDict.TryGetValue (assetBundleName, out output) == true) {
			endCallback(output, "");
		} else {
			EndCallback = endCallback;
			StartCoroutine(LoadAssetBundleCoroutine(assetBundlePathAndName, assetBundleName));
		}
	}
	
	public AssetBundle GetAssetBundle(string assetBundleName) {
		AssetBundle output = null;
		if (AssetBundleCacheDict.TryGetValue (assetBundleName, out output) == false) {
			return null;
		}
		
		return output;
	}
				
	private IEnumerator LoadAssetBundleCoroutine(string assetBundlePathAndName, string assetBundleName) {
		WWW www = new WWW (assetBundlePathAndName);
		while (www.isDone == false) {
			yield return null;
		}

		if (string.IsNullOrEmpty(www.error) == false) {
			EndCallback(null, www.error);
			yield break;
		}

		AssetBundle assetBundle = www.assetBundle;
		AssetBundleCacheDict.Add(assetBundleName, assetBundle);
		EndCallback(assetBundle, www.error);
	}
}

