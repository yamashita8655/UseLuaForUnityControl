using UnityEngine;
using UnityEngine.UI;
using System;
using System.IO;
using System.Collections;
using System.Collections.Generic;

public class AssetbundleLoadTest : MonoBehaviour {

	[SerializeField] Text output;

	// Use this for initialization
	void Start () {
		//SimpleAssetBundleLoadTest();
		StartCoroutine (SimpleWWWLoadForAssetBundle());
		//StartCoroutine (LocalAssetBundleFileLoadTest());
		//UseAssetBundleManager();
		//StartCoroutine(VersionFileDownload());
	}

	void SimpleAssetBundleLoadTest() {
//		AssetBundle resultAssetbundle = AssetBundle.LoadFromFile("C:/yamashita/github/UseLuaForUnityControl/UseLuaForUnityControl/Assets/AssetBundles/Android/luascript");
//		TextAsset resultObject = resultAssetbundle.LoadAsset<TextAsset> ("DialogManager");
//		Debug.Log(resultObject.text);
//		resultAssetbundle.Unload (false);
	}

	IEnumerator SimpleWWWLoadForAssetBundle() {
		WWW www = new WWW ("http://natural-nail-eye.sakura.ne.jp/Android/luascript");
		while (www.isDone == false) {
			yield return null;
		}

		AssetBundle assetbBundle = www.assetBundle;
		TextAsset resultObject = assetbBundle.LoadAsset<TextAsset> ("DialogManager");
		Debug.Log(resultObject.text);
		output.text = resultObject.text;
//		byte[] saveByte = System.Text.Encoding.UTF8.GetBytes(resultObject.text);
//		File.WriteAllBytes("C:/yamashita/github/UseLuaForUnityControl/UseLuaForUnityControl/Assets/AssetBundleSaveFile/Android/DialogManager.lua", saveByte);
		System.IO.StreamWriter sw = new System.IO.StreamWriter(
						"C:/yamashita/github/UseLuaForUnityControl/UseLuaForUnityControl/Assets/AssetBundleSaveFile/Android/DialogManager.lua", 
						false, 
						System.Text.Encoding.UTF8
		);
		sw.Write(resultObject.text);
		sw.Close();
		assetbBundle.Unload (false);

	}

	IEnumerator LocalAssetBundleFileLoadTest() {
		WWW www = new WWW ("file:///" + Application.streamingAssetsPath + "/Android/Common");
		while (www.isDone == false) {
			yield return null;
		}

		AssetBundle assetbBundle = www.assetBundle;
		GameObject rowObj = assetbBundle.LoadAsset<GameObject>("OkCancelDialog");
		GameObject dialog = Instantiate(rowObj) as GameObject;
	}	
	
	void UseAssetBundleManager() {
		AssetBundleManager.Instance.LoadAssetBundle (
			"file:///" + Application.streamingAssetsPath + "/Android/common",
			"common",
			(AssetBundle assetBundle, string error) => {
				if (assetBundle == null) {
					Debug.Log("error");
				}
			}
		);
	}
	
	IEnumerator VersionFileDownload() {
		WWW www = new WWW ("http://natural-nail-eye.sakura.ne.jp/Android/version");
		while (www.isDone == false) {
			yield return null;
		}

		string version = www.text;
		output.text = version;
	}
	
	// Update is called once per frame
	void Update () {
		if (Input.GetKeyDown (KeyCode.A)) {
		}
	}
}
