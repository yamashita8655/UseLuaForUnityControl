using UnityEngine;
using UnityEngine.UI;
using System.Collections;
using System;
using LuaDLLTest;
using System.Runtime.InteropServices;
using System.Collections.Generic;
using System.IO;

public class UnityUtility : SingletonMonoBehaviour<UnityUtility> {

	IntPtr mLuaState;
	GCHandle gcHandle;
	
	float CanvasFactor;
	string LocalVersionString;
	string ServerVersionString;

	public static bool IsEditor = true;
	
	private static Action<string, int> ExeptionCallback = null;
	private static Action LuaMainEndCallback = null;
	
	// ローカルのファイルで完結できるようにするかどうか。開発中用フラグ
	public static bool IsUseLocalFile = true;

#if UNITY_EDITOR
	public static bool IsUseLocalAssetBundle = true;
	public static bool IsCheckVersionFile = false;
	//public static bool IsUseLocalAssetBundle = false;
	//public static bool IsCheckVersionFile = true;
#else
	public static bool IsUseLocalAssetBundle = true;
	public static bool IsCheckVersionFile = false;
	//public static bool IsUseLocalAssetBundle = false;
	//public static bool IsCheckVersionFile = true;
#endif
	
	Dictionary<string, GameObject> GameObjectCacheDict = new Dictionary<string, GameObject>();
	
	public class MonoPInvokeCallbackAttribute : System.Attribute
	{
		private Type type;
		public MonoPInvokeCallbackAttribute( Type t ) { type = t; }
	}

	LuaManager.DelegateLuaBindFunction method1 = null;
	// セーブファイルを読み込み、DoFileできる形式にして保存しなおし、DoFileし終わったら削除する
	[MonoPInvokeCallbackAttribute(typeof(LuaManager.DelegateLuaBindFunction))]
	public static int UnityLoadSaveFile(IntPtr luaState)
	{
		uint res;
		IntPtr res_s = NativeMethods.lua_tolstring(luaState, 1, out res);
		string path = Marshal.PtrToStringAnsi(res_s);
		
		res_s = NativeMethods.lua_tolstring(luaState, 2, out res);
		string oneTimeFileName = Marshal.PtrToStringAnsi(res_s);
		
		res_s = NativeMethods.lua_tolstring(luaState, 3, out res);
		string callbackName = Marshal.PtrToStringAnsi(res_s);
		
		res_s = NativeMethods.lua_tolstring(luaState, 4, out res);
		string callbackArg = Marshal.PtrToStringAnsi(res_s);
    	
		string success = "";
		string str = "";
		
		try {
			FileStream fs = new FileStream(path, FileMode.Open);
    		BinaryReader br = new BinaryReader(fs);
			str = br.ReadString();
    		br.Close();
    		fs.Close();
		} catch (IOException e) {
			success += e.ToString();
		}
		
		string output = RijindaelManager.Instance.CreateDecryptorString(str);
		
		try {
			FileStream stream = new FileStream(oneTimeFileName, FileMode.Create);
			StreamWriter writer = new StreamWriter(stream, System.Text.Encoding.UTF8);
			writer.Write(output);
			
			writer.Close();
			stream.Close();
		} catch (IOException e) {
			success += e.ToString();
		}
		
		// Lua側のメイン関数を呼び出す
		LuaManager.FunctionData data = new LuaManager.FunctionData();
		data.returnValueNum = 0;
		data.functionName = callbackName;
		ArrayList list = new ArrayList();
		list.Add(callbackArg);
		list.Add(success);
		data.argList = list;
		ArrayList returnList = LuaManager.Instance.Call(UnityUtility.Instance.scriptName, data);
		return 0;
	}

	// セーブファイルを暗号化して保存
	[MonoPInvokeCallbackAttribute(typeof(LuaManager.DelegateLuaBindFunction))]
	public static int UnitySaveFile(IntPtr luaState)
	{
		uint res;
		IntPtr res_s = NativeMethods.lua_tolstring(luaState, 1, out res);
		string savePath = Marshal.PtrToStringAnsi(res_s);

		res_s = NativeMethods.lua_tolstring(luaState, 2, out res);
		string saveString = Marshal.PtrToStringAnsi(res_s);
		
		res_s = NativeMethods.lua_tolstring(luaState, 3, out res);
		string callbackName = Marshal.PtrToStringAnsi(res_s);
		
		res_s = NativeMethods.lua_tolstring(luaState, 4, out res);
		string callbackArg = Marshal.PtrToStringAnsi(res_s);

		string output = RijindaelManager.Instance.CreateEncryptorString(saveString);

		string success = "";
		try {
			FileStream fs = new FileStream(savePath, FileMode.Create);
			BinaryWriter bw = new BinaryWriter(fs);
			bw.Write(output);
			bw.Close();
			fs.Close();
			//File.WriteAllText(savePath, output, System.Text.Encoding.GetEncoding("utf-8"));
		} catch (IOException e) {
			success = e.ToString();
		}
		
		// Lua側のメイン関数を呼び出す
		LuaManager.FunctionData data = new LuaManager.FunctionData();
		data.returnValueNum = 0;
		data.functionName = callbackName;
		ArrayList list = new ArrayList();
		list.Add(callbackArg);
		list.Add(success);
		data.argList = list;
		ArrayList returnList = LuaManager.Instance.Call(UnityUtility.Instance.scriptName, data);
		return 0;
	}
	
	// データを非同期で読み込む
	[MonoPInvokeCallbackAttribute(typeof(LuaManager.DelegateLuaBindFunction))]
	public static int UnityLoadFileAsync(IntPtr luaState)
	{
		uint res;
		IntPtr res_s = NativeMethods.lua_tolstring(luaState, 1, out res);
		string loadpath = Marshal.PtrToStringAnsi(res_s);
		
		res_s = NativeMethods.lua_tolstring(luaState, 2, out res);
		string savepath = Marshal.PtrToStringAnsi(res_s);
		
		res_s = NativeMethods.lua_tolstring(luaState, 3, out res);
		string callbackName = Marshal.PtrToStringAnsi(res_s);
	
		ResourceManager.Instance.AddLoaderData(loadpath, savepath, callbackName, null);
		return 0;
	}
	
	// ファイルを削除する
	[MonoPInvokeCallbackAttribute(typeof(LuaManager.DelegateLuaBindFunction))]
	public static int UnityDeleteFile(IntPtr luaState)
	{
		uint res;
		IntPtr res_s = NativeMethods.lua_tolstring(luaState, 1, out res);
		string path = Marshal.PtrToStringAnsi(res_s);
		
		res_s = NativeMethods.lua_tolstring(luaState, 2, out res);
		string callbackName = Marshal.PtrToStringAnsi(res_s);
		
		res_s = NativeMethods.lua_tolstring(luaState, 3, out res);
		string callbackArg = Marshal.PtrToStringAnsi(res_s);

		string success = "";
		
		// aaa.luaファイルを見たかったら、これコメントアウトするといいよ
		try {
			File.Delete(path);
		} catch (IOException e) {
			success += e.ToString();
		}
		
		// Lua側のメイン関数を呼び出す
		LuaManager.FunctionData data = new LuaManager.FunctionData();
		data.returnValueNum = 0;
		data.functionName = callbackName;
		ArrayList list = new ArrayList();
		list.Add(callbackArg);
		list.Add(success);
		data.argList = list;
		ArrayList returnList = LuaManager.Instance.Call(UnityUtility.Instance.scriptName, data);
	
		return 0;
	}

	// オブジェクトを破棄する
	[MonoPInvokeCallbackAttribute(typeof(LuaManager.DelegateLuaBindFunction))]
	public static int UnityDestroyObject(IntPtr luaState)
	{
		uint res;
		IntPtr res_s = NativeMethods.lua_tolstring(luaState, 1, out res);
		string objectName = Marshal.PtrToStringAnsi(res_s);
		GameObjectCacheManager.Instance.RemoveGameObject(objectName);
		
		return 0;
	}

	// オブジェクトをリネームする
	[MonoPInvokeCallbackAttribute(typeof(LuaManager.DelegateLuaBindFunction))]
	public static int UnityRenameObject(IntPtr luaState)
	{
		uint res;
		IntPtr res_s = NativeMethods.lua_tolstring(luaState, 1, out res);
		string objectName = Marshal.PtrToStringAnsi(res_s);
		res_s = NativeMethods.lua_tolstring(luaState, 2, out res);
		string renameName = Marshal.PtrToStringAnsi(res_s);
		GameObject obj = GameObject.Find(objectName);
		obj.name = renameName;
		GameObjectCacheManager.Instance.FindGameObject(renameName);

		return 0;
	}
	
	// オブジェクトを探して、Findリストに登録する
	[MonoPInvokeCallbackAttribute(typeof(LuaManager.DelegateLuaBindFunction))]
	public static int UnityFindObject(IntPtr luaState)
	{
		uint res;
		IntPtr res_s = NativeMethods.lua_tolstring(luaState, 1, out res);
		string objectName = Marshal.PtrToStringAnsi(res_s);
		GameObjectCacheManager.Instance.FindGameObject(objectName);
		
		return 0;
	}
	
	// Animationを再生する
	[MonoPInvokeCallbackAttribute(typeof(LuaManager.DelegateLuaBindFunction))]
	public static int UnityPlayAnimator(IntPtr luaState)
	{
		uint res;
		IntPtr res_s = NativeMethods.lua_tolstring(luaState, 1, out res);
		string prefabname = Marshal.PtrToStringAnsi(res_s);

		string ext = Path.GetExtension(prefabname);
		string path = prefabname.Substring(0, prefabname.Length - ext.Length);
		GameObject retObj = GameObjectCacheManager.Instance.FindGameObject(path);
		
		res_s = NativeMethods.lua_tolstring(luaState, 2, out res);
		string animationName = Marshal.PtrToStringAnsi(res_s);

		bool isLoop = Convert.ToBoolean(NativeMethods.lua_toboolean(luaState, 3));//true=1 false=0
		
		bool isAutoActiveFalse = Convert.ToBoolean(NativeMethods.lua_toboolean(luaState, 4));//true=1 false=0
						
		res_s = NativeMethods.lua_tolstring(luaState, 5, out res);
		string callbackMethodName = Marshal.PtrToStringAnsi(res_s);

		res_s = NativeMethods.lua_tolstring(luaState, 6, out res);
		string callbackMethodArg = Marshal.PtrToStringAnsi(res_s);

		CutinControllerBase2 contoller2 = retObj.GetComponent<CutinControllerBase2>();
		if (contoller2 != null) {
			contoller2.Play(animationName, () => {
				if (callbackMethodName != "") {
					// Lua側のメイン関数を呼び出す
					LuaManager.FunctionData data = new LuaManager.FunctionData();
					data.returnValueNum = 0;
					data.functionName = callbackMethodName;
					ArrayList list = new ArrayList();
					list.Add(callbackMethodArg);
					data.argList = list;
					ArrayList returnList = LuaManager.Instance.Call(UnityUtility.Instance.scriptName, data);
				}
			});
		}
		
		return 0;
	}
	
	// Animationを一時停止する
	[MonoPInvokeCallbackAttribute(typeof(LuaManager.DelegateLuaBindFunction))]
	public static int UnityPauseAnimator(IntPtr luaState)
	{
		uint res;
		IntPtr res_s = NativeMethods.lua_tolstring(luaState, 1, out res);
		string prefabname = Marshal.PtrToStringAnsi(res_s);
		GameObject retObj = GameObjectCacheManager.Instance.FindGameObject(prefabname);

		CutinControllerBase2 contoller2 = retObj.GetComponent<CutinControllerBase2>();
		if (contoller2 != null) {
			contoller2.Pause();
		}
		
		return 0;
	}
	
	// Animationの一時停止を解除する
	[MonoPInvokeCallbackAttribute(typeof(LuaManager.DelegateLuaBindFunction))]
	public static int UnityResumeAnimator(IntPtr luaState)
	{
		uint res;
		IntPtr res_s = NativeMethods.lua_tolstring(luaState, 1, out res);
		string prefabname = Marshal.PtrToStringAnsi(res_s);
		GameObject retObj = GameObjectCacheManager.Instance.FindGameObject(prefabname);

		CutinControllerBase2 contoller2 = retObj.GetComponent<CutinControllerBase2>();
		if (contoller2 != null) {
			contoller2.Resume();
		}
		
		return 0;
	}

	// プレハブを読み込む
	[MonoPInvokeCallbackAttribute(typeof(LuaManager.DelegateLuaBindFunction))]
	public static int UnityLoadPrefabAfter(IntPtr luaState)
	{
		uint res;
		IntPtr res_assetBundleName = NativeMethods.lua_tolstring(luaState, 1, out res);
		string assetBundleName = Marshal.PtrToStringAnsi(res_assetBundleName);

		IntPtr res_s = NativeMethods.lua_tolstring(luaState, 2, out res);
		string prefabname = Marshal.PtrToStringAnsi(res_s);
		
		IntPtr res_objectName = NativeMethods.lua_tolstring(luaState, 3, out res);
		string objectName = Marshal.PtrToStringAnsi(res_objectName);

		string ext = Path.GetExtension(prefabname);
		string path = prefabname.Substring(0, prefabname.Length - ext.Length);
		//GameObject retObj = GameObjectCacheManager.Instance.LoadGameObject(path, objectName);
		GameObject retObj = null;
		if (IsUseLocalFile == true) {
			retObj = GameObjectCacheManager.Instance.LoadGameObject(assetBundleName+"/"+prefabname, objectName);
		} else {
			retObj = GameObjectCacheManager.Instance.LoadGameObjectFromAssetBundle(assetBundleName, prefabname, objectName);
		}

		res_s = NativeMethods.lua_tolstring(luaState, 4, out res);
		string parentObjectName = Marshal.PtrToStringAnsi(res_s);
		
		GameObject parent = GameObjectCacheManager.Instance.FindGameObject(parentObjectName);
		retObj.transform.SetParent(parent.transform);
		retObj.GetComponent<RectTransform>().anchoredPosition3D = Vector3.zero;
//		retObj.transform.localPosition = Vector3.zero;
		retObj.transform.localScale	= Vector3.one;

		return 0;
	}
	
	// ボタンのインタラクティブの設定
	[MonoPInvokeCallbackAttribute(typeof(LuaManager.DelegateLuaBindFunction))]
	public static int UnitySetButtonInteractable(IntPtr luaState)
	{
		uint res;
		IntPtr res_s = NativeMethods.lua_tolstring(luaState, 1, out res);
		string objectName = Marshal.PtrToStringAnsi(res_s);

		bool res_bool = Convert.ToBoolean(NativeMethods.lua_toboolean(luaState, 2));//true=1 false=0
		
		GameObject obj = GameObjectCacheManager.Instance.FindGameObject(objectName);
		Button btn = obj.GetComponent<Button>();

		btn.interactable = res_bool;

		return 0;
	}
	
	// 親の設定
	[MonoPInvokeCallbackAttribute(typeof(LuaManager.DelegateLuaBindFunction))]
	public static int UnitySetParent(IntPtr luaState)
	{
		uint res;
		IntPtr res_objectName = NativeMethods.lua_tolstring(luaState, 1, out res);
		string objectName = Marshal.PtrToStringAnsi(res_objectName);

		IntPtr res_s = NativeMethods.lua_tolstring(luaState, 2, out res);
		string parentObjectName = Marshal.PtrToStringAnsi(res_s);
		
		GameObject obj = GameObjectCacheManager.Instance.FindGameObject(objectName);
		GameObject parent = GameObjectCacheManager.Instance.FindGameObject(parentObjectName);
		obj.transform.SetParent(parent.transform);
		obj.GetComponent<RectTransform>().anchoredPosition3D = Vector3.zero;
		obj.transform.localScale = Vector3.one;

		return 0;
	}
	
	// テキストの設定
	[MonoPInvokeCallbackAttribute(typeof(LuaManager.DelegateLuaBindFunction))]
	public static int UnitySetText(IntPtr luaState)
	{
		uint res;
		IntPtr res_s = NativeMethods.lua_tolstring(luaState, 1, out res);
		string objectName = Marshal.PtrToStringAnsi(res_s);
		GameObject obj = GameObjectCacheManager.Instance.FindGameObject(objectName);
		
		res_s = NativeMethods.lua_tolstring(luaState, 2, out res);
		string text = Marshal.PtrToStringAnsi(res_s);
		obj.GetComponent<Text>().text = text;
		
		return 0;
	}
	
	// 画像の設定
	[MonoPInvokeCallbackAttribute(typeof(LuaManager.DelegateLuaBindFunction))]
	public static int UnitySetSprite(IntPtr luaState)
	{
		uint res;
		IntPtr res_s = NativeMethods.lua_tolstring(luaState, 1, out res);
		string objectName = Marshal.PtrToStringAnsi(res_s);
		GameObject obj = GameObjectCacheManager.Instance.FindGameObject(objectName);
		
		res_s = NativeMethods.lua_tolstring(luaState, 2, out res);
		string text = Marshal.PtrToStringAnsi(res_s);
		obj.GetComponent<Text>().text = text;
		
		return 0;
	}
	
	// ポジションを設定する
	[MonoPInvokeCallbackAttribute(typeof(LuaManager.DelegateLuaBindFunction))]
	public static int UnitySetPosition(IntPtr luaState)
	{
		uint res;
		IntPtr res_s = NativeMethods.lua_tolstring(luaState, 1, out res);
		string objectName = Marshal.PtrToStringAnsi(res_s);
		
		float x = (float)NativeMethods.lua_tonumberx(luaState, 2, 0);
		float y = (float)NativeMethods.lua_tonumberx(luaState, 3, 0);
		float z = (float)NativeMethods.lua_tonumberx(luaState, 4, 0);
		
		GameObject obj = GameObjectCacheManager.Instance.FindGameObject(objectName);
		obj.transform.localPosition = new Vector3(x,y,z);
		
		return 0;
	}
	
	// ローテーションを設定する
	[MonoPInvokeCallbackAttribute(typeof(LuaManager.DelegateLuaBindFunction))]
	public static int UnitySetRotate(IntPtr luaState)
	{
		uint res;
		IntPtr res_s = NativeMethods.lua_tolstring(luaState, 1, out res);
		string objectName = Marshal.PtrToStringAnsi(res_s);
		
		float x = (float)NativeMethods.lua_tonumberx(luaState, 2, 0);
		float y = (float)NativeMethods.lua_tonumberx(luaState, 3, 0);
		float z = (float)NativeMethods.lua_tonumberx(luaState, 4, 0);
		
		GameObject obj = GameObjectCacheManager.Instance.FindGameObject(objectName);
		obj.transform.localRotation = Quaternion.Euler(new Vector3(x,y,z));
		
		return 0;
	}
	
	// スケールを設定する
	[MonoPInvokeCallbackAttribute(typeof(LuaManager.DelegateLuaBindFunction))]
	public static int UnitySetScale(IntPtr luaState)
	{
		uint res;
		IntPtr res_s = NativeMethods.lua_tolstring(luaState, 1, out res);
		string objectName = Marshal.PtrToStringAnsi(res_s);
		
		float x = (float)NativeMethods.lua_tonumberx(luaState, 2, 0);
		float y = (float)NativeMethods.lua_tonumberx(luaState, 3, 0);
		float z = (float)NativeMethods.lua_tonumberx(luaState, 4, 0);
		
		GameObject obj = GameObjectCacheManager.Instance.FindGameObject(objectName);
		obj.transform.localScale = new Vector3(x,y,z);
		
		return 0;
	}
	
	// アクティブを設定する
	[MonoPInvokeCallbackAttribute(typeof(LuaManager.DelegateLuaBindFunction))]
	public static int UnitySetActive(IntPtr luaState)
	{
		uint res;
		IntPtr res_s = NativeMethods.lua_tolstring(luaState, 1, out res);
		string prefabname = Marshal.PtrToStringAnsi(res_s);

		string ext = Path.GetExtension(prefabname);
		string path = prefabname.Substring(0, prefabname.Length - ext.Length);
		GameObject retObj = GameObjectCacheManager.Instance.FindGameObject(path);
		
		bool res_bool = Convert.ToBoolean(NativeMethods.lua_toboolean(luaState, 2));//true=1 false=0
		retObj.SetActive(res_bool);
		
		return 0;
	}
	
	// スライダーの値を設定する
	[MonoPInvokeCallbackAttribute(typeof(LuaManager.DelegateLuaBindFunction))]
	public static int UnitySetSliderValue(IntPtr luaState)
	{
		uint res;
		IntPtr res_s = NativeMethods.lua_tolstring(luaState, 1, out res);
		string objectName = Marshal.PtrToStringAnsi(res_s);
		GameObject obj = GameObjectCacheManager.Instance.FindGameObject(objectName);
		
		float value = (float)NativeMethods.lua_tonumberx(luaState, 2, 0);
		obj.GetComponent<Slider>().value = value;
		
		return 0;
	}
	
	// スライダーの最大値を設定する
	[MonoPInvokeCallbackAttribute(typeof(LuaManager.DelegateLuaBindFunction))]
	public static int UnitySetMaxSliderValue(IntPtr luaState)
	{
		uint res;
		IntPtr res_s = NativeMethods.lua_tolstring(luaState, 1, out res);
		string objectName = Marshal.PtrToStringAnsi(res_s);
		GameObject obj = GameObjectCacheManager.Instance.FindGameObject(objectName);
		
		float value = (float)NativeMethods.lua_tonumberx(luaState, 2, 0);
		obj.GetComponent<Slider>().maxValue = value;
		
		return 0;
	}

	// シーンを切り替える
	[MonoPInvokeCallbackAttribute(typeof(LuaManager.DelegateLuaBindFunction))]
	public static int UnityChangeScene(IntPtr luaState)
	{
		uint res;
		IntPtr res_s = NativeMethods.lua_tolstring(luaState, 1, out res);
		string sceneName = Marshal.PtrToStringAnsi(res_s);

		res_s = NativeMethods.lua_tolstring(luaState, 2, out res);
		string parentName = Marshal.PtrToStringAnsi(res_s);

		GameObject parent =	GameObjectCacheManager.Instance.FindGameObject(parentName);
		GameSceneManager.Instance.ChangeScene(sceneName, parent, IsUseLocalFile);

		return 0;
	}

	// バージョンファイルの保存
	[MonoPInvokeCallbackAttribute(typeof(LuaManager.DelegateLuaBindFunction))]
	public static int UnitySaveVersionFile(IntPtr luaState)
	{
		uint res;
		IntPtr res_s = NativeMethods.lua_tolstring(luaState, 1, out res);
		string path = Marshal.PtrToStringAnsi(res_s);

		res_s = NativeMethods.lua_tolstring(luaState, 2, out res);
		string src = Marshal.PtrToStringAnsi(res_s);

		res_s = NativeMethods.lua_tolstring(luaState, 3, out res);
		string callbackName = Marshal.PtrToStringAnsi(res_s);

		res_s = NativeMethods.lua_tolstring(luaState, 4, out res);
		string callbackArg = Marshal.PtrToStringAnsi(res_s);

		string error = VersionFileManager.Instance.SaveVersionString(path, src);

		// Lua側の関数を呼び出す
		LuaManager.FunctionData data = new LuaManager.FunctionData();
		data.returnValueNum = 0;
		data.functionName = callbackName;
		ArrayList list = new ArrayList();
		list.Add(callbackArg);
		list.Add(error);
		data.argList = list;
		ArrayList returnList = LuaManager.Instance.Call(UnityUtility.Instance.scriptName, data);

		return 0;
	}

	// プレハブを読み込んでシーンに追加する。ファイル名はLua側から渡される
	[MonoPInvokeCallbackAttribute(typeof(LuaManager.DelegateLuaBindFunction))]
	public static int UnityLoadPrefab(IntPtr luaState)
	{
		uint res;
		IntPtr res_s = NativeMethods.lua_tolstring(luaState, 1, out res);
		string prefabname = Marshal.PtrToStringAnsi(res_s);
		
		string ext = Path.GetExtension(prefabname);
		UnityEngine.Object obj = Resources.Load(prefabname.Substring(0, prefabname.Length - ext.Length), typeof(GameObject));
		GameObject retObj = UnityEngine.Object.Instantiate(obj) as GameObject;
		GameObject root = GameObject.Find ("UIRoot");
		retObj.transform.parent = root.transform;
		retObj.transform.localPosition = retObj.transform.position;
		retObj.transform.localScale	= Vector3.one;
		
		return 0;
	}
	
	// アセットバンドルを読み込む(本当に読み込むだけ。ファイル化も何もしていない状態)
	// Lua側で、ローカルなのかサーバーなのか判断してパスも変更する必要があると思うよ
	[MonoPInvokeCallbackAttribute(typeof(LuaManager.DelegateLuaBindFunction))]
	public static int UnityLoadAssetBundle(IntPtr luaState)
	{
		uint res;
		IntPtr res_s = NativeMethods.lua_tolstring(luaState, 1, out res);
		string path = Marshal.PtrToStringAnsi(res_s);
		
		res_s = NativeMethods.lua_tolstring(luaState, 2, out res);
		string assetBundleName = Marshal.PtrToStringAnsi(res_s);
		
		res_s = NativeMethods.lua_tolstring(luaState, 3, out res);
		string callbackName = Marshal.PtrToStringAnsi(res_s);
		
		res_s = NativeMethods.lua_tolstring(luaState, 4, out res);
		string callbackArg = Marshal.PtrToStringAnsi(res_s);

		// 
		AssetBundleManager.Instance.LoadAssetBundle(path, assetBundleName, (AssetBundle assetBundle, string error) => {
			// Lua側の関数を呼び出す
			LuaManager.FunctionData data = new LuaManager.FunctionData();
			data.returnValueNum = 0;
			data.functionName = callbackName;
			ArrayList list = new ArrayList();
			list.Add(callbackArg);
			list.Add(error);
			data.argList = list;
			ArrayList returnList = LuaManager.Instance.Call(UnityUtility.Instance.scriptName, data);
	
		});
		
		return 0;
	}
	
	// luaスクリプトのセーブ
	[MonoPInvokeCallbackAttribute(typeof(LuaManager.DelegateLuaBindFunction))]
	public static int UnitySaveScriptFile(IntPtr luaState)
	{
		uint res;
		IntPtr res_s = NativeMethods.lua_tolstring(luaState, 1, out res);
		string loadPath = Marshal.PtrToStringAnsi(res_s);
		
		res_s = NativeMethods.lua_tolstring(luaState, 2, out res);
		string savePath = Marshal.PtrToStringAnsi(res_s);
		
		res_s = NativeMethods.lua_tolstring(luaState, 3, out res);
		string assetBundleName = Marshal.PtrToStringAnsi(res_s);
		
		res_s = NativeMethods.lua_tolstring(luaState, 4, out res);
		string assetName = Marshal.PtrToStringAnsi(res_s);

		res_s = NativeMethods.lua_tolstring(luaState, 5, out res);
		string scriptName = Marshal.PtrToStringAnsi(res_s);
		
		res_s = NativeMethods.lua_tolstring(luaState, 6, out res);
		string callbackName = Marshal.PtrToStringAnsi(res_s);

//#if UNITY_EDITOR
//		savePath = savePath + "/Android";
//#elif UNITY_ANDROID
//		savePath = savePath + "/Android";
//#elif UNITY_IPHONE
//		savePath = savePath + "/IOS";
//#endif
		if (IsUseLocalFile == true) {
			// こっちのフローは、アンドロイド版かIOS版のローカルでしかこない予定
#if UNITY_ANDROID
			GameObjectCacheManager.Instance.SaveLocalLuaScript(loadPath+"/"+scriptName, savePath, scriptName, () => {
				// Lua側の関数を呼び出す
				LuaManager.FunctionData data = new LuaManager.FunctionData();
				data.returnValueNum = 0;
				data.functionName = callbackName;
				ArrayList list = new ArrayList();
				list.Add("");
				data.argList = list;
				ArrayList returnList = LuaManager.Instance.Call(UnityUtility.Instance.scriptName, data);
			});
#elif UNITY_IPHONE
#endif

		} else {
			AssetBundleManager.Instance.LoadAssetBundle(loadPath, assetBundleName, (AssetBundle assetBundle, string error) => {
				if (string.IsNullOrEmpty(error) == false) {
				} else {
					TextAsset resultObject = assetBundle.LoadAsset<TextAsset>(assetName);
					string path = string.Format("{0}/{1}", savePath, scriptName);

					try {
						System.IO.StreamWriter sw = new System.IO.StreamWriter(
							path, 
							false, 
							System.Text.Encoding.UTF8
						);
						sw.Write(resultObject.text);
						sw.Close();
					} catch (IOException e) {
						error = e.ToString();
					}
				}
				
				// Lua側の関数を呼び出す
				LuaManager.FunctionData data = new LuaManager.FunctionData();
				data.returnValueNum = 0;
				data.functionName = callbackName;
				ArrayList list = new ArrayList();
				list.Add(error);
				data.argList = list;
				ArrayList returnList = LuaManager.Instance.Call(UnityUtility.Instance.scriptName, data);
			});
		}
		
		return 0;
	}

	// アセットバンドルをダウンロードして保存する
	[MonoPInvokeCallbackAttribute(typeof(LuaManager.DelegateLuaBindFunction))]
	public static int UnitySaveAssetBundle(IntPtr luaState)
	{
		Debug.Log("UnitySaveAssetBundle:Start");
		uint res;
		IntPtr res_s = NativeMethods.lua_tolstring(luaState, 1, out res);
		string loadPath = Marshal.PtrToStringAnsi(res_s);

		res_s = NativeMethods.lua_tolstring(luaState, 2, out res);
		string savePath = Marshal.PtrToStringAnsi(res_s);

		res_s = NativeMethods.lua_tolstring(luaState, 3, out res);
		string assetBundleName = Marshal.PtrToStringAnsi(res_s);

		res_s = NativeMethods.lua_tolstring(luaState, 4, out res);
		string callbackName = Marshal.PtrToStringAnsi(res_s);

		Debug.Log(loadPath);
		Debug.Log(savePath);
		//AssetBundleManager.Instance.SaveAssetBundle(loadPath, savePath, assetBundleName, (AssetBundle assetBundle, string error) => {
		AssetBundleManager.Instance.SaveAssetBundle(loadPath, savePath, assetBundleName, (AssetBundle assetBundle, string error) => {
			// Lua側の関数を呼び出す
			LuaManager.FunctionData data = new LuaManager.FunctionData();
			data.returnValueNum = 0;
			data.functionName = callbackName;
			ArrayList list = new ArrayList();
			list.Add(error);
			data.argList = list;
			ArrayList returnList = LuaManager.Instance.Call(UnityUtility.Instance.scriptName, data);
		});

		return 0;
	}
	
	// 例外処理を呼ぶ
	[MonoPInvokeCallbackAttribute(typeof(LuaManager.DelegateLuaBindFunction))]
	public static int UnityCallExeptionCallback(IntPtr luaState)
	{
		uint res;
		IntPtr res_s = NativeMethods.lua_tolstring(luaState, 1, out res);
		string errorString = Marshal.PtrToStringAnsi(res_s);

		int errorNumber = (int)NativeMethods.lua_tonumberx(luaState, 2, 0);

		ExeptionCallback(errorString, errorNumber);

		return 0;
	}
	
	// LuaMainが一通り終わった後の、コールバックを呼び出す
	[MonoPInvokeCallbackAttribute(typeof(LuaManager.DelegateLuaBindFunction))]
	public static int UnityCallLuaMainEndCallback(IntPtr luaState)
	{
		if (LuaMainEndCallback != null) {
			LuaMainEndCallback();
		}
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaManager.DelegateLuaBindFunction))]
	public static int UnityLoadLevel(IntPtr luaState)
	{
		uint res;
		IntPtr res_s = NativeMethods.lua_tolstring(luaState, 1, out res);
		string sceneName = Marshal.PtrToStringAnsi(res_s);
		Application.LoadLevel (sceneName);
		
		return 0;
	}
	
	[MonoPInvokeCallbackAttribute(typeof(LuaManager.DelegateLuaBindFunction))]
	public static int UnityDebugLog(IntPtr luaState)
	{
		uint res;
		IntPtr res_s = NativeMethods.lua_tolstring(luaState, 1, out res);
		string logstring = Marshal.PtrToStringAnsi(res_s);
		Debug.Log(logstring);
		
		return 0;
	}
	
	[MonoPInvokeCallbackAttribute(typeof(LuaManager.DelegateLuaBindFunction))]
	public static int UnityLoadLuaFile(IntPtr luaState)
	{
		uint res;
		IntPtr res_s = NativeMethods.lua_tolstring(luaState, 1, out res);
		string luaFileName = Marshal.PtrToStringAnsi(res_s);
		
		TextAsset file = Resources.Load<TextAsset>(luaFileName);
		LuaManager.Instance.LoadLuaScript (file.text, file.name);
		
		return 0;
	}
	
	[MonoPInvokeCallbackAttribute(typeof(LuaManager.DelegateLuaBindFunction))]
	public static int UnityAddCallUpdateScript(IntPtr luastate)
	{
		uint res;
		IntPtr res_s = NativeMethods.lua_tolstring(luastate, 1, out res);
		string csvname = Marshal.PtrToStringAnsi(res_s);
		string ext = Path.GetExtension(csvname);
		csvname = csvname.Substring(0, csvname.Length - ext.Length);
		
		if(mLuaCallUpdateMap.ContainsKey(csvname) == true)
		{
			return 0;
		}
		
		mLuaCallUpdateMap.Add(csvname, csvname);
		return 0;
	}
	
	// BGMの登録
	[MonoPInvokeCallbackAttribute(typeof(LuaManager.DelegateLuaBindFunction))]
	public static int UnityAddBGMAudioSourceAndClip(IntPtr luastate)
	{
		uint res;
		IntPtr res_assetBundleName = NativeMethods.lua_tolstring(luastate, 1, out res);
		string assetBundleName = Marshal.PtrToStringAnsi(res_assetBundleName);

		IntPtr res_s = NativeMethods.lua_tolstring(luastate, 2, out res);
		string soundName = Marshal.PtrToStringAnsi(res_s);
		
		string ext = Path.GetExtension(soundName);
		string path = soundName.Substring(0, soundName.Length - ext.Length);
		
		AudioClip audioClip = null;
		if (IsUseLocalFile == true) {
			audioClip = GameObjectCacheManager.Instance.LoadAudioClip(assetBundleName+"/"+soundName);
		} else {
			audioClip = GameObjectCacheManager.Instance.LoadAudioClipFromAssetBundle(assetBundleName, soundName);
		}

		SoundManager.Instance.AddBGMAudioSource(audioClip);

		return 0;
	}
	
	// BGMの再生
	[MonoPInvokeCallbackAttribute(typeof(LuaManager.DelegateLuaBindFunction))]
	public static int UnityPlayBGM(IntPtr luastate)
	{
		uint res;
		int bgmIndex = (int)NativeMethods.lua_tonumberx(luastate, 1, 0);

		SoundManager.Instance.PlayBGM(bgmIndex);

		return 0;
	}
	
	// BGMの停止
	[MonoPInvokeCallbackAttribute(typeof(LuaManager.DelegateLuaBindFunction))]
	public static int UnityStopBGM(IntPtr luastate)
	{
		uint res;
		int bgmIndex = (int)NativeMethods.lua_tonumberx(luastate, 1, 0);

		SoundManager.Instance.StopBGM(bgmIndex);

		return 0;
	}
	
	// SE用のAudioSource作成
	[MonoPInvokeCallbackAttribute(typeof(LuaManager.DelegateLuaBindFunction))]
	public static int UnityCreateSEAudioSource(IntPtr luastate)
	{
		uint res;
		int sourceNum = (int)NativeMethods.lua_tonumberx(luastate, 1, 0);

		SoundManager.Instance.CreateSEAudioSource(sourceNum);

		return 0;
	}
	
	// SEの再生
	[MonoPInvokeCallbackAttribute(typeof(LuaManager.DelegateLuaBindFunction))]
	public static int UnityPlaySE(IntPtr luastate)
	{
		uint res;
		IntPtr res_assetBundleName = NativeMethods.lua_tolstring(luastate, 1, out res);
		string assetBundleName = Marshal.PtrToStringAnsi(res_assetBundleName);

		IntPtr res_s = NativeMethods.lua_tolstring(luastate, 2, out res);
		string soundName = Marshal.PtrToStringAnsi(res_s);

		AudioClip audioClip = null;
		if (IsUseLocalFile == true) {
			audioClip = GameObjectCacheManager.Instance.LoadAudioClip(assetBundleName+"/"+soundName);
		} else {
			audioClip = GameObjectCacheManager.Instance.LoadAudioClipFromAssetBundle(assetBundleName, soundName);
		}

		SoundManager.Instance.PlaySE(audioClip);

		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaManager.DelegateLuaBindFunction))]
	public static int UnityBindCommonFunction(IntPtr luastate)
	{
		uint res;
		IntPtr res_s = NativeMethods.lua_tolstring(luastate, 1, out res);
		string csvname = Marshal.PtrToStringAnsi(res_s);
		string ext = Path.GetExtension(csvname);
		csvname = csvname.Substring(0, csvname.Length - ext.Length);
		
		BindCommonFunction(csvname);
		return 0;
	}
	
	// Update関数を呼び出したいLuaスクリプトのマップ
	static Dictionary<string, string> mLuaCallUpdateMap = null;

//	string scriptName = "UnityBind";
	//public string scriptName = "UnityBindTest";
	public string scriptName = "LuaMain.lua";
//	public string scriptName = "LuaMainTest.lua";

	void Awake () {
		base.Awake ();
		DontDestroyOnLoad (this);
	}
	
	void Update () {
		if(mLuaCallUpdateMap != null)
		{
			foreach (KeyValuePair<string, string> pair in mLuaCallUpdateMap) {
				// LuaにUpdateを通知する
				LuaManager.FunctionData data = new LuaManager.FunctionData();
				data.returnValueNum = 0;
				data.functionName = "Update";
				ArrayList list = new ArrayList();
				data.argList = list;
				ArrayList returnList = LuaManager.Instance.Call(pair.Value, data);
			}
		}
	}

	public void SetUnityData(float canvasFactor) {
		// Lua側のメイン関数を呼び出す
		LuaManager.FunctionData data = new LuaManager.FunctionData();
		data.returnValueNum = 0;
		data.functionName = "SetUnityGameData";
		ArrayList list = new ArrayList();
		//list.Add(canvasSize.x);
		//list.Add(canvasSize.y);
		list.Add((float)Screen.width);
		list.Add((float)Screen.height);
		list.Add((float)canvasFactor);
		list.Add(LocalVersionString);
		list.Add(ServerVersionString);

		string streamingAssetsPath = "";
		string platform = "";
#if UNITY_EDITOR
		if (IsUseLocalFile == true) {
			streamingAssetsPath = Application.streamingAssetsPath;
			platform = "Editor";
		} else {
			streamingAssetsPath = "file:///" + Application.streamingAssetsPath;
			platform = "Editor";
		}
#elif UNITY_ANDROID
		streamingAssetsPath = Application.streamingAssetsPath;
		platform = "Android";
#elif UNITY_IPHONE
		streamingAssetsPath = Application.streamingAssetsPath;
		platform = "IOS";
#endif
		list.Add(streamingAssetsPath);
		list.Add(Application.persistentDataPath);
		list.Add(platform);
		data.argList = list;
		ArrayList returnList = LuaManager.Instance.Call(scriptName, data);
	}
	
	public IEnumerator Init(float canvasFactor, string localVersionString, string serverVersionString, Action<string, int> exeptionCallback, Action luaMainEndCallback)
	{
		CanvasFactor = canvasFactor;
		LocalVersionString = localVersionString;
		ServerVersionString = serverVersionString;
		ExeptionCallback = exeptionCallback;
		LuaMainEndCallback = luaMainEndCallback;

		mLuaCallUpdateMap = new Dictionary<string, string>();
		LuaManager.Instance.Init();

		bool isLoaded = false;
		string loadPath = "";
		string savePath = "";
#if UNITY_EDITOR
		//loadPath = "file:///" + Application.streamingAssetsPath + "/" + scriptName;
		loadPath = Application.streamingAssetsPath + "/" + scriptName;
		savePath = Application.persistentDataPath + "/" + scriptName;
#elif UNITY_ANDROID
		if (IsUseLocalFile == true) {
			loadPath = Application.streamingAssetsPath + "/" + scriptName;
			savePath = Application.persistentDataPath + "/" + scriptName;
		} else {
			loadPath = Application.streamingAssetsPath + "/Android/" + scriptName;
			savePath = Application.persistentDataPath + "/" + scriptName;
		}
#elif UNITY_IPHONE
		loadPath = Application.streamingAssetsPath + "/IOS/" + scriptName;
		savePath = Application.persistentDataPath + "/" + scriptName;
#endif
		if (IsUseLocalFile == true) {
			StartCoroutine(LoadLuaMainFile(loadPath, () => {
					isLoaded = true;
				})
			);
		} else {
			if (UnityUtility.IsUseLocalAssetBundle == true) {
				StartCoroutine(LoadLuaMainFile(loadPath, () => {
						isLoaded = true;
					})
				);
			} else {
				StartCoroutine(LoadLuaMainFile(savePath, () => {
						isLoaded = true;
					})
				);
			}
		}
	

		while (isLoaded != true) {
			yield return null;
		}
	}

	
/*	public IEnumerator Init(float canvasFactor)
	{
		CanvasFactor = canvasFactor;

		mLuaCallUpdateMap = new Dictionary<string, string>();
		LuaManager.Instance.Init();

		bool isLoaded = false;
		string loadPath = "";
#if UNITY_EDITOR
		loadPath = "file:///" + Application.streamingAssetsPath + "/" + scriptName;
#elif UNITY_ANDROID
		loadPath = Application.streamingAssetsPath + "/" + scriptName;
#elif UNITY_IPHONE
		loadPath = Application.streamingAssetsPath + "/" + scriptName;
#endif
		string savePath = Application.persistentDataPath + "/" + scriptName;

		ResourceManager.Instance.AddLoaderData(loadPath, savePath, "", () => {
			StartCoroutine(LoadLuaMainFile(savePath, () => {
					isLoaded = true;
				})
			);
		});

		while (isLoaded != true) {
			yield return null;
		}
	}*/
	
	private IEnumerator LoadLuaMainFile(string filePath, Action endCallback) {
		string loadPath = "";
#if UNITY_EDITOR
		//loadPath = "file:///" + filePath;
		loadPath = filePath;
#elif UNITY_ANDROID
		//loadPath = "jar:file://" + filePath;
		loadPath = filePath;
#elif UNITY_IPHONE
		//loadPath = "jar:file://" + filePath;
		loadPath = filePath;
#endif
/*		WWW www = new WWW(loadPath);
		while (www.isDone == false) {
			yield return null;
		}*/

		Debug.Log(loadPath+":start");
		string output = "";
		if (IsUseLocalFile == true) {
#if UNITY_EDITOR
			output = File.ReadAllText(loadPath, System.Text.Encoding.UTF8);
#elif UNITY_ANDROID
			WWW www = new WWW(loadPath);
			while (www.isDone == false) {
				yield return null;
			}
			output = www.text;
#elif UNITY_IPHONE
			output = File.ReadAllText(loadPath, System.Text.Encoding.UTF8);
#endif
		} else {
			output = File.ReadAllText(loadPath, System.Text.Encoding.UTF8);
		}

		Debug.Log(loadPath+":end");

		//			TextAsset file = Resources.Load<TextAsset>(scriptName);
		//TextAsset file = UnityEditor.AssetDatabase.LoadAssetAtPath<TextAsset>(filePath);

		// まずは、スクリプトをロードして使える状態にする
		LuaManager.Instance.LoadLuaScript(output, scriptName);

		// Unity関数をLua側に登録する
		BindCommonFunction (scriptName);

		// データの設定
		SetUnityData(CanvasFactor);
		
		// Lua側のメイン関数を呼び出す
		LuaManager.FunctionData data = new LuaManager.FunctionData();
		data.returnValueNum = 0;
		data.functionName = "LuaMain";
		ArrayList list = new ArrayList();
		data.argList = list;
		ArrayList returnList = LuaManager.Instance.Call(scriptName, data);

		IntPtr state = LuaManager.Instance.GetLuaState(scriptName);
		LuaManager.Instance.getStack(state, new ArrayList());

		if (endCallback != null) {
			endCallback();
		}
		
		yield return null;
	}

	//public IEnumerator Init()
	//{
	//	mLuaCallUpdateMap = new Dictionary<string, string>();
	//	
	//	LuaManager.Instance.Init ();
	//	TextAsset file = Resources.Load<TextAsset>(scriptName);

	//	// まずは、スクリプトをロードして使える状態にする
	//	LuaManager.Instance.LoadLuaScript (file);
	//	
	//	// Unity関数をLua側に登録する
	//	BindCommonFunction (scriptName);

	//	// LuaのCsvManager初期化処理
/*	//	LuaManager.DelegateLuaBindFunction LuaUnityInitCsvManager = new LuaManager.DelegateLuaBindFunction (UnityInitCsvManager);
	//	IntPtr LuaUnityInitCsvManagerIntPtr = Marshal.GetFunctionPointerForDelegate(LuaUnityInitCsvManager);
	//	LuaManager.Instance.AddUnityFunction(file.name, "UnityInitCsvManager", LuaUnityInitCsvManagerIntPtr, LuaUnityInitCsvManager);*/

/*	//	mLuaState = NativeMethods.luaL_newstate();
	//	NativeMethods.luaL_openlibs(mLuaState);

	//	DelegateLuaBindFunction LuaUnityLoadLevel = new DelegateLuaBindFunction (UnityLoadLevel);
	//	IntPtr LuaUnityLoadLevelIntPtr = Marshal.GetFunctionPointerForDelegate(LuaUnityLoadLevel);
	//	//関数ポインタが指しているデリゲートがGCに回収されないようメモリを確保するらしい
//	//	gcHandle = GCHandle.Alloc(LuaUnityLoadLevel);

	//	// ここはアセットバンドルで読み込んだリソースを使う方向に変更する必要があると思うよ
	//	TextAsset file = Resources.Load<TextAsset>("UnityBind");
	//	NativeMethods.luaL_loadstring (mLuaState, file.text);
	//	NativeMethods.lua_pcallk (mLuaState, 0, -1, 0);

	//	NativeMethods.lua_pushcclosure (mLuaState, LuaUnityLoadLevelIntPtr, 0);
	//	NativeMethods.lua_setglobal (mLuaState, "UnityLoadLevel");
	//	
	//	// 関数呼び出したと仮定
	//	NativeMethods.lua_getglobal(mLuaState, "LuaLoadLevel");
	//	NativeMethods.lua_pushstring(mLuaState, "NextScene");
	//	int res = NativeMethods.lua_pcallk (mLuaState, 1, 0, 0);*/

	//	// Lua側のメイン関数を呼び出す
	//	LuaManager.FunctionData data = new LuaManager.FunctionData();
	//	data.returnValueNum = 0;
	//	data.functionName = "LuaMain";
	//	ArrayList list = new ArrayList();
	//	data.argList = list;
	//	ArrayList returnList = LuaManager.Instance.Call(scriptName, data);

	//	// 仮 Androidで、StreamingAsstesの物を、アクセスできる場所にコピーする処理
/*#i//f UNITY_ANDROID
	//			string path = Application.streamingAssetsPath + "/LuaUtility.lua";
	//			WWW www = new WWW(path);
	//			while(!www.isDone){
	//			}

	//			string toPath = Application.persistentDataPath + "/LuaUtility.lua";

	//			File.WriteAllBytes(toPath, www.bytes);
#end//if*/
	//	yield return null;
	//}

	static public void BindCommonFunction(string scriptName)
	{
		// シーン切り替え
		LuaManager.DelegateLuaBindFunction LuaUnityLoadLevel = new LuaManager.DelegateLuaBindFunction (UnityLoadLevel);
		IntPtr LuaUnityLoadLevelIntPtr = Marshal.GetFunctionPointerForDelegate(LuaUnityLoadLevel);
		LuaManager.Instance.AddUnityFunction(scriptName, "UnityLoadLevel", LuaUnityLoadLevelIntPtr, LuaUnityLoadLevel);
		//gcHandle = GCHandle.Alloc(LuaUnityLoadLevel);// これないと、なぜかLua側でUnityLoadLevel呼び出すとUnityが強制終了する
		//method1 = new DelegateLuaBindFunction (UnityLoadLevel);
		//IntPtr LuaUnityLoadLevelIntPtr = Marshal.GetFunctionPointerForDelegate(method1);
		//LuaManager.Instance.AddUnityFunction(scriptName, "UnityLoadLevel", LuaUnityLoadLevelIntPtr);

		// これは、ガベコレタイミングを遅らせるだけらしいので、解決にはならんから使わない
		//GC.KeepAlive (LuaUnityLoadLevel);
		//GC.KeepAlive (LuaUnityLoadLevelIntPtr);
		// ファイル削除
		LuaManager.DelegateLuaBindFunction LuaUnityDeleteFile = new LuaManager.DelegateLuaBindFunction (UnityDeleteFile);
		IntPtr LuaUnityDeleteFileIntPtr = Marshal.GetFunctionPointerForDelegate(LuaUnityDeleteFile);
		LuaManager.Instance.AddUnityFunction(scriptName, "UnityDeleteFile", LuaUnityDeleteFileIntPtr, LuaUnityDeleteFile);

		// セーブファイル読み込み
		LuaManager.DelegateLuaBindFunction LuaUnityLoadSaveFile = new LuaManager.DelegateLuaBindFunction (UnityLoadSaveFile);
		IntPtr LuaUnityLoadSaveFileIntPtr = Marshal.GetFunctionPointerForDelegate(LuaUnityLoadSaveFile);
		LuaManager.Instance.AddUnityFunction(scriptName, "UnityLoadSaveFile", LuaUnityLoadSaveFileIntPtr, LuaUnityLoadSaveFile);

		// デバッグログ
		LuaManager.DelegateLuaBindFunction LuaUnityDebugLog = new LuaManager.DelegateLuaBindFunction (UnityDebugLog);
		IntPtr LuaUnityDebugLogIntPtr = Marshal.GetFunctionPointerForDelegate(LuaUnityDebugLog);
		LuaManager.Instance.AddUnityFunction(scriptName, "UnityDebugLog", LuaUnityDebugLogIntPtr, LuaUnityDebugLog);

		// 非同期ファイル読み込み
		LuaManager.DelegateLuaBindFunction LuaUnitySaveFile = new LuaManager.DelegateLuaBindFunction (UnitySaveFile);
		IntPtr LuaUnitySaveFileIntPtr = Marshal.GetFunctionPointerForDelegate(LuaUnitySaveFile);
		LuaManager.Instance.AddUnityFunction(scriptName, "UnitySaveFile", LuaUnitySaveFileIntPtr, LuaUnitySaveFile);
		
		// 非同期ファイル読み込み
		LuaManager.DelegateLuaBindFunction LuaUnityLoadFileAsync = new LuaManager.DelegateLuaBindFunction (UnityLoadFileAsync);
		IntPtr LuaUnityLoadFileAsyncIntPtr = Marshal.GetFunctionPointerForDelegate(LuaUnityLoadFileAsync);
		LuaManager.Instance.AddUnityFunction(scriptName, "UnityLoadFileAsync", LuaUnityLoadFileAsyncIntPtr, LuaUnityLoadFileAsync);

		// Luaファイル読み込み処理
		LuaManager.DelegateLuaBindFunction LuaUnityLoadLuaFile = new LuaManager.DelegateLuaBindFunction (UnityLoadLuaFile);
		IntPtr LuaUnityLoadLuaFileIntPtr = Marshal.GetFunctionPointerForDelegate(LuaUnityLoadLuaFile);
		LuaManager.Instance.AddUnityFunction(scriptName, "UnityLoadLuaFile", LuaUnityLoadLuaFileIntPtr, LuaUnityLoadLuaFile);
		
		// オブジェクトの破棄
		LuaManager.DelegateLuaBindFunction LuaUnityDestroyObject = new LuaManager.DelegateLuaBindFunction (UnityDestroyObject);
		IntPtr LuaUnityDestroyObjectIntPtr = Marshal.GetFunctionPointerForDelegate(LuaUnityDestroyObject);
		LuaManager.Instance.AddUnityFunction(scriptName, "UnityDestroyObject", LuaUnityDestroyObjectIntPtr, LuaUnityDestroyObject);

		// オブジェクト名のリネーム
		LuaManager.DelegateLuaBindFunction LuaUnityRenameObject = new LuaManager.DelegateLuaBindFunction (UnityRenameObject);
		IntPtr LuaUnityRenameObjectIntPtr = Marshal.GetFunctionPointerForDelegate(LuaUnityRenameObject);
		LuaManager.Instance.AddUnityFunction(scriptName, "UnityRenameObject", LuaUnityRenameObjectIntPtr, LuaUnityRenameObject);
		
		// オブジェクトの検索
		LuaManager.DelegateLuaBindFunction LuaUnityFindObject = new LuaManager.DelegateLuaBindFunction (UnityFindObject);
		IntPtr LuaUnityFindObjectIntPtr = Marshal.GetFunctionPointerForDelegate(LuaUnityFindObject);
		LuaManager.Instance.AddUnityFunction(scriptName, "UnityFindObject", LuaUnityFindObjectIntPtr, LuaUnityFindObject);
		
		// テキストの設定
		LuaManager.DelegateLuaBindFunction LuaUnitySetText = new LuaManager.DelegateLuaBindFunction (UnitySetText);
		IntPtr LuaUnitySetTextIntPtr = Marshal.GetFunctionPointerForDelegate(LuaUnitySetText);
		LuaManager.Instance.AddUnityFunction(scriptName, "UnitySetText", LuaUnitySetTextIntPtr, LuaUnitySetText);
		
		// ポジションの設定
		LuaManager.DelegateLuaBindFunction LuaUnitySetPosition = new LuaManager.DelegateLuaBindFunction (UnitySetPosition);
		IntPtr LuaUnitySetPositionIntPtr = Marshal.GetFunctionPointerForDelegate(LuaUnitySetPosition);
		LuaManager.Instance.AddUnityFunction(scriptName, "UnitySetPosition", LuaUnitySetPositionIntPtr, LuaUnitySetPosition);
		
		// ローテーションの設定
		LuaManager.DelegateLuaBindFunction LuaUnitySetRotate = new LuaManager.DelegateLuaBindFunction (UnitySetRotate);
		IntPtr LuaUnitySetRotateIntPtr = Marshal.GetFunctionPointerForDelegate(LuaUnitySetRotate);
		LuaManager.Instance.AddUnityFunction(scriptName, "UnitySetRotate", LuaUnitySetRotateIntPtr, LuaUnitySetRotate);

		// スケールの設定
		LuaManager.DelegateLuaBindFunction LuaUnitySetScale = new LuaManager.DelegateLuaBindFunction (UnitySetScale);
		IntPtr LuaUnitySetScaleIntPtr = Marshal.GetFunctionPointerForDelegate(LuaUnitySetScale);
		LuaManager.Instance.AddUnityFunction(scriptName, "UnitySetScale", LuaUnitySetScaleIntPtr, LuaUnitySetScale);

		// アクティブの切り替え
		LuaManager.DelegateLuaBindFunction LuaUnitySetActive = new LuaManager.DelegateLuaBindFunction (UnitySetActive);
		IntPtr LuaUnitySetActiveIntPtr = Marshal.GetFunctionPointerForDelegate(LuaUnitySetActive);
		LuaManager.Instance.AddUnityFunction(scriptName, "UnitySetActive", LuaUnitySetActiveIntPtr, LuaUnitySetActive);
		
		// スライダーの量
		LuaManager.DelegateLuaBindFunction LuaUnitySetSliderValue = new LuaManager.DelegateLuaBindFunction (UnitySetSliderValue);
		IntPtr LuaUnitySetSliderValueIntPtr = Marshal.GetFunctionPointerForDelegate(LuaUnitySetSliderValue);
		LuaManager.Instance.AddUnityFunction(scriptName, "UnitySetSliderValue", LuaUnitySetSliderValueIntPtr, LuaUnitySetSliderValue);
		
		// スライダーの最大量
		LuaManager.DelegateLuaBindFunction LuaUnitySetMaxSliderValue = new LuaManager.DelegateLuaBindFunction (UnitySetMaxSliderValue);
		IntPtr LuaUnitySetMaxSliderValueIntPtr = Marshal.GetFunctionPointerForDelegate(LuaUnitySetMaxSliderValue);
		LuaManager.Instance.AddUnityFunction(scriptName, "UnitySetMaxSliderValue", LuaUnitySetMaxSliderValueIntPtr, LuaUnitySetMaxSliderValue);

		// シーン(と呼んでる、オブジェクト)の切り替え
		LuaManager.DelegateLuaBindFunction LuaUnityChangeScene = new LuaManager.DelegateLuaBindFunction (UnityChangeScene);
		IntPtr LuaUnityChangeSceneIntPtr = Marshal.GetFunctionPointerForDelegate(LuaUnityChangeScene);
		LuaManager.Instance.AddUnityFunction(scriptName, "UnityChangeScene", LuaUnityChangeSceneIntPtr, LuaUnityChangeScene);

		// アニメーションを再生する
		LuaManager.DelegateLuaBindFunction LuaUnityPlayAnimator = new LuaManager.DelegateLuaBindFunction (UnityPlayAnimator);
		IntPtr LuaUnityPlayAnimatorIntPtr = Marshal.GetFunctionPointerForDelegate(LuaUnityPlayAnimator);
		LuaManager.Instance.AddUnityFunction(scriptName, "UnityPlayAnimator", LuaUnityPlayAnimatorIntPtr, LuaUnityPlayAnimator);
		
		// アニメーションを一時停止する
		LuaManager.DelegateLuaBindFunction LuaUnityPauseAnimator = new LuaManager.DelegateLuaBindFunction (UnityPauseAnimator);
		IntPtr LuaUnityPauseAnimatorIntPtr = Marshal.GetFunctionPointerForDelegate(LuaUnityPauseAnimator);
		LuaManager.Instance.AddUnityFunction(scriptName, "UnityPauseAnimator", LuaUnityPauseAnimatorIntPtr, LuaUnityPauseAnimator);
		
		// アニメーションの一時停止を解除する
		LuaManager.DelegateLuaBindFunction LuaUnityResumeAnimator = new LuaManager.DelegateLuaBindFunction (UnityResumeAnimator);
		IntPtr LuaUnityResumeAnimatorIntPtr = Marshal.GetFunctionPointerForDelegate(LuaUnityResumeAnimator);
		LuaManager.Instance.AddUnityFunction(scriptName, "UnityResumeAnimator", LuaUnityResumeAnimatorIntPtr, LuaUnityResumeAnimator);
		
		// ボタンのインタラクティブ設定
		LuaManager.DelegateLuaBindFunction LuaUnitySetButtonInteractable = new LuaManager.DelegateLuaBindFunction (UnitySetButtonInteractable);
		IntPtr LuaUnitySetButtonInteractableIntPtr = Marshal.GetFunctionPointerForDelegate(LuaUnitySetButtonInteractable);
		LuaManager.Instance.AddUnityFunction(scriptName, "UnitySetButtonInteractable", LuaUnitySetButtonInteractableIntPtr, LuaUnitySetButtonInteractable);
		
		// 親の設定
		LuaManager.DelegateLuaBindFunction LuaUnitySetParent = new LuaManager.DelegateLuaBindFunction (UnitySetParent);
		IntPtr LuaUnitySetParentIntPtr = Marshal.GetFunctionPointerForDelegate(LuaUnitySetParent);
		LuaManager.Instance.AddUnityFunction(scriptName, "UnitySetParent", LuaUnitySetParentIntPtr, LuaUnitySetParent);

		// プレハブだけの読み込み処理
		LuaManager.DelegateLuaBindFunction LuaUnityLoadPrefabAfter = new LuaManager.DelegateLuaBindFunction (UnityLoadPrefabAfter);
		IntPtr LuaUnityLoadPrefabAfterIntPtr = Marshal.GetFunctionPointerForDelegate(LuaUnityLoadPrefabAfter);
		LuaManager.Instance.AddUnityFunction(scriptName, "UnityLoadPrefabAfter", LuaUnityLoadPrefabAfterIntPtr, LuaUnityLoadPrefabAfter);

		// プレハブの読み込み処理
		LuaManager.DelegateLuaBindFunction LuaUnityLoadPrefab = new LuaManager.DelegateLuaBindFunction (UnityLoadPrefab);
		IntPtr LuaUnityLoadPrefabIntPtr = Marshal.GetFunctionPointerForDelegate(LuaUnityLoadPrefab);
		LuaManager.Instance.AddUnityFunction(scriptName, "UnityLoadPrefab", LuaUnityLoadPrefabIntPtr, LuaUnityLoadPrefab);
		
		// Update（更新処理）登録
		LuaManager.DelegateLuaBindFunction LuaUnityAddCallUpdateScript = new LuaManager.DelegateLuaBindFunction (UnityAddCallUpdateScript);
		IntPtr LuaUnityAddCallUpdateScriptIntPtr = Marshal.GetFunctionPointerForDelegate(LuaUnityAddCallUpdateScript);
		LuaManager.Instance.AddUnityFunction(scriptName, "UnityAddCallUpdateScript", LuaUnityAddCallUpdateScriptIntPtr, LuaUnityAddCallUpdateScript);
		
		// アセットバンドルの読み込み
		LuaManager.DelegateLuaBindFunction LuaUnityLoadAssetBundle = new LuaManager.DelegateLuaBindFunction (UnityLoadAssetBundle);
		IntPtr LuaUnityLoadAssetBundleIntPtr = Marshal.GetFunctionPointerForDelegate(LuaUnityLoadAssetBundle);
		LuaManager.Instance.AddUnityFunction(scriptName, "UnityLoadAssetBundle", LuaUnityLoadAssetBundleIntPtr, LuaUnityLoadAssetBundle);
		
		// Luaスクリプトの保存
		LuaManager.DelegateLuaBindFunction LuaUnitySaveScriptFile = new LuaManager.DelegateLuaBindFunction (UnitySaveScriptFile);
		IntPtr LuaUnitySaveScriptFileIntPtr = Marshal.GetFunctionPointerForDelegate(LuaUnitySaveScriptFile);
		LuaManager.Instance.AddUnityFunction(scriptName, "UnitySaveScriptFile", LuaUnitySaveScriptFileIntPtr, LuaUnitySaveScriptFile);
		
		// アセットバンドルの保存
		LuaManager.DelegateLuaBindFunction LuaUnitySaveAssetBundle = new LuaManager.DelegateLuaBindFunction (UnitySaveAssetBundle);
		IntPtr LuaUnitySaveAssetBundleIntPtr = Marshal.GetFunctionPointerForDelegate(LuaUnitySaveAssetBundle);
		LuaManager.Instance.AddUnityFunction(scriptName, "UnitySaveAssetBundle", LuaUnitySaveAssetBundleIntPtr, LuaUnitySaveAssetBundle);

		// バージョンファイルの保存
		LuaManager.DelegateLuaBindFunction LuaUnitySaveVersionFile = new LuaManager.DelegateLuaBindFunction (UnitySaveVersionFile);
		IntPtr LuaUnitySaveVersionFileIntPtr = Marshal.GetFunctionPointerForDelegate(LuaUnitySaveVersionFile);
		LuaManager.Instance.AddUnityFunction(scriptName, "UnitySaveVersionFile", LuaUnitySaveVersionFileIntPtr, LuaUnitySaveVersionFile);
		
		// 例外処理の呼び出し
		LuaManager.DelegateLuaBindFunction LuaUnityCallExeptionCallback = new LuaManager.DelegateLuaBindFunction (UnityCallExeptionCallback);
		IntPtr LuaUnityCallExeptionCallbackIntPtr = Marshal.GetFunctionPointerForDelegate(LuaUnityCallExeptionCallback);
		LuaManager.Instance.AddUnityFunction(scriptName, "UnityCallExeptionCallback", LuaUnityCallExeptionCallbackIntPtr, LuaUnityCallExeptionCallback);
		
		// Luaの初期化が終わった後のコールバック
		LuaManager.DelegateLuaBindFunction LuaUnityCallLuaMainEndCallback = new LuaManager.DelegateLuaBindFunction (UnityCallLuaMainEndCallback);
		IntPtr LuaUnityCallLuaMainEndCallbackIntPtr = Marshal.GetFunctionPointerForDelegate(LuaUnityCallLuaMainEndCallback);
		LuaManager.Instance.AddUnityFunction(scriptName, "UnityCallLuaMainEndCallback", LuaUnityCallLuaMainEndCallbackIntPtr, LuaUnityCallLuaMainEndCallback);
		
		// サウンド（BGM）の初期化
		LuaManager.DelegateLuaBindFunction LuaUnityAddBGMAudioSourceAndClip = new LuaManager.DelegateLuaBindFunction (UnityAddBGMAudioSourceAndClip);
		IntPtr LuaUnityAddBGMAudioSourceAndClipIntPtr = Marshal.GetFunctionPointerForDelegate(LuaUnityAddBGMAudioSourceAndClip);
		LuaManager.Instance.AddUnityFunction(scriptName, "UnityAddBGMAudioSourceAndClip", LuaUnityAddBGMAudioSourceAndClipIntPtr, LuaUnityAddBGMAudioSourceAndClip);
		
		// サウンド（BGM）の再生
		LuaManager.DelegateLuaBindFunction LuaUnityPlayBGM = new LuaManager.DelegateLuaBindFunction (UnityPlayBGM);
		IntPtr LuaUnityPlayBGMIntPtr = Marshal.GetFunctionPointerForDelegate(LuaUnityPlayBGM);
		LuaManager.Instance.AddUnityFunction(scriptName, "UnityPlayBGM", LuaUnityPlayBGMIntPtr, LuaUnityPlayBGM);
		
		// サウンド（BGM）の停止
		LuaManager.DelegateLuaBindFunction LuaUnityStopBGM = new LuaManager.DelegateLuaBindFunction (UnityStopBGM);
		IntPtr LuaUnityStopBGMIntPtr = Marshal.GetFunctionPointerForDelegate(LuaUnityStopBGM);
		LuaManager.Instance.AddUnityFunction(scriptName, "UnityStopBGM", LuaUnityStopBGMIntPtr, LuaUnityStopBGM);

		// SE用のAudioSourceの作成
		LuaManager.DelegateLuaBindFunction LuaUnityCreateSEAudioSource = new LuaManager.DelegateLuaBindFunction (UnityCreateSEAudioSource);
		IntPtr LuaUnityCreateSEAudioSourceIntPtr = Marshal.GetFunctionPointerForDelegate(LuaUnityCreateSEAudioSource);
		LuaManager.Instance.AddUnityFunction(scriptName, "UnityCreateSEAudioSource", LuaUnityCreateSEAudioSourceIntPtr, LuaUnityCreateSEAudioSource);

		// サウンド（SE）の再生
		LuaManager.DelegateLuaBindFunction LuaUnityPlaySE = new LuaManager.DelegateLuaBindFunction (UnityPlaySE);
		IntPtr LuaUnityPlaySEIntPtr = Marshal.GetFunctionPointerForDelegate(LuaUnityPlaySE);
		LuaManager.Instance.AddUnityFunction(scriptName, "UnityPlaySE", LuaUnityPlaySEIntPtr, LuaUnityPlaySE);

		// コモン関数の登録
		LuaManager.DelegateLuaBindFunction LuaUnityBindCommonFunction = new LuaManager.DelegateLuaBindFunction (UnityBindCommonFunction);
		IntPtr LuaUnityBindCommonFunctionIntPtr = Marshal.GetFunctionPointerForDelegate(LuaUnityBindCommonFunction);
		LuaManager.Instance.AddUnityFunction(scriptName, "UnityBindCommonFunction", LuaUnityBindCommonFunctionIntPtr, LuaUnityBindCommonFunction);
	}
	
	/// <summary>
	/// パスワードから共有キーと初期化ベクタを生成する
	/// </summary>
	/// <param name="password">基になるパスワード</param>
	/// <param name="keySize">共有キーのサイズ（ビット）</param>
	/// <param name="key">作成された共有キー</param>
	/// <param name="blockSize">初期化ベクタのサイズ（ビット）</param>
	/// <param name="iv">作成された初期化ベクタ</param>
	private void GenerateKeyFromPassword(string password, int keySize, out byte[] key, int blockSize, out byte[] iv) {
	    //パスワードから共有キーと初期化ベクタを作成する
	    //saltを決める
		// saltは必ず8バイト以上らしい
	    byte[] salt = System.Text.Encoding.UTF8.GetBytes("abcdefghijklmnopqrstuvwxyabcdefghijklmnopqrstuvwxyabcdefghijklmn");
	    //Rfc2898DeriveBytesオブジェクトを作成する
	    System.Security.Cryptography.Rfc2898DeriveBytes deriveBytes =
	        new System.Security.Cryptography.Rfc2898DeriveBytes(password, salt);
	    //.NET Framework 1.1以下の時は、PasswordDeriveBytesを使用する
	    //System.Security.Cryptography.PasswordDeriveBytes deriveBytes =
	    //    new System.Security.Cryptography.PasswordDeriveBytes(password, salt);
	    //反復処理回数を指定する デフォルトで1000回
	    deriveBytes.IterationCount = 1000;
	
	    //共有キーと初期化ベクタを生成する
	    key = deriveBytes.GetBytes(keySize / 8);
	    iv = deriveBytes.GetBytes(blockSize / 8);
	}

}

