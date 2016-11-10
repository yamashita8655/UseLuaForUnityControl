using UnityEngine;
using System.Collections;

public class InputEventHandler : MonoBehaviour {
	public void OnClickButton(string eventName) {
		// Lua側にイベント名を渡して、処理する関数を呼び出す
		LuaManager.FunctionData data = new LuaManager.FunctionData();
		data.returnValueNum = 0;
		data.functionName = "EventClickButton";
		ArrayList list = new ArrayList();
		list.Add (eventName);
		data.argList = list;
		ArrayList returnList = LuaManager.Instance.Call(UnityUtility.Instance.scriptName, data);
	}
}

