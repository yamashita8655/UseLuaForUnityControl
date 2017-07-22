using UnityEngine;
using System.Collections;

public class ToggleEventHandler : MonoBehaviour {
	public void OnToggleValueChange(bool isOn) {
		string hierarchyName = gameObject.name;
		// Lua側にイベント名を渡して、処理する関数を呼び出す
		LuaManager.FunctionData data = new LuaManager.FunctionData();
		data.returnValueNum = 0;
		data.functionName = "EventToggleValueChangeFromUnity";
		ArrayList list = new ArrayList();
		list.Add(hierarchyName);
		if (isOn == true) {
			list.Add((float)1);// TODO int、LuaManagerで対応してるけど、実際LUA側で認識しないので、アカン
		} else {
			list.Add((float)0);
		}
		data.argList = list;
		ArrayList returnList = LuaManager.Instance.Call(UnityUtility.Instance.scriptName, data);
	}
}

