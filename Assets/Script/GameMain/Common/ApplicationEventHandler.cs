using UnityEngine;
using System.Collections;

public class ApplicationEventHandler : MonoBehaviour {
	private	bool			isSuspended = false;
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

	private void OnApplicationPause(bool isPause) {
		if (isPause) {
			Suspend();
		} else {
			Resume();
		}
	}
	
	private void Suspend() {
		if (isSuspended == true) {
			return;
		}
		isSuspended = true;
		
		LuaManager.FunctionData data = new LuaManager.FunctionData();
		data.returnValueNum = 0;
		data.functionName = "EventSuspendFromUnity";
		ArrayList list = new ArrayList();
		data.argList = list;
		ArrayList returnList = LuaManager.Instance.Call(UnityUtility.Instance.scriptName, data);
	}
	
	private void Resume() {
		if (isSuspended == false) {
			return;
		}
		isSuspended = false;
		
		LuaManager.FunctionData data = new LuaManager.FunctionData();
		data.returnValueNum = 0;
		data.functionName = "EventResumeFromUnity";
		ArrayList list = new ArrayList();
		data.argList = list;
		ArrayList returnList = LuaManager.Instance.Call(UnityUtility.Instance.scriptName, data);
	}
}

