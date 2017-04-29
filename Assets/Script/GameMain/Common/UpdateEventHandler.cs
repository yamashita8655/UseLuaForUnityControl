using UnityEngine;
using UnityEngine.UI;
using System.Collections;

public class UpdateEventHandler : MonoBehaviour {

	void Update() {
		// Lua側にイベント名を渡して、処理する関数を呼び出す
		ArrayList list = new ArrayList();
		list.Add(Time.deltaTime);
		LuaManager.FunctionData data = new LuaManager.FunctionData();
		data.returnValueNum = 0;
		data.functionName = "UpdateFromUnity";
		data.argList = list;
		ArrayList returnList = LuaManager.Instance.Call(UnityUtility.Instance.scriptName, data);
	}
}

