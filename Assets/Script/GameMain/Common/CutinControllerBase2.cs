/*
 * @file CutinManager.cs
 * カットインマネージャ
 * @author 名前
 */

using UnityEngine;
using UnityEngine.UI;
using UnityEngine.SceneManagement;
using System;
using System.Collections;
using System.Collections.Generic;

	/// <summary>
	/// シーンの管理を行う
	/// </summary>
public class CutinControllerBase2 : MonoBehaviour
{
	#region PrivateMember
	Action		EndCallback = null;
	int			PrevStateHash = 0;
	bool 		IsAutoActiveFalse = false;

	[SerializeField]	public	GameObject	EffectRootObject;
	[SerializeField]	public	Animator	BaseAnimation;

	#endregion

	#region PublicMethod
	// ＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝

	/// <summary>
	/// データ読み込む
	/// </summary>
	public void Initialize(Transform parent)
	{
		EffectRootObject.transform.SetParent(parent.transform);
		EffectRootObject.transform.localPosition = Vector3.zero;
		EffectRootObject.transform.localScale = Vector3.one;
		EffectRootObject.SetActive(false);
	}

	/// <summary>
	/// データ読み込む
	/// </summary>
	public void Play(string stateName, Action callback)
	{
		EffectRootObject.SetActive(true);
//		BaseAnimation.Play(stateName);
//		BaseAnimation.ResetTrigger(stateName);
		EndCallback = callback;
		BaseAnimation.Play(stateName);
		PrevStateHash = Animator.StringToHash("Stop");
	}

	public void Update()
	{
	}
	
	public void CallEndCallbackFromAnimation()
	{
		if (EndCallback != null) {
			EndCallback();
		}
	}

	public void Pause() {
		BaseAnimation.speed = 0f;
	}

	public void Resume() {
		BaseAnimation.speed = 1f;
	}


	#endregion
}
