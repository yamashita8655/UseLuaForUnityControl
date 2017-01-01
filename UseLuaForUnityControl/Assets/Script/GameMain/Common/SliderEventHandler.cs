using UnityEngine;
using UnityEngine.UI;
using System.Collections;

public class SliderEventHandler : MonoBehaviour {
	public void OnSliderValueChange(float val) {
		string hierarchyName = gameObject.name;
		// Lua側にイベント名を渡して、処理する関数を呼び出す
		LuaManager.FunctionData data = new LuaManager.FunctionData();
		data.returnValueNum = 0;
		data.functionName = "EventSliderFromUnity";
		ArrayList list = new ArrayList();
		list.Add(hierarchyName);
		list.Add(val);
		data.argList = list;
		ArrayList returnList = LuaManager.Instance.Call(UnityUtility.Instance.scriptName, data);
	}
}

