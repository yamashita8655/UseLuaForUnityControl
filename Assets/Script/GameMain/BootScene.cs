﻿using UnityEngine;
using UnityEngine.UI;
using System.IO;
using System.Collections;
using System.Collections.Generic;

public class BootScene : MonoBehaviour {

	private readonly int AppicationVersion = 2;

	class AssetBundleData {
		public string AssetBundleName { get; set; }
		public string Version { get; set; }
		public string Hash { get; set; }

		public AssetBundleData() {
		}
	}
	
	[SerializeField] CanvasScaler CanvasScaler;
	[SerializeField] Canvas MainCanvas;

	[SerializeField] Button RetryButton;
	[SerializeField] Text RetryText;

	[SerializeField] GameObject InAppObject;
	[SerializeField] GameObject LoadingObject;
	[SerializeField] GameObject SliderObject;

	string ServerVersionString = "";
	string LocalVersionString = "";

	//string ServerURL = "http://natural-nail-eye.sakura.ne.jp";
	string ServerURL = "http://natural-nail-eye.sakura.ne.jp/20170809";
	
	private enum FuncState {
		None = 0,
		GetApplicationVersionString = 1,
		GetServerVersionString = 2,
	};

	private FuncState State = FuncState.None;

	// Use this for initialization
	void Start () {
		Application.targetFrameRate = 60;
		RetryButton.gameObject.SetActive(false);
		StartCoroutine(CoroutineStart());
#if UNITY_EDITOR
		Debug.logger.logEnabled = false;
#else
		Debug.logger.logEnabled = false;
#endif
	}

	private IEnumerator CoroutineStart() {
		GameSceneManager.Instance.Initialize();
		GameObjectCacheManager.Instance.Initialize();
		AssetBundleManager.Instance.Initialize();
		ResourceManager.Instance.Init();
		RijindaelManager.Instance.Init();
		VersionFileManager.Instance.Initialize();
		SoundManager.Instance.Initialize();

		if (UnityUtility.IsUseLocalFile == true) {
			StartCoroutine(LuaInit());
		} else {
			CheckApplicationVersion();
		}
		//LoadServerVersionFile();
		
		yield return null;
	}
	
	public void CheckApplicationVersion() {
		State = FuncState.GetApplicationVersionString;
		RetryText.text = "アプリケーションバージョンチェック中";
		string url = "";
#if UNITY_EDITOR
		url = ServerURL + "/Android";
#elif UNITY_ANDROID
		url = ServerURL + "/Android";
#elif UNITY_IPHONE
		url = ServerURL + "/IOS";
#endif
		VersionFileManager.Instance.GetApplicationVersionString(url, (string output, string error) => {
			if (string.IsNullOrEmpty(error) == false) {
				RetryText.text = "通信に失敗しました、通信環境がよい所で再度お試しください。";
				RetryButton.gameObject.SetActive(true);
				LoadingObject.gameObject.SetActive(false);
				return;
			}

			if (AppicationVersion != int.Parse(output)) {
				RetryText.text = "アプリケーションのバージョンが異なります。\n最新にアップデートして再起動してください。";
				LoadingObject.gameObject.SetActive(false);
				SliderObject.gameObject.SetActive(false);
				RetryButton.gameObject.SetActive(true);
			} else {
				LoadServerVersionFile();
			}
		});
	}
	
	public void LoadServerVersionFile() {
		State = FuncState.GetServerVersionString;
		RetryText.text = "サーバーのバージョンファイル取得中";
		LoadingObject.gameObject.SetActive(true);
		if (UnityUtility.IsCheckVersionFile == false) {
			// ローカルリソースから読み込み
#if UNITY_EDITOR
			var serverVersion = UnityEditor.AssetDatabase.LoadAssetAtPath<TextAsset>("Assets/AssetBundles/Android/version.txt");
			ServerVersionString = serverVersion.text;
#endif
			LoadLocalVersionFile();
		} else {
			string url = "";
#if UNITY_EDITOR
			url = ServerURL + "/Android";
#elif UNITY_ANDROID
			url = ServerURL + "/Android";
#elif UNITY_IPHONE
			url = ServerURL + "/IOS";
#endif
			VersionFileManager.Instance.GetServerVersionString(url, (string output, string error) => {
				if (string.IsNullOrEmpty(error) == false) {
					RetryText.text = "通信に失敗しました、通信環境がよい所で再度お試しください。";
					RetryButton.gameObject.SetActive(true);
					LoadingObject.gameObject.SetActive(false);
					return;
				}
				
				ServerVersionString = output;
				Debug.Log(ServerVersionString);
				LoadLocalVersionFile();
			});
		}


//		if (UnityUtility.IsEditor == true) {
//			// ローカルリソースから読み込み
//#if UNITY_EDITOR
//			var serverVersion = UnityEditor.AssetDatabase.LoadAssetAtPath<TextAsset>("Assets/AssetBundles/Android/version.txt");
//			ServerVersionString = serverVersion.text;
//#endif
//			LoadLocalVersionFile();
//		} else {
//			string url = "";
//#if UNITY_EDITOR
//			url = "http://natural-nail-eye.sakura.ne.jp/Android";
//#elif UNITY_ANDROID
//			url = "http://natural-nail-eye.sakura.ne.jp/Android";
//#elif UNITY_IPHONE
//			url = "http://natural-nail-eye.sakura.ne.jp/IOS";
//#endif
//			VersionFileManager.Instance.GetServerVersionString(url, (string output) => {
//				if (output == null) {
//					RetryText.text = "失敗しました、通信ができる環境で再度お試しください。";
//					RetryButton.interactable = true;
//					return;
//				}
//				
//				ServerVersionString = output;
//				LoadLocalVersionFile();
//			});
//		}
	}
	
	public void LoadLocalVersionFile() {
		RetryText.text = "アプリのバージョンファイル取得中";
		LoadingObject.gameObject.SetActive(true);
		if (UnityUtility.IsCheckVersionFile == false) {
			CheckVersionFile();
		} else {
			string path = "";
#if UNITY_EDITOR
			path = Application.persistentDataPath;
#elif UNITY_ANDROID
			//path = Application.persistentDataPath;
			path = UnityUtility.AndroidPersistentDataPath;
#elif UNITY_IPHONE
			path = Application.persistentDataPath;
#endif
			VersionFileManager.Instance.GetLocalVersionString(path, (string output, string error) => {
				if (string.IsNullOrEmpty(error) == false) {
					ExeptionHandle(error, 0);
				} else {
					LocalVersionString = output;
					Debug.Log(LocalVersionString);
					CheckVersionFile();
				}
			});
		}
	}
	
	public void CheckVersionFile() {
		RetryText.text = "バージョンチェック中";
		LoadingObject.gameObject.SetActive(true);
		Debug.Log("CheckVersionFile");
		string path = "";
#if UNITY_EDITOR
		path = Application.persistentDataPath;
#elif UNITY_ANDROID
		//path = Application.persistentDataPath;
		path = UnityUtility.AndroidPersistentDataPath;
#elif UNITY_IPHONE
		path = Application.persistentDataPath;
#endif

#if UNITY_EDITOR
		string url = "";
		if (UnityUtility.IsUseLocalAssetBundle == true) {
			url = "file:///" + Application.dataPath + "/AssetBundles";
		} else {
			url = ServerURL;
		}
#else
		string url = ServerURL;
#endif
		string savePath = "";
		string loadPath = "";
#if UNITY_EDITOR
		savePath = Application.persistentDataPath;
		loadPath = "file:///" + Application.persistentDataPath;
		url += "/" + "Android/luamain";
#elif UNITY_ANDROID
		//savePath = Application.persistentDataPath;
		//loadPath = "file:///" + Application.persistentDataPath;
		savePath = UnityUtility.AndroidPersistentDataPath;
		loadPath = "file:///" + UnityUtility.AndroidPersistentDataPath;
		url += "/" + "Android/luamain";
#elif UNITY_IPHONE
		savePath = Application.persistentDataPath;
		loadPath = "file:///" + Application.persistentDataPath;
		url += "/" + "IOS/luamain";
#endif
		// バージョンチェックしない場合は、ローカルは空にしている。この場合、サーバーと言っているが、最新のローカルバージョンファイルを参照している（ややこしいけど…
		if (string.IsNullOrEmpty(LocalVersionString)) {
			// LuaMainファイルだけまずダウンロード
			
			// バージョンファイルがなかったら、ロードじゃなくてセーブの方にする
			AssetBundleManager.Instance.SaveAssetBundle(url, savePath, "luamain", (AssetBundle assetBundle, string error) => {
				if (string.IsNullOrEmpty(error) == false) {
					ExeptionHandle(error, 1);
				} else {
					TextAsset resultObject = assetBundle.LoadAsset<TextAsset>("LuaMain");
					try {
						System.IO.StreamWriter sw = new System.IO.StreamWriter(
							savePath+"/LuaMain.lua",
							false, 
							System.Text.Encoding.UTF8
						);
						sw.Write(resultObject.text);
						sw.Close();
					} catch (IOException e) {
						ExeptionHandle(e.ToString(), 2);
						return;
					}

					StartCoroutine(LuaInit());
				}
			});
		
		} else {
			Dictionary<string, AssetBundleData> localDict = CreateVersionDataDict(LocalVersionString);
			Dictionary<string, AssetBundleData> serverDict = CreateVersionDataDict(ServerVersionString);
			AssetBundleData localVersion = null;
			localDict.TryGetValue("version", out localVersion);
			AssetBundleData serverVersion = null;
			serverDict.TryGetValue("version", out serverVersion);

			if (localVersion.Version == serverVersion.Version) {
				// バージョン同じなので、ローカルのデータを参照してゲーム始める
				AssetBundleManager.Instance.LoadAssetBundle(loadPath+"/luamain", "luamain", (AssetBundle assetBundle, string error) => {
					if (string.IsNullOrEmpty(error) == false) {
						ExeptionHandle(error, 6);
					} else {
						TextAsset resultObject = assetBundle.LoadAsset<TextAsset>("LuaMain");
						StartCoroutine(LuaInit());
					}
				});
			} else {
				// LuaMainに差分があるか確認する
				AssetBundleData localLuaMain = null;
				localDict.TryGetValue("luamain", out localLuaMain);
				AssetBundleData serverLuaMain = null;
				serverDict.TryGetValue("luamain", out serverLuaMain);

				if (localLuaMain.Version == serverLuaMain.Version) {
					// LuaMainのバージョン同じなので、LuaMainはそのまま実行する
					AssetBundleManager.Instance.LoadAssetBundle(loadPath+"/luamain", "luamain", (AssetBundle assetBundle, string error) => {
						TextAsset resultObject = assetBundle.LoadAsset<TextAsset>("LuaMain");
						StartCoroutine(LuaInit());
					});
				} else {
					// LuaMainを落としなおして、実行する
					// バージョンファイルがなかったら、ロードじゃなくてセーブの方にする
					AssetBundleManager.Instance.SaveAssetBundle(url, savePath, "luamain", (AssetBundle assetBundle, string error) => {
						TextAsset resultObject = assetBundle.LoadAsset<TextAsset>("LuaMain");
						System.IO.StreamWriter sw = new System.IO.StreamWriter(
							savePath+"/LuaMain.lua",
							false, 
							System.Text.Encoding.UTF8
						);
						sw.Write(resultObject.text);
						sw.Close();
						//assetBundle.Unload(false);

						StartCoroutine(LuaInit());
					});
				}
			}
		}
	}

	public void OnClickRetryButton() {
		if (State == FuncState.GetApplicationVersionString) {
#if UNITY_EDITOR
			Application.OpenURL("https://play.google.com/store/apps/details?id=com.mochimoffu.mofuneko");
#elif UNITY_ANDROID
			Application.OpenURL("https://play.google.com/store/apps/details?id=com.mochimoffu.mofuneko");
#elif UNITY_IPHONE
			Application.OpenURL("itms-apps://itunes.apple.com/app/id1247130262?mt=8");
#endif
			CheckApplicationVersion();
		} else if (State == FuncState.GetServerVersionString) {
			LoadServerVersionFile();
		}
//		RetryText.text = "サーバーデータアクセス中";
		RetryButton.gameObject.SetActive(false);
	}
	
	IEnumerator LuaInit() {
		float factor = MainCanvas.scaleFactor;
		yield return StartCoroutine(UnityUtility.Instance.Init(factor, LocalVersionString, ServerVersionString, ExeptionHandle, EndLuaMainInit));
	}
	
	Dictionary<string, AssetBundleData> CreateVersionDataDict(string src) {
		Dictionary<string, AssetBundleData> dict = new Dictionary<string, AssetBundleData>();
		string[] lineList = src.Split("\n"[0]);
		for (int i = 0; i < lineList.Length; i++) {
			string line = lineList[i];
			string[] param = line.Split(","[0]);
			if (param.Length < 3) {
				continue;
			}

			AssetBundleData data = new AssetBundleData();
			data.AssetBundleName = param[0];
			data.Version = param[1];
			data.Hash = param[2];
			dict.Add(data.AssetBundleName, data);
		}

		return dict;
	}

	// 例外検知して、ユーザーに伝える
	public void ExeptionHandle(string error, int errorNumber) { 
		InAppObject.SetActive(true);
		RetryText.text = string.Format ("下記のエラーが発生しました。\nアプリを再起動するか、問題が解決しない場合は、\nアプリ作成者にエラー内容を送ってください。\n{0}\nerrorNumber:{1}\n\n", error, errorNumber);
	}
	
	// Luaの初期化関数が終わった後のコールバック
	public void EndLuaMainInit() { 
	}
}
