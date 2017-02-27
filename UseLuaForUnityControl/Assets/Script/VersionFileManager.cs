using UnityEngine;
using System;
using System.Collections;
using System.IO;
using System.Collections.Generic;

public class VersionFileManager : SingletonMonoBehaviour<VersionFileManager> {

	private Action<string> EndCallback = null;
	private string LocalPath = "";
	private string ServerUrl = "";

	public void Initialize() {
		DontDestroyOnLoad(this);
	}

	public void GetLocalVersionString(string localPath, Action<string> endCallback) {
		LocalPath = localPath;
		EndCallback = endCallback;
		StartCoroutine(LoadLocalVersionString());
	}
	
	public void GetServerVersionString(string serverUrl, Action<string> endCallback) {
		ServerUrl = serverUrl;
		EndCallback = endCallback;
		StartCoroutine(LoadServerVersionString());
	}
	
	private IEnumerator LoadLocalVersionString() {
		string output = "";
		if (System.IO.File.Exists(LocalPath + "/version") == true) {
			// データが存在するので、そっち読み込む
			WWW www = new WWW (LocalPath + "/version");
			while (www.isDone == false) {
				yield return null;
			}
			
			output = www.text;
		}

		EndCallback(output);
	}

	private IEnumerator LoadServerVersionString() {
		string output = "";

		// データが存在するので、そっち読み込む
		WWW www = new WWW (ServerUrl + "/version");
		while (www.isDone == false) {
			yield return null;
		}
		
		if (string.IsNullOrEmpty (www.error) == false) {
			EndCallback(null);
			yield break;
		}

		output = www.text;
		EndCallback(output);
	}
}

