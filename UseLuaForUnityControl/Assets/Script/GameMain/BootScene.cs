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
		string url = "";
#if UNITY_EDITOR
		url = "http://natural-nail-eye.sakura.ne.jp/Android";
#elif UNITY_ANDROID
		url = "http://natural-nail-eye.sakura.ne.jp/Android";
#elif UNITY_IPHONE
		url = "http://natural-nail-eye.sakura.ne.jp/IOS";
#endif
		VersionFileManager.Instance.GetServerVersionString(url, (string output) => {
			if (output == null) {
				RetryText.text = "失敗しました、通信ができる環境で再度お試しください。";
				RetryButton.interactable = true;
				return;
			}
			
			ServerVersionString = output;
			LoadLocalVersionFile();
		});
	}
	
	public void LoadLocalVersionFile() {
		string path = "";
#if UNITY_EDITOR
		path = Application.persistentDataPath + "/" + "Android";
#elif UNITY_ANDROID
		path = Application.persistentDataPath + "/" + "Android";
#elif UNITY_IPHONE
		path = Application.persistentDataPath + "/" + "IOS";
#endif
		VersionFileManager.Instance.GetLocalVersionString(path, (string output) => {
			LocalVersionString = output;
			CheckVersionFile();
		});
	}
	
	public void CheckVersionFile() {
		string path = "";
#if UNITY_EDITOR
		path = Application.persistentDataPath + "/" + "Android";
#elif UNITY_ANDROID
		path = Application.persistentDataPath + "/" + "Android";
#elif UNITY_IPHONE
		path = Application.persistentDataPath + "/" + "IOS";
#endif

		if (string.IsNullOrEmpty(LocalVersionString)) {
			// サーバーから落としたバージョン情報をローカルに保存し、その情報でアセットバンドルダウンロード
			VersionFileManager.Instance.SaveVersionString(path, ServerVersionString);
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
	}

	public void OnClickRetryButton() {
		LoadServerVersionFile();
		RetryText.text = "サーバーデータアクセス中";
		RetryButton.interactable = false;
	}
	
	IEnumerator LuaInit() {
		float factor = MainCanvas.scaleFactor;
		yield return StartCoroutine(UnityUtility.Instance.Init(factor));
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
