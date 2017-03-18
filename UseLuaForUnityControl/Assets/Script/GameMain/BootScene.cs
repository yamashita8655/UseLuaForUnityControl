using UnityEngine;
using UnityEngine.UI;
using System.Collections;
using System.Collections.Generic;

public class BootScene : MonoBehaviour {

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

	string ServerVersionString = "";
	string LocalVersionString = "";

	string ServerURL = "http://natural-nail-eye.sakura.ne.jp";

	// Use this for initialization
	void Start () {
		Application.targetFrameRate = 60;
		StartCoroutine(CoroutineStart());
	}

	private IEnumerator CoroutineStart() {
		GameSceneManager.Instance.Initialize();
		GameObjectCacheManager.Instance.Initialize();
		AssetBundleManager.Instance.Initialize();
		ResourceManager.Instance.Init();
		RijindaelManager.Instance.Init();
		VersionFileManager.Instance.Initialize();

		LoadServerVersionFile();
		
		yield return null;
	}
	
	public void LoadServerVersionFile() {
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
			VersionFileManager.Instance.GetServerVersionString(url, (string output) => {
				if (output == null) {
					RetryText.text = "失敗しました、通信ができる環境で再度お試しください。";
					RetryButton.interactable = true;
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
		if (UnityUtility.IsCheckVersionFile == false) {
			CheckVersionFile();
		} else {
			string path = "";
#if UNITY_EDITOR
			path = Application.persistentDataPath;
#elif UNITY_ANDROID
			path = Application.persistentDataPath;
#elif UNITY_IPHONE
			path = Application.persistentDataPath;
#endif
			VersionFileManager.Instance.GetLocalVersionString(path, (string output) => {
				LocalVersionString = output;
				Debug.Log(LocalVersionString);
				CheckVersionFile();
			});
		}

//		if (UnityUtility.IsEditor == true) {
//			// ローカルリソースから読み込み
//#if UNITY_EDITOR
////			var localVersion = UnityEditor.AssetDatabase.LoadAssetAtPath<TextAsset>("Assets/AssetBundles/Android/version.txt");
////			LocalVersionString = localVersion.text;
//#endif
//			CheckVersionFile();
//		} else {
//			string path = "";
//#if UNITY_EDITOR
//			path = Application.persistentDataPath + "/" + "Android";
//#elif UNITY_ANDROID
//			path = Application.persistentDataPath + "/" + "Android";
//#elif UNITY_IPHONE
//			path = Application.persistentDataPath + "/" + "IOS";
//#endif
//			VersionFileManager.Instance.GetLocalVersionString(path, (string output) => {
//				LocalVersionString = output;
//				CheckVersionFile();
//			});
//		}
	}
	
	public void CheckVersionFile() {
		Debug.Log("CheckVersionFile");
		string path = "";
#if UNITY_EDITOR
		path = Application.persistentDataPath;
#elif UNITY_ANDROID
		path = Application.persistentDataPath;
#elif UNITY_IPHONE
		path = Application.persistentDataPath;
#endif

		// バージョンチェックしない場合は、ローカルは空にしている。この場合、サーバーと言っているが、最新のローカルバージョンファイルを参照している（ややこしいけど…
		if (string.IsNullOrEmpty(LocalVersionString)) {
			// LuaMainファイルだけまずダウンロード
#if UNITY_EDITOR
			string url = "";
			if (UnityUtility.IsUseLocalAssetBundle = true) {
				url = "file:///" + Application.dataPath + "/AssetBundles";
			} else {
				url = ServerURL;
			}
#else
			string url = ServerURL;
#endif
			string savePath = "";
#if UNITY_EDITOR
			savePath = Application.persistentDataPath;
			url += "/" + "Android/luamain";
#elif UNITY_ANDROID
			savePath = Application.persistentDataPath;
			url += "/" + "Android/luamain";
#elif UNITY_IPHONE
			savePath = Application.persistentDataPath;
			url += "/" + "IOS/luamain";
#endif
			
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
		
		} else {
			Dictionary<string, AssetBundleData> localDict = CreateVersionDataDict(LocalVersionString);
			Dictionary<string, AssetBundleData> serverDict = CreateVersionDataDict(ServerVersionString);
			AssetBundleData localVersion = null;
			localDict.TryGetValue("version", out localVersion);
			AssetBundleData serverVersion = null;
			serverDict.TryGetValue("version", out serverVersion);

			if (localVersion.Version == serverVersion.Version) {
				// バージョン同じなので、ローカルのデータを参照してゲーム始める
				int i = 0;
			} else {
				// 差分チェックして、更新があるデータをダウンロードして、バージョンファイルを保存する
				VersionFileManager.Instance.SaveVersionString(path, ServerVersionString);
			}
		}









//		string path = "";
//#if UNITY_EDITOR
//		path = Application.persistentDataPath + "/" + "Android";
//#elif UNITY_ANDROID
//		path = Application.persistentDataPath + "/" + "Android";
//#elif UNITY_IPHONE
//		path = Application.persistentDataPath + "/" + "IOS";
//#endif
//
//		// バージョンチェックしない場合は、ローカルは空にしている。この場合、サーバーと言っているが、最新のローカルバージョンファイルを参照している（ややこしいけど…
//		if (string.IsNullOrEmpty(LocalVersionString)) {
//			// LuaMainファイルだけまずダウンロード
//#if UNITY_EDITOR
//			string url = "";
//			if (UnityUtility.IsEditor = true) {
//				url = "file:///C:/yamashita/github/UseLuaForUnityControl/UseLuaForUnityControl/Assets/AssetBundles";
//			} else {
//				url = ServerURL;
//			}
//#else
//			string url = ServerURL;
//#endif
//			string savePath = "";
//#if UNITY_EDITOR
//			savePath = Application.persistentDataPath + "/Android";
//			url += "/" + "Android/luamain";
//#elif UNITY_ANDROID
//			savePath = Application.persistentDataPath + "/Android";
//			url += "/" + "Android/luamain";
//#elif UNITY_IPHONE
//			savePath = Application.persistentDataPath + "/IOS";
//			url += "/" + "IOS/luamain";
//#endif
//			
//			// バージョンファイルがなかったら、ロードじゃなくてセーブの方にする
//			AssetBundleManager.Instance.SaveAssetBundle(url, savePath, "luamain", (AssetBundle assetBundle, string error) => {
//				TextAsset resultObject = assetBundle.LoadAsset<TextAsset>("LuaMain");
//				System.IO.StreamWriter sw = new System.IO.StreamWriter(
//					savePath+"/LuaMain.lua",
//					false, 
//					System.Text.Encoding.UTF8
//				);
//				sw.Write(resultObject.text);
//				sw.Close();
//				//assetBundle.Unload(false);
//
//				StartCoroutine(LuaInit());
//			});
//		
//		} else {
//			Dictionary<string, AssetBundleData> localDict = CreateVersionDataDict(LocalVersionString);
//			Dictionary<string, AssetBundleData> serverDict = CreateVersionDataDict(ServerVersionString);
//			AssetBundleData localVersion = null;
//			localDict.TryGetValue("version", out localVersion);
//			AssetBundleData serverVersion = null;
//			serverDict.TryGetValue("version", out serverVersion);
//
//			if (localVersion.Version == serverVersion.Version) {
//				// バージョン同じなので、ローカルのデータを参照してゲーム始める
//				int i = 0;
//			} else {
//				// 差分チェックして、更新があるデータをダウンロードして、バージョンファイルを保存する
//				VersionFileManager.Instance.SaveVersionString(path, ServerVersionString);
//			}
//		}
	}

	public void OnClickRetryButton() {
		LoadServerVersionFile();
		RetryText.text = "サーバーデータアクセス中";
		RetryButton.interactable = false;
	}
	
	IEnumerator LuaInit() {
		float factor = MainCanvas.scaleFactor;
		yield return StartCoroutine(UnityUtility.Instance.Init(factor, LocalVersionString, ServerVersionString));
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
}
