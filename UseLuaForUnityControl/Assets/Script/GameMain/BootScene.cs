using UnityEngine;
using UnityEngine.UI;
using System.Collections;

public class BootScene : MonoBehaviour {
	
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
		});
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
}
