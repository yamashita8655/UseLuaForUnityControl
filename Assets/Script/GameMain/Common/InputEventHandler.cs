using UnityEngine;
using UnityEngine.UI;
using System.Collections;

public class InputEventHandler : MonoBehaviour {

	void OnMouseDown() {

		//取得したscreenPointの値を変数に格納
		float x = Input.mousePosition.x;
		float y = Input.mousePosition.y;
		
		Debug.Log ("x:"+x+" y:"+y);

		// Lua側にイベント名を渡して、処理する関数を呼び出す
		ArrayList list = new ArrayList();
		LuaManager.FunctionData data = new LuaManager.FunctionData();
		data.returnValueNum = 0;
		data.functionName = "OnMouseDownFromUnity";
		list.Add(x);
		list.Add(y);
		data.argList = list;
		ArrayList returnList = LuaManager.Instance.Call(UnityUtility.Instance.scriptName, data);
	}

	void OnMouseDrag() {
		//取得したscreenPointの値を変数に格納
		float x = Input.mousePosition.x;
		float y = Input.mousePosition.y;

		// Lua側にイベント名を渡して、処理する関数を呼び出す
		ArrayList list = new ArrayList();
		LuaManager.FunctionData data = new LuaManager.FunctionData();
		data.returnValueNum = 0;
		data.functionName = "OnMouseDragFromUnity";
		list.Add(x);
		list.Add(y);
		data.argList = list;
		ArrayList returnList = LuaManager.Instance.Call(UnityUtility.Instance.scriptName, data);
	}
	
	void OnMouseUp() {
		//取得したscreenPointの値を変数に格納
		float x = Input.mousePosition.x;
		float y = Input.mousePosition.y;

		// Lua側にイベント名を渡して、処理する関数を呼び出す
		ArrayList list = new ArrayList();
		LuaManager.FunctionData data = new LuaManager.FunctionData();
		data.returnValueNum = 0;
		data.functionName = "OnMouseUpFromUnity";
		list.Add(x);
		list.Add(y);
		data.argList = list;
		ArrayList returnList = LuaManager.Instance.Call(UnityUtility.Instance.scriptName, data);
	}
}

