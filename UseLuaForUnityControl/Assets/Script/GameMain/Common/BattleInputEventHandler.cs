using UnityEngine;
using UnityEngine.UI;
using System.Collections;

public class BattleInputEventHandler : MonoBehaviour {

	void Update() {
		// Lua側にイベント名を渡して、処理する関数を呼び出す
		ArrayList list = new ArrayList();
		LuaManager.FunctionData data = new LuaManager.FunctionData();
		data.returnValueNum = 0;
		data.functionName = "BattleUpdate";
		data.argList = list;
		ArrayList returnList = LuaManager.Instance.Call(UnityUtility.Instance.scriptName, data);
	}
	
	void OnMouseDown() {

		//取得したscreenPointの値を変数に格納
		float x = Input.mousePosition.x;
		float y = Input.mousePosition.y;
				Debug.Log (string.Format("{0}/{1}", x,y));

		// Lua側にイベント名を渡して、処理する関数を呼び出す
		ArrayList list = new ArrayList();
		LuaManager.FunctionData data = new LuaManager.FunctionData();
		data.returnValueNum = 0;
		data.functionName = "BattleOnMouseDown";
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
		data.functionName = "BattleOnMouseDrag";
		list.Add(x);
		list.Add(y);
		data.argList = list;
		ArrayList returnList = LuaManager.Instance.Call(UnityUtility.Instance.scriptName, data);
	}
}

