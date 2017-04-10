using UnityEngine;
using System;
using System.Collections;
using System.IO;
using System.Collections.Generic;

public class VersionFileManager : SingletonMonoBehaviour<VersionFileManager> {

	private Action<string, string> EndCallback = null;
	private string LocalPath = "";
	private string ServerUrl = "";
	private string ApplicationVersionPath = "";

	public void Initialize() {
		DontDestroyOnLoad(this);
	}
	
	public void GetApplicationVersionString(string applicationVersionPath, Action<string, string> endCallback) {
		StartCoroutine(GetApplicationVersionStringCoroutine(applicationVersionPath, endCallback));
	}
	
	private IEnumerator GetApplicationVersionStringCoroutine(string applicationVersionPath, Action<string, string> endCallback) {
		string output = "";
		string error = "";

		// データが存在するので、そっち読み込む
		WWW www = new WWW (applicationVersionPath + "/appVersion.txt");
		while (www.isDone == false) {
			yield return null;
		}
		
		if (string.IsNullOrEmpty(www.error) == false) {
			error = www.error;
		}

		output = www.text;
		if (endCallback != null) {
			endCallback(output, error);
		}
	}

	public void GetLocalVersionString(string localPath, Action<string, string> endCallback) {
		LocalPath = localPath;
		EndCallback = endCallback;
		StartCoroutine(LoadLocalVersionString());
	}
	
	public void GetServerVersionString(string serverUrl, Action<string, string> endCallback) {
		ServerUrl = serverUrl;
		EndCallback = endCallback;
		StartCoroutine(LoadServerVersionString());
	}
	
	private IEnumerator LoadLocalVersionString() {
		string output = "";
		string error = "";
		if (System.IO.File.Exists(LocalPath + "/version") == true) {
#if UNITY_EDITOR
			LocalPath = "file:///" + LocalPath;
#elif UNITY_ANDROID
			LocalPath = "file:///" + Application.persistentDataPath;
#elif UNITY_IPHONE
			//LocalPath = Application.persistentDataPath;
			LocalPath = "file:///" + Application.persistentDataPath;
#endif
			// データが存在するので、そっち読み込む
			WWW www = new WWW (LocalPath + "/version");
			while (www.isDone == false) {
				yield return null;
			}
		
			if (string.IsNullOrEmpty(www.error) == false) {
				error = www.error;
			}
			
			output = www.text;
		} else {
			// ファイルが無いのは想定内。初回起動等の時は、当然存在しない
		}

		EndCallback(output, error);
	}

	private IEnumerator LoadServerVersionString() {
		string output = "";
		string error = "";
		Debug.Log("LoadServerVersionString:Start");

		// データが存在するので、そっち読み込む
		WWW www = new WWW (ServerUrl + "/version");
		while (www.isDone == false) {
			yield return null;
		}
		
		if (string.IsNullOrEmpty(www.error) == false) {
			error = www.error;
		}

		output = www.text;
		EndCallback(output, error);
	}
	
	public string SaveVersionString(string path, string src) {
		string error = "";
		if (System.IO.Directory.Exists(path) == false) {
			System.IO.Directory.CreateDirectory(path);
		}
		path = path + "/version";
		try {
			File.WriteAllText(path, src, new System.Text.UTF8Encoding(false));
		} catch (IOException e) {
			error = e.ToString();
		}

		return error;
	}
}

