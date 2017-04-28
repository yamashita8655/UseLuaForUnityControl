using UnityEngine;
using UnityEngine.UI;
using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Text;
using System.Runtime.InteropServices;

using LuaDLLTest;


public class HowToUseLua : MonoBehaviour {

	[SerializeField] Text text;
	// Use this for initialization
	void Start () {

//		test1 ();
//		StartCoroutine(test1_1());
//		test1_2();
		test1_3();
		test1_4();
//		test2 ();
//		test3 ();
//		test4 ();
//		test5 ();
//		test6 ();
//		test7 ();
	}

	void test1()
	{
		// こっちは、何らかの方法でLuaスクリプトをバッファに展開して使うタイプ
		// これが出来たので、アセットバンドルに含めることも可能だと思う
		IntPtr luastate = NativeMethods.luaL_newstate();
		NativeMethods.luaL_openlibs(luastate);// これは、Lua側に必要な基本的な機能を関連付けている

		// Lua読み込み
		TextAsset file = Resources.Load<TextAsset>("load_lua");
		int res = NativeMethods.luaL_loadstring (luastate, file.text);
		res = NativeMethods.lua_pcallk (luastate, 0, -1, 0);// これで、LuaStateにLuaScriptの関連付けが終わる

		// スタック数を確認する
		int num = NativeMethods.lua_gettop (luastate);

		// Luaに定義されているグローバルの値を指定して、スタックに積む
		NativeMethods.lua_getglobal (luastate, "windowWidth");
		NativeMethods.lua_getglobal (luastate, "windowHeight");
		NativeMethods.lua_getglobal (luastate, "windowName");
		NativeMethods.lua_getglobal (luastate, "testboolean");

		num = NativeMethods.lua_gettop (luastate);

		// 実際にスタックに積まれている数値を習得する
		double res_width = NativeMethods.lua_tonumberx(luastate, 1, 0);
		double res_height = NativeMethods.lua_tonumberx(luastate, 2, 0);
		uint output;
		IntPtr res_s = NativeMethods.lua_tolstring(luastate, 3, out output);
		string resString = Marshal.PtrToStringAnsi(res_s);
		int res_bool = NativeMethods.lua_toboolean(luastate, 4);//true=1 false=0
	}

	public IEnumerator test1_1()
	{
		WWW www = new WWW("http://natural-nail-eye.sakura.ne.jp/BaseMoveController.lua");
		while (www.isDone == false) {
			yield return null;
		}
		text.text = www.text;
	}

	public void test1_2() {
	}

	public void test1_3()
	{
		RijindaelManager.Instance.Init();
		
		string output = RijindaelManager.Instance.CreateEncryptorString("あいうえおaiueo\naaa");

		FileStream fs = new FileStream ("C:/Users/tyamashita/AppData/LocalLow/DefaultCompany/UseLuaForUnityControl/sample.dat", FileMode.Create);
		BinaryWriter bw = new BinaryWriter (fs);
		bw.Write (output);
		bw.Close ();
		fs.Close ();


	}

	void test1_4()
	{
		FileStream fs = new FileStream("C:/Users/tyamashita/AppData/LocalLow/DefaultCompany/UseLuaForUnityControl/sample.dat", FileMode.Open);
    	BinaryReader br = new BinaryReader(fs);
    	string str = br.ReadString();
    	
    	br.Close();
    	fs.Close();

		string output = RijindaelManager.Instance.CreateDecryptorString(str);

		Debug.Log(output);

	}
	
	void test2()
	{
		// こっちは、何らかの方法でLuaスクリプトをバッファに展開して使うタイプ
		// これが出来たので、アセットバンドルに含めることも可能だと思う
		IntPtr luastate = NativeMethods.luaL_newstate();
		NativeMethods.luaL_openlibs(luastate);// これは、Lua側に必要な基本的な機能を関連付けている
		
		// Lua読み込み
		TextAsset file = Resources.Load<TextAsset>("function_lua");
		int res = NativeMethods.luaL_loadstring (luastate, file.text);
		res = NativeMethods.lua_pcallk (luastate, 0, -1, 0);// これで、LuaStateにLuaScriptの関連付けが終わる

		// Luaで定義した関数をスタックに積む。Luaは関数も変数のひとつに過ぎないらしい
		NativeMethods.lua_getglobal(luastate, "calc");
		// 関数に指定する引数をスタックに積む
		NativeMethods.lua_pushnumber(luastate, 100);
		NativeMethods.lua_pushnumber(luastate, 200);

		int num = NativeMethods.lua_gettop (luastate);

		// 関数呼び出し。
		res = NativeMethods.lua_pcallk (luastate, 2, 4, 0);// 引数の数と、戻り値の数を指定しなければならない

		num = NativeMethods.lua_gettop (luastate);

		// 戻り値がスタックに積まれているので、取得
		double add_res = NativeMethods.lua_tonumberx(luastate, 1, 0);
		double sub_res = NativeMethods.lua_tonumberx(luastate, 2, 0);
		double mult_res = NativeMethods.lua_tonumberx(luastate, 3, 0);
		double dev_res = NativeMethods.lua_tonumberx(luastate, 4, 0);
	}

	// コルーチンテスト
	IntPtr cotest_State;
	IntPtr co;
	void test3()
	{
		cotest_State = NativeMethods.luaL_newstate();
		NativeMethods.luaL_openlibs(cotest_State);// これは、Lua側に必要な基本的な機能を関連付けている

		// Lua読み込み
		TextAsset file = Resources.Load<TextAsset>("coroutine");
		int res = NativeMethods.luaL_loadstring (cotest_State, file.text);
		res = NativeMethods.lua_pcallk (cotest_State, 0, -1, 0);// これで、LuaStateにLuaScriptの関連付けが終わる

		co = NativeMethods.lua_newthread(cotest_State);
		NativeMethods.lua_getglobal(co, "step");

		res = NativeMethods.lua_resume (co, cotest_State, 0);
		printStack (co);


/*		cotest_State = Lua.LuaOpen ();
		Lua.LuaOpenBase(cotest_State);
		int res = Lua.LuaLLoadFile (cotest_State, Application.persistentDataPath + "/" + "coroutine.lua");
		Lua.LuaPCall(cotest_State, 0, Lua.LUA_MULTRET, 0);

		co = Lua.LuaNewThread(cotest_State);
		Lua.LuaGetGlobal(co, "step");

//		printStack(co);

//		res = Lua.LuaResume (co, 0);

		//Lua.LuaClose (cotest_State);
		//printStack(cotest_State);*/
	}

	// LuaからC#に関数を呼び出す
	public delegate int DelegateLuaBindFunction(IntPtr luaState);// Luaが解釈できる関数の型は、これだけ。intを戻すIntPtrを引数に一つ持つ関数のみ。
	DelegateLuaBindFunction LuaUnityDebugLog;// で、これはC#側で静的な場所に保持しておかないと、test4を抜けた時点でガベコレ対象になるので、保持しておく
	DelegateLuaBindFunction LuaUnityDebugLogUseArg;// 当然、ガベコレ食らった関数ポインタをLuaがアクセスすると動作不定になる
	void test4()
	{
		IntPtr luastate = NativeMethods.luaL_newstate();
		NativeMethods.luaL_openlibs(luastate);// これは、Lua側に必要な基本的な機能を関連付けている
		
		// Lua読み込み
		TextAsset file = Resources.Load<TextAsset>("UnityFunction");
		int res = NativeMethods.luaL_loadstring (luastate, file.text);
		res = NativeMethods.lua_pcallk (luastate, 0, -1, 0);// これで、LuaStateにLuaScriptの関連付けが終わる

		// Lua側にC#の関数を登録する（多分、C#の関数のポインタを渡して、Lua側からもアドレスにAccess出来るようにしてるんだと思う）
		LuaUnityDebugLog = new DelegateLuaBindFunction (UnityDebugLog);
		IntPtr LuaUnityDebugLogIntPtr = Marshal.GetFunctionPointerForDelegate (LuaUnityDebugLog);// これが例のIOSで使えない関数ね
		int num = NativeMethods.lua_gettop (luastate);
		NativeMethods.lua_pushcclosure (luastate, LuaUnityDebugLogIntPtr, 0);
		num = NativeMethods.lua_gettop (luastate);
		NativeMethods.lua_setglobal (luastate, "UnityDebugLog");
		num = NativeMethods.lua_gettop (luastate);

		// Luaで定義した関数をスタックに積む。Luaは関数も変数のひとつに過ぎないらしい
		NativeMethods.lua_getglobal(luastate, "CallUnityDebugLog");
		// 関数呼び出し。
		res = NativeMethods.lua_pcallk (luastate, 0, 0, 0);// 引数の数と、戻り値の数を指定しなければならない
		num = NativeMethods.lua_gettop (luastate);


		// ここから引数ありの方
		// Lua側にC#の関数を登録する（多分、C#の関数のポインタを渡して、Lua側からもアドレスにAccess出来るようにしてるんだと思う）
/*		LuaUnityDebugLogUseArg = new DelegateLuaBindFunction (UnityDebugLogUseArg);
		IntPtr LuaUnityDebugLogUseArgIntPtr = Marshal.GetFunctionPointerForDelegate (LuaUnityDebugLogUseArg);// これが例のIOSで使えない関数ね
		NativeMethods.lua_pushcclosure (luastate, LuaUnityDebugLogUseArgIntPtr, 0);
		NativeMethods.lua_setglobal (luastate, "UnityDebugLogUseArg");

		// Luaで定義した関数をスタックに積む。Luaは関数も変数のひとつに過ぎないらしい
		NativeMethods.lua_getglobal(luastate, "CallUnityDebugLogUseArg");
		NativeMethods.lua_pushstring(luastate, "C#から渡した引数文字列だよ");

		// 関数呼び出し。
		res = NativeMethods.lua_pcallk (luastate, 1, 0, 0);// 引数の数と、戻り値の数を指定しなければならない*/
	}

	// Update is called once per frame
	void Update () {
		if (Input.GetMouseButtonDown (0)) {
			Debug.Log ("click");

			if(cotest_State != IntPtr.Zero)
			{
				if(NativeMethods.lua_resume (co, cotest_State, 0) != 0)
				{
					printStack(co);
				}
				else
				{
					NativeMethods.lua_close (cotest_State);
					cotest_State = IntPtr.Zero;
				}
			}
		}
	}

	// Luaがわかる関数は、intを返すSystem.IntPtrを一つ引数に持つ関数のみ
	int UnityDebugLog(System.IntPtr L)
	{
		printStack (L);
		Debug.Log ("Luaから呼ばれたUnityDebugLog");
		uint output;
		IntPtr res_s = NativeMethods.lua_tolstring(L, 1, out output);
		string resString = Marshal.PtrToStringAnsi(res_s);

		NativeMethods.lua_settop(L, 0);
		NativeMethods.lua_pushstring(L, "pushstring1");
		NativeMethods.lua_pushstring(L, "pushstring2");
		printStack (L);
		Debug.Log (resString);
		return 1;
	}

	int UnityDebugLogUseArg(System.IntPtr L)
	{
		uint output;
		IntPtr res_s = NativeMethods.lua_tolstring(L, 1, out output);
		string resString = Marshal.PtrToStringAnsi(res_s);
		Debug.Log (resString);

		return 0;
	}

	public void printStack(IntPtr luastate)
	{
		int num = NativeMethods.lua_gettop (luastate);
		Debug.Log ("count = " + num);
		if(num==0)
		{
			return;
		}
		
		for(int i = num; i >= 1; i--)
		{
			int type = NativeMethods.lua_type(luastate, i);
			
			switch(type) {
			case 0://LuaTypes.LUA_TNIL:
				break;
			case 1://LuaTypes.LUA_TBOOLEAN:
				int res_b = NativeMethods.lua_toboolean(luastate, i);
				Debug.Log ("LUA_TBOOLEAN : " + res_b);
				break;
			case 2://LuaTypes.LUA_TLIGHTUSERDATA:
				break;
			case 3://LuaTypes.LUA_TNUMBER:
				double res_d = NativeMethods.lua_tonumberx(luastate, i, 0);
				Debug.Log ("LUA_TNUMBER : " + res_d);
				break;
			case 4://LuaTypes.LUA_TSTRING:
				uint res;
				IntPtr res_s = NativeMethods.lua_tolstring(luastate, i, out res);
				string resString = Marshal.PtrToStringAnsi(res_s);
				Debug.Log ("LUA_TSTRING : " + resString);
				break;
			case 5://LuaTypes.LUA_TTABLE:
				Debug.Log ("LUA_TTABLE : ");
				break;
			case 6://LuaTypes.LUA_TFUNCTION:
				Debug.Log ("LUA_TFUNCTION : ");
				break;
			case 7://LuaTypes.LUA_TUSERDATA:
				Debug.Log ("LUA_TUSERDATA : ");
				break;
				//case LuaTypes.LUA_TTHREAD:
				//	break;
			}
		}
	}

	void test5()
	{
		// こっちは、何らかの方法でLuaスクリプトをバッファに展開して使うタイプ
		// これが出来たので、アセットバンドルに含めることも可能だと思う
		IntPtr luastate = NativeMethods.luaL_newstate();
		NativeMethods.luaL_openlibs(luastate);// これは、Lua側に必要な基本的な機能を関連付けている
		
		// Lua読み込み
		TextAsset file = Resources.Load<TextAsset>("main");
		int res = NativeMethods.luaL_loadstring (luastate, file.text);
		res = NativeMethods.lua_pcallk (luastate, 0, -1, 0);// これで、LuaStateにLuaScriptの関連付けが終わる

		// 試しに2個読み込んでみる
		TextAsset file2 = Resources.Load<TextAsset>("function");
		res = NativeMethods.luaL_loadstring (luastate, file2.text);
		res = NativeMethods.lua_pcallk (luastate, 0, -1, 0);// これで、LuaStateにLuaScriptの関連付けが終わる

		// Luaで定義した関数をスタックに積む。Luaは関数も変数のひとつに過ぎないらしい
		NativeMethods.lua_getglobal(luastate, "FunctionDebugLog");
		// 関数呼び出し。
		res = NativeMethods.lua_pcallk (luastate, 0, 1, 0);// 引数の数と、戻り値の数を指定しなければならない

		uint strint_res;
		IntPtr res_s = NativeMethods.lua_tolstring(luastate, 1, out strint_res);
		string resString = Marshal.PtrToStringAnsi(res_s);
		Debug.Log ("LUA_TSTRING : " + resString);
	}

	// 自作したLua.dllでluaInterface/Luanetが使えるものなのか試してみる
	void test6()
	{
		// こっちは、何らかの方法でLuaスクリプトをバッファに展開して使うタイプ
		// これが出来たので、アセットバンドルに含めることも可能だと思う
		IntPtr luastate = NativeMethods.luaL_newstate();
		NativeMethods.luaL_openlibs(luastate);// これは、Lua側に必要な基本的な機能を関連付けている
		
		// Lua読み込み
		TextAsset file = Resources.Load<TextAsset>("use_luainterface");
		int res = NativeMethods.luaL_loadstring (luastate, file.text);
		res = NativeMethods.lua_pcallk (luastate, 0, -1, 0);// これで、LuaStateにLuaScriptの関連付けが終わる

		// Luaで定義した関数をスタックに積む。Luaは関数も変数のひとつに過ぎないらしい
		NativeMethods.lua_getglobal(luastate, "MainDebugLog");
		// 関数呼び出し。
		res = NativeMethods.lua_pcallk (luastate, 0, 1, 0);// 引数の数と、戻り値の数を指定しなければならない
		
		uint strint_res;
		IntPtr res_s = NativeMethods.lua_tolstring(luastate, 1, out strint_res);
		string resString = Marshal.PtrToStringAnsi(res_s);
		Debug.Log ("LUA_TSTRING : " + resString);
	}

	void test7()
	{
		// こっちは、何らかの方法でLuaスクリプトをバッファに展開して使うタイプ
		// これが出来たので、アセットバンドルに含めることも可能だと思う
		IntPtr luastate = NativeMethods.luaL_newstate();
		NativeMethods.luaL_openlibs(luastate);// これは、Lua側に必要な基本的な機能を関連付けている

		// Lua読み込み
		TextAsset file = Resources.Load<TextAsset>("LuaTestCaller");
		int res = NativeMethods.luaL_loadstring (luastate, file.text);
		res = NativeMethods.lua_pcallk (luastate, 0, -1, 0);// これで、LuaStateにLuaScriptの関連付けが終わる

		// Luaで定義した関数をスタックに積む。Luaは関数も変数のひとつに過ぎないらしい
		NativeMethods.lua_getglobal(luastate, "TestCall");
//		NativeMethods.lua_getglobal(luastate, "TestReturnValue");

		int num = NativeMethods.lua_gettop (luastate);

		// 関数呼び出し。
		res = NativeMethods.lua_pcallk (luastate, 0, 1, 0);// 引数の数と、戻り値の数を指定しなければならない

		num = NativeMethods.lua_gettop (luastate);

		// 戻り値がスタックに積まれているので、取得
		double value = NativeMethods.lua_tonumberx(luastate, 1, 0);
		Debug.Log (value);
		text.text = value.ToString();
	}

}

