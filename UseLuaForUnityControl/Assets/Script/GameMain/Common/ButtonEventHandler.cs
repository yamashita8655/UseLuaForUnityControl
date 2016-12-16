using UnityEngine;
using System.Collections;

public class ButtonEventHandler : MonoBehaviour {
	public void OnClickButton() {
		string hierarchyName = gameObject.name;
		// Lua側にイベント名を渡して、処理する関数を呼び出す
		LuaManager.FunctionData data = new LuaManager.FunctionData();
		data.returnValueNum = 0;
		data.functionName = "EventClickButtonFromUnity";
		ArrayList list = new ArrayList();
		list.Add(hierarchyName);
		data.argList = list;
		ArrayList returnList = LuaManager.Instance.Call(UnityUtility.Instance.scriptName, data);
	}
}

