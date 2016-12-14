using UnityEngine;
using System.Collections;

public class LuaCheckConditions : MonoBehaviour {

	// Use this for initialization
	void Start () {
		LuaManager.Instance.Init ();
		TextAsset file = Resources.Load<TextAsset>("LuaCheckConditions");
		LuaManager.Instance.LoadLuaScript (file.text, file.name);

		UnityUtility.BindCommonFunction ("LuaCheckConditions");
	}
	
	// Update is called once per frame
	void Update () {
		
		// 通常攻撃
		if(Input.GetMouseButtonDown(0))
		{
			LuaManager.FunctionData data = new LuaManager.FunctionData();
			data.returnValueNum = 1;
			data.functionName = "CalcNormalAttackDamage";
			ArrayList list = new ArrayList();
			// int値うまくつかえないから、とりあえずFloatで代用
			list.Add(100f);
			list.Add(10f);
			list.Add(1f);
			list.Add(100f);
			list.Add(10f);
			list.Add(1f);
			data.argList = list;
			ArrayList returnList = LuaManager.Instance.Call("LuaCheckConditions", data);

			double damage = (double)(returnList[0]);
		}
		
		// スペシャル攻撃
		if(Input.GetMouseButtonDown(1))
		{
			LuaManager.FunctionData data = new LuaManager.FunctionData();
			data.returnValueNum = 2;
			data.functionName = "CalcSpecialAttackDamage";
			ArrayList list = new ArrayList();
			list.Add(100f);
			list.Add(10f);
			list.Add(1f);
			list.Add(100f);
			list.Add(10f);
			list.Add(1f);
			data.argList = list;
			ArrayList returnList = LuaManager.Instance.Call("LuaCheckConditions", data);

			double damage = (double)(returnList[0]);
			double mydamage = (double)(returnList[1]);
		}
	}
}
