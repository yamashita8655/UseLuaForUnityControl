using UnityEngine;
using UnityEngine.UI;
using System.Collections;

public class BattleInputEventHandler : MonoBehaviour {

	void Update() {
/*		if (Input.touchCount > 0) {
			Touch touch = Input.GetTouch(0);
			string functionName = "";
			list.Clear();
			if(touch.phase == TouchPhase.Began) {
				functionName = "BattleEventTouchBegan";
				list.Add(touch.position.x);
				list.Add(touch.position.y);
			}
			else if (touch.phase == TouchPhase.Moved) {
				functionName = "BattleEventTouchMoved";
			}
			else if (touch.phase == TouchPhase.Ended) {
				functionName = "BattleEventTouchEnded";
			}
			
			// Lua側にイベント名を渡して、処理する関数を呼び出す
			LuaManager.FunctionData data = new LuaManager.FunctionData();
			data.returnValueNum = 0;
			data.functionName = functionName;
			data.argList = list;
			ArrayList returnList = LuaManager.Instance.Call(UnityUtility.Instance.scriptName, data);
		}*/
	}
	
		void OnMouseDown() {

			//取得したscreenPointの値を変数に格納
        	float x = Input.mousePosition.x;
        	float y = Input.mousePosition.y;

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

