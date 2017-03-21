using UnityEngine;
using System;
using System.Collections;
using System.IO;
using System.Collections.Generic;

public class ResourceManager : SingletonMonoBehaviour<ResourceManager> {

	public class LoaderData {
		public string LoadPath { get; set; }
		public string SavePath { get; set; }
		public string CallbackName { get; set; }
		public Action CallbackFunction { get; set; }
	}

	bool IsLoading = false;

	// 読み込むファイルパスリスト。このリストの頭から一件ずつ処理していく
	private List<LoaderData> LoadDataStackList = new List<LoaderData>();
	
	// Update is called once per frame
	void Update () {
		if (IsLoading == false) {
			if (LoadDataStackList.Count > 0) {
				LoaderData data = LoadDataStackList[0];
				StartCoroutine(ResourceLoad(data));
				IsLoading = true;
			}
		}
	}

	public void AddLoaderData(string loadPath, string savePath, string callbackName, Action callbackFunction) {
		LoaderData data = new LoaderData();
		data.LoadPath = loadPath;
		data.SavePath = savePath;
		data.CallbackName = callbackName;
		data.CallbackFunction = callbackFunction;

		LoadDataStackList.Add(data);
	}

	// ※本来は、これ、アセットバンドル化した物を読み込んでやることだからね！
	private IEnumerator ResourceLoad(LoaderData loaderData) {
#if UNITY_IPHONE
		//string path = Application.streamingAssetsPath + "/" + "Utility.lua";
		string path = loaderData.LoadPath;
		
		StreamReader sr = new StreamReader(path, System.Text.Encoding.GetEncoding("utf-8"));
		
		// 内容をすべて読み込む
		string text = sr.ReadToEnd();

		// 閉じる
		sr.Close();

		string toPath = loaderData.SavePath;
		File.WriteAllText(toPath, text, System.Text.Encoding.GetEncoding("utf-8"));
		yield return null;

#else
		//string path = Application.streamingAssetsPath + "/" + "Utility.lua";
		string path = loaderData.LoadPath;
		WWW www = new WWW(path);
		while(!www.isDone){
			yield return null;
		}
		
		//string toPath = Application.persistentDataPath + "/LuaUtility.lua";
		string toPath = loaderData.SavePath;
		File.WriteAllBytes(toPath, www.bytes);
#endif
		LoadDataStackList.RemoveAt(0);
		IsLoading = false;
		
		loaderData.CallbackName = loaderData.CallbackName;
		loaderData.CallbackFunction = loaderData.CallbackFunction;

		if (loaderData.CallbackName != "") {
			string functionName = loaderData.CallbackName;
			LuaManager.FunctionData data = new LuaManager.FunctionData();
			data.returnValueNum = 0;
			data.functionName = functionName;
			ArrayList list = new ArrayList();
			data.argList = list;
			ArrayList returnList = LuaManager.Instance.Call(UnityUtility.Instance.scriptName, data);
		}
		
		if (loaderData.CallbackFunction != null) {
			loaderData.CallbackFunction();
		}
	}

	public void Init() {
	}
}
