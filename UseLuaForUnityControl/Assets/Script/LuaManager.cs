﻿using UnityEngine;
using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Text;
using System.Runtime.InteropServices;
using LuaDLLTest;

public class LuaManager : SingletonMonoBehaviour<LuaManager>{

	public class FunctionData
	{
		public int returnValueNum;	// 戻り値の数
		public string functionName;	// 呼び出したい関数名
		public ArrayList argList;	// 引数リスト。これがあれば、引数の数も取得可能
	}

	Dictionary<string, IntPtr> mLuaStateMap = null;
	
	void Awake () {
		base.Awake ();
	}
	
	public void Init()
	{
		mLuaStateMap = new Dictionary<string, IntPtr>();
	}

	// LuaStateを使えるようにする初期化みたいな物
	public IntPtr GetLuaState(string filename)
	{
		// すでに登録されている物か、確認する
		if(mLuaStateMap.ContainsKey(filename) == true)
		{
			return mLuaStateMap[filename];
		}

		IntPtr luastate = NativeMethods.luaL_newstate();
		NativeMethods.luaL_openlibs(luastate);

		mLuaStateMap.Add(filename, luastate);
		return luastate;
	}

	public void DestroyManager()
	{
		foreach (KeyValuePair<string, IntPtr> pair in mLuaStateMap) {
			NativeMethods.lua_close(pair.Value);
		}
		mLuaStateMap = null;
	}

	void Update () {
	}

	// LuaScriptを読み込んで、使える状態にする
	// 基本は、呼び出し側で使いたいLuaScriptを指定するはずなので、
	// TextAssetは呼び出し側で作って渡してもらうようにする
	public void LoadLuaScript(TextAsset textasset)
	{
		IntPtr luastate = IntPtr.Zero;
		// すでに登録されている物か、確認する
		if(mLuaStateMap.ContainsKey(textasset.name) == false)
		{
			luastate = GetLuaState(textasset.name);
		}
		else
		{
			luastate = mLuaStateMap[textasset.name];
		}
		
		// Lua読み込み
		int res = NativeMethods.luaL_loadstring (luastate, textasset.text);
		res = NativeMethods.lua_pcallk (luastate, 0, -1, 0);// 読んだら、一回これよばないと正常に機能しない。
	}
	
	// Luaの関数を使う場合には、引数の数と戻り値の数をこちら側から指定する必要がある
	public ArrayList Call(string filename, FunctionData fData)
	{
		IntPtr luastate = IntPtr.Zero;
		// すでに登録されている物か、確認する
		if(mLuaStateMap.ContainsKey(filename) == false)
		{
			luastate = GetLuaState(filename);
		}
		else
		{
			luastate = mLuaStateMap[filename];
		}

		// スタックの初期化のやり方を一応メモしておく
		//NativeMethods.lua_settop (luastate, 0);

		// stateにスタックを積んでいく
		// 関数Add
		NativeMethods.lua_getglobal(luastate, fData.functionName);

		// 引数Add
		for(int i = 0; i < fData.argList.Count; i++)
		{
			var val = fData.argList[i];

			if(val == null)
			{
				NativeMethods.lua_pushnil(luastate);
			}
			else if(val is int)
			{
				NativeMethods.lua_pushvalue(luastate, (int)val);
			}
			else if(val is string)
			{
				NativeMethods.lua_pushstring(luastate, val as string);
			}
			else if(val is IntPtr)
			{
				NativeMethods.lua_pushstdcallcfunction(luastate, (IntPtr)val);
			}
			else if(val is double)
			{
				NativeMethods.lua_pushnumber(luastate, (double)val);
			}
			else if(val is float)
			{
				double arg = (float)val;
				NativeMethods.lua_pushnumber(luastate, arg);
			}
			else if(val is bool)
			{
				int boolnum = 0;
				if((bool)val == true)
				{
					boolnum = 1;
				}
				else
				{
					boolnum = 0;
				}
				NativeMethods.lua_pushboolean(luastate, boolnum);
			}
		}
		
		int res = NativeMethods.lua_pcallk (luastate, fData.argList.Count, fData.returnValueNum, 0);

		ArrayList returnList = new ArrayList();
		getStack(luastate, returnList);

		return returnList;
	}
	
	private void getStack(IntPtr luastate, ArrayList list)
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
				list.Add(res_b);
				break;
			case 2://LuaTypes.LUA_TLIGHTUSERDATA:
				break;
			case 3://LuaTypes.LUA_TNUMBER:
				double res_d = NativeMethods.lua_tonumberx(luastate, i, 0);
				list.Add(res_d);
				break;
			case 4://LuaTypes.LUA_TSTRING:
				uint res;
				IntPtr res_s = NativeMethods.lua_tolstring(luastate, i, out res);
				string resString = Marshal.PtrToStringAnsi(res_s);
				list.Add(resString);
				break;
			case 5://LuaTypes.LUA_TTABLE:
				break;
			case 6://LuaTypes.LUA_TFUNCTION:
				break;
			case 7://LuaTypes.LUA_TUSERDATA:
				break;
			//case LuaTypes.LUA_TTHREAD:
			//	break;
			}
		}
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
	
	// Lua側にUnityの関数を教える
	public void AddUnityFunction(string filename, string functionName, IntPtr functionPointer)
	{
		IntPtr luastate = GetLuaState (filename);
		NativeMethods.lua_pushcclosure (luastate, functionPointer, 0);
		NativeMethods.lua_setglobal (luastate, functionName);
	}
}
