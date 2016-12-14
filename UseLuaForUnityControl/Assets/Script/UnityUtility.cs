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

	
	Dictionary<string, GameObject> GameObjectCacheDict = new Dictionary<string, GameObject>();

	public class MonoPInvokeCallbackAttribute : System.Attribute
	{
		private Type type;
		public MonoPInvokeCallbackAttribute( Type t ) { type = t; }
	}

	LuaManager.DelegateLuaBindFunction method1 = null;
	
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
	
		ResourceManager.Instance.AddLoaderData(loadpath, savepath, callbackName);
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

		CutinControllerBase contoller = retObj.GetComponent<CutinControllerBase>();
		contoller.Play(animationName, isLoop, isAutoActiveFalse, () => {
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
		
		return 0;
	}

	// プレハブを読み込む
	[MonoPInvokeCallbackAttribute(typeof(LuaManager.DelegateLuaBindFunction))]
	public static int UnityLoadPrefabAfter(IntPtr luaState)
	{
		uint res;
		IntPtr res_s = NativeMethods.lua_tolstring(luaState, 1, out res);
		string prefabname = Marshal.PtrToStringAnsi(res_s);
		
		IntPtr res_objectName = NativeMethods.lua_tolstring(luaState, 2, out res);
		string objectName = Marshal.PtrToStringAnsi(res_objectName);

		string ext = Path.GetExtension(prefabname);
		string path = prefabname.Substring(0, prefabname.Length - ext.Length);
		GameObject retObj = GameObjectCacheManager.Instance.LoadGameObject(path, objectName);
		//retObj.SetActive(false);
		
		res_s = NativeMethods.lua_tolstring(luaState, 3, out res);
		string parentObjectName = Marshal.PtrToStringAnsi(res_s);
		
		GameObject parent = GameObjectCacheManager.Instance.FindGameObject(parentObjectName);
		retObj.transform.SetParent(parent.transform);
		retObj.GetComponent<RectTransform>().anchoredPosition3D = Vector3.zero;
//		retObj.transform.localPosition = Vector3.zero;
		retObj.transform.localScale	= Vector3.one;

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
		GameSceneManager.Instance.ChangeScene(sceneName, parent);

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
		LuaManager.Instance.LoadLuaScript (file);
		
		return 0;
	}
	
	// Lua側のCavManagerの初期化
	[MonoPInvokeCallbackAttribute(typeof(LuaManager.DelegateLuaBindFunction))]
	public static int UnityInitCsvManager(IntPtr luaState)
	{
		uint res;
		IntPtr res_s = NativeMethods.lua_tolstring(luaState, 1, out res);
		string luaFileName = Marshal.PtrToStringAnsi(res_s);
		
		// Unity関数をLua側に登録する
		BindCommonFunction ("CsvManager");
		
		LuaManager.DelegateLuaBindFunction LuaUnityLoadCsv = new LuaManager.DelegateLuaBindFunction (UnityLoadCsv);
		IntPtr LuaUnityLoadCsvIntPtr = Marshal.GetFunctionPointerForDelegate(LuaUnityLoadCsv);
		LuaManager.Instance.AddUnityFunction(luaFileName, "UnityLoadCsv", LuaUnityLoadCsvIntPtr, LuaUnityLoadCsv);
		
		// LuaのCsvManagerの初期化処理を呼び出す
		LuaManager.FunctionData datacsv = new LuaManager.FunctionData();
		datacsv.returnValueNum = 0;
		datacsv.functionName = "LoadCsv";
		ArrayList listcsv = new ArrayList();
		datacsv.argList = listcsv;
		ArrayList returnListcsv = LuaManager.Instance.Call("CsvManager", datacsv);
		
		return 0;
	}
	
	[MonoPInvokeCallbackAttribute(typeof(LuaManager.DelegateLuaBindFunction))]
	public static int UnityLoadCsv(IntPtr luastate)
	{
		uint res;
		IntPtr res_s = NativeMethods.lua_tolstring(luastate, 1, out res);
		string csvname = Marshal.PtrToStringAnsi(res_s);
		string ext = Path.GetExtension(csvname);
		TextAsset csvloadscript = Resources.Load<TextAsset>(csvname.Substring(0, csvname.Length - ext.Length));
		
		// CSVロード関数を呼び出す
		LuaManager.FunctionData data = new LuaManager.FunctionData();
		data.returnValueNum = 0;
		data.functionName = "ParseCsvResource";
		ArrayList list = new ArrayList();
		list.Add (csvloadscript.name);
		list.Add (csvloadscript.text);
		data.argList = list;
		ArrayList returnList = LuaManager.Instance.Call("CsvManager", data);
		return 0;
	}
	
	// LuaScriptの関数を呼び出す
	// 主に、別ファイル間で関数を呼び出したい時に使う
	// 引数対応は、今度する（テーブル渡せば可変で渡せる）
	[MonoPInvokeCallbackAttribute(typeof(LuaManager.DelegateLuaBindFunction))]
	public static int UnityCallLuaFunction(IntPtr luastate)
	{
		uint res;
		IntPtr res_s = NativeMethods.lua_tolstring(luastate, 1, out res);
		string csvname = Marshal.PtrToStringAnsi(res_s);
		string ext = Path.GetExtension(csvname);
		csvname = csvname.Substring(0, csvname.Length - ext.Length);
		
		res_s = NativeMethods.lua_tolstring(luastate, 2, out res);
		string functionName = Marshal.PtrToStringAnsi(res_s);
		
		
		// 関数を呼び出す
		LuaManager.FunctionData data = new LuaManager.FunctionData();
		data.returnValueNum = 0;
		data.functionName = functionName;
		ArrayList list = new ArrayList();
		data.argList = list;
		ArrayList returnList = LuaManager.Instance.Call(csvname, data);
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
	public string scriptName = "UnityBindTest";

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
		string streamingAssetsPath = "";
#if UNITY_EDITOR
		streamingAssetsPath = "file:///" + Application.streamingAssetsPath;
#elif UNITY_ANDROID
		streamingAssetsPath = Application.streamingAssetsPath;
#endif
		list.Add(streamingAssetsPath);
		list.Add(Application.persistentDataPath);
		data.argList = list;
		ArrayList returnList = LuaManager.Instance.Call(scriptName, data);
	}

	public void Init()
	{
		mLuaCallUpdateMap = new Dictionary<string, string>();
		
		LuaManager.Instance.Init ();
		TextAsset file = Resources.Load<TextAsset>(scriptName);

		// まずは、スクリプトをロードして使える状態にする
		LuaManager.Instance.LoadLuaScript (file);
		
		// Unity関数をLua側に登録する
		BindCommonFunction (scriptName);

		// LuaのCsvManager初期化処理
/*		LuaManager.DelegateLuaBindFunction LuaUnityInitCsvManager = new LuaManager.DelegateLuaBindFunction (UnityInitCsvManager);
		IntPtr LuaUnityInitCsvManagerIntPtr = Marshal.GetFunctionPointerForDelegate(LuaUnityInitCsvManager);
		LuaManager.Instance.AddUnityFunction(file.name, "UnityInitCsvManager", LuaUnityInitCsvManagerIntPtr, LuaUnityInitCsvManager);*/

/*		mLuaState = NativeMethods.luaL_newstate();
		NativeMethods.luaL_openlibs(mLuaState);

		DelegateLuaBindFunction LuaUnityLoadLevel = new DelegateLuaBindFunction (UnityLoadLevel);
		IntPtr LuaUnityLoadLevelIntPtr = Marshal.GetFunctionPointerForDelegate(LuaUnityLoadLevel);
		//関数ポインタが指しているデリゲートがGCに回収されないようメモリを確保するらしい
//		gcHandle = GCHandle.Alloc(LuaUnityLoadLevel);

		// ここはアセットバンドルで読み込んだリソースを使う方向に変更する必要があると思うよ
		TextAsset file = Resources.Load<TextAsset>("UnityBind");
		NativeMethods.luaL_loadstring (mLuaState, file.text);
		NativeMethods.lua_pcallk (mLuaState, 0, -1, 0);

		NativeMethods.lua_pushcclosure (mLuaState, LuaUnityLoadLevelIntPtr, 0);
		NativeMethods.lua_setglobal (mLuaState, "UnityLoadLevel");
		
		// 関数呼び出したと仮定
		NativeMethods.lua_getglobal(mLuaState, "LuaLoadLevel");
		NativeMethods.lua_pushstring(mLuaState, "NextScene");
		int res = NativeMethods.lua_pcallk (mLuaState, 1, 0, 0);*/

		// Lua側のメイン関数を呼び出す
		LuaManager.FunctionData data = new LuaManager.FunctionData();
		data.returnValueNum = 0;
		data.functionName = "LuaMain";
		ArrayList list = new ArrayList();
		data.argList = list;
		ArrayList returnList = LuaManager.Instance.Call(scriptName, data);

		// 仮 Androidで、StreamingAsstesの物を、アクセスできる場所にコピーする処理
/*#if UNITY_ANDROID
				string path = Application.streamingAssetsPath + "/LuaUtility.lua";
				WWW www = new WWW(path);
				while(!www.isDone){
				}

				string toPath = Application.persistentDataPath + "/LuaUtility.lua";

				File.WriteAllBytes(toPath, www.bytes);
#endif*/
	}

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
		// デバッグログ
		LuaManager.DelegateLuaBindFunction LuaUnityDebugLog = new LuaManager.DelegateLuaBindFunction (UnityDebugLog);
		IntPtr LuaUnityDebugLogIntPtr = Marshal.GetFunctionPointerForDelegate(LuaUnityDebugLog);
		LuaManager.Instance.AddUnityFunction(scriptName, "UnityDebugLog", LuaUnityDebugLogIntPtr, LuaUnityDebugLog);
		
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

		// シーン(と呼んでる、オブジェクト)の切り替え
		LuaManager.DelegateLuaBindFunction LuaUnityChangeScene = new LuaManager.DelegateLuaBindFunction (UnityChangeScene);
		IntPtr LuaUnityChangeSceneIntPtr = Marshal.GetFunctionPointerForDelegate(LuaUnityChangeScene);
		LuaManager.Instance.AddUnityFunction(scriptName, "UnityChangeScene", LuaUnityChangeSceneIntPtr, LuaUnityChangeScene);

		// アニメーションを再生する
		LuaManager.DelegateLuaBindFunction LuaUnityPlayAnimator = new LuaManager.DelegateLuaBindFunction (UnityPlayAnimator);
		IntPtr LuaUnityPlayAnimatorIntPtr = Marshal.GetFunctionPointerForDelegate(LuaUnityPlayAnimator);
		LuaManager.Instance.AddUnityFunction(scriptName, "UnityPlayAnimator", LuaUnityPlayAnimatorIntPtr, LuaUnityPlayAnimator);

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
		
		// 関数呼び出し
		LuaManager.DelegateLuaBindFunction LuaUnityCallLuaFunction = new LuaManager.DelegateLuaBindFunction (UnityCallLuaFunction);
		IntPtr LuaUnityCallLuaFunctionIntPtr = Marshal.GetFunctionPointerForDelegate(LuaUnityCallLuaFunction);
		LuaManager.Instance.AddUnityFunction(scriptName, "UnityCallLuaFunction", LuaUnityCallLuaFunctionIntPtr, LuaUnityCallLuaFunction);
		
		// コモン関数の登録
		LuaManager.DelegateLuaBindFunction LuaUnityBindCommonFunction = new LuaManager.DelegateLuaBindFunction (UnityBindCommonFunction);
		IntPtr LuaUnityBindCommonFunctionIntPtr = Marshal.GetFunctionPointerForDelegate(LuaUnityBindCommonFunction);
		LuaManager.Instance.AddUnityFunction(scriptName, "UnityBindCommonFunction", LuaUnityBindCommonFunctionIntPtr, LuaUnityBindCommonFunction);
	}

}

