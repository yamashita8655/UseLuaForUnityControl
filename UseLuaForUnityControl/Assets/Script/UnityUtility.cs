using UnityEngine;
using System.Collections;
using System;
using LuaDLLTest;
using System.Runtime.InteropServices;


public class UnityUtility : SingletonMonoBehaviour<UnityUtility> {

	GCHandle gcHandle;
	delegate int DelegateUnityLoadLevel(IntPtr luaState);

	void Awake () {
		base.Awake ();
	}

	public void Init()
	{
		LuaManager.Instance.Init ();
		TextAsset file = Resources.Load<TextAsset>("UnityBind");
		
		LuaManager.Instance.Init ();
		
		// まずは、スクリプトをロードして使える状態にする
		LuaManager.Instance.LoadLuaScript (file);
		
		// Unity関数をLua側に登録する
		// シーンチェンジする奴
		DelegateUnityLoadLevel LuaUnityLoadLevel = new DelegateUnityLoadLevel (UnityLoadLevel);
		IntPtr LuaUnityLoadLevelIntPtr = Marshal.GetFunctionPointerForDelegate(LuaUnityLoadLevel);
		LuaManager.Instance.AddUnityFunction(file.name, "UnityLoadLevel", LuaUnityLoadLevelIntPtr);

		// デバッグログ呼び出す奴
		DelegateUnityLoadLevel LuaUnityDebugLog = new DelegateUnityLoadLevel (UnityDebugLog);
		IntPtr LuaUnityDebugLogIntPtr = Marshal.GetFunctionPointerForDelegate(LuaUnityDebugLog);
		LuaManager.Instance.AddUnityFunction(file.name, "UnityDebugLog", LuaUnityDebugLogIntPtr);
		
		// デバッグログ呼び出す奴
		DelegateUnityLoadLevel LuaUnityTableTest = new DelegateUnityLoadLevel (UnityTableTest);
		IntPtr LuaUnityTableTestIntPtr = Marshal.GetFunctionPointerForDelegate(LuaUnityTableTest);
		LuaManager.Instance.AddUnityFunction(file.name, "UnityTableTest", LuaUnityTableTestIntPtr);

		// Luaの関数に必要な情報を作って、呼び出し
		LuaManager.FunctionData data = new LuaManager.FunctionData();
		data.returnValueNum = 0;
		data.functionName = "LuaLoadLevel";
		ArrayList list = new ArrayList();
		list.Add("NextScene");
		data.argList = list;
		ArrayList returnList = LuaManager.Instance.Call(file.name, data);
		
		LuaManager.FunctionData data2 = new LuaManager.FunctionData();
		data2.returnValueNum = 0;
		data2.functionName = "LuaDebugLog";
		ArrayList list2 = new ArrayList();
		list2.Add("Debug1");
		data2.argList = list2;
		ArrayList returnList2 = LuaManager.Instance.Call(file.name, data2);

		LuaManager.FunctionData data3 = new LuaManager.FunctionData();
		data3.returnValueNum = 0;
		data3.functionName = "LuaTableTest";
		ArrayList list3 = new ArrayList();
		data3.argList = list3;
		ArrayList returnList3 = LuaManager.Instance.Call(file.name, data3);

/*		mLuaState = NativeMethods.luaL_newstate();
		NativeMethods.luaL_openlibs(mLuaState);

		DelegateUnityLoadLevel LuaUnityLoadLevel = new DelegateUnityLoadLevel (UnityLoadLevel);
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

	}

	public int UnityLoadLevel(IntPtr luaState)
	{
		Debug.Log ("UnityLoadLevel");
		uint res;
		IntPtr res_s = NativeMethods.lua_tolstring(luaState, 1, out res);
		string sceneName = Marshal.PtrToStringAnsi(res_s);
		Application.LoadLevel (sceneName);

		return 0;
	}
	
	public int UnityDebugLog(IntPtr luaState)
	{
		Debug.Log ("UnityDebugLog");
		uint res;
		IntPtr res_s = NativeMethods.lua_tolstring(luaState, 1, out res);
		string logstring = Marshal.PtrToStringAnsi(res_s);
		Debug.Log (logstring);

		return 0;
	}

	public int UnityTableTest(IntPtr luaState)
	{
		Debug.Log ("UnityTableTest");
		NativeMethods.lua_getfield(luaState, 1, "1");
		NativeMethods.lua_getfield(luaState, 2, "arg1");
		NativeMethods.lua_getfield(luaState, 2, "arg2");
//		NativeMethods.lua_getfield(luaState, 1, "2");
//		NativeMethods.lua_getfield(luaState, 1, "3");
//		NativeMethods.lua_getfield(luaState, 1, "4");
		LuaManager.Instance.printStack (luaState);

/*		uint res;
		IntPtr res_s = NativeMethods.lua_tolstring(luaState, 1, out res);
		string logstring = Marshal.PtrToStringAnsi(res_s);
		Debug.Log (logstring);*/
		
		return 0;
	}
}


