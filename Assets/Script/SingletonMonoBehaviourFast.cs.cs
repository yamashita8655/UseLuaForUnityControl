using UnityEngine;
using System;
using System.Collections;

public class SingletonMonoBehaviour<T> : MonoBehaviour where T : MonoBehaviour
{
	private static T instance;
	public static T Instance {
		get {
			if (instance == null) {
				instance = (T)FindObjectOfType (typeof(T));

				if (instance == null) {
					var obj = new GameObject(typeof(T).ToString());
					instance = obj.AddComponent<T>();
				}
			}
			return instance;
		}
	}

	protected void Awake()
	{
		CheckInstance();
	}

	protected bool CheckInstance()
	{
		if( this == Instance){ return true;}
		Destroy(this);
		return false;
	}
}