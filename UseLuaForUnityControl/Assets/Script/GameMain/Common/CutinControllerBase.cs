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
public class CutinControllerBase : MonoBehaviour
{
	#region PrivateMember
	bool		IsStop = true;
	Action		EndCallback = null;
	int			PrevStateHash = 0;

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
		BaseAnimation.SetTrigger(stateName);
		EndCallback = callback;
		IsStop = false;
		Resume();
	}

	public void Update()
	{
		AnimatorStateInfo animatorStateInfo = BaseAnimation.GetCurrentAnimatorStateInfo( 0 );
		if (IsStop == true) {
		} else {
			if (PrevStateHash != animatorStateInfo.shortNameHash) {
				if ( animatorStateInfo.IsName("Stop") )
				{
					EffectRootObject.SetActive(false);
					IsStop = true;
					if (EndCallback != null) {
						EndCallback();
					}
				}
			}
		}

		PrevStateHash =	animatorStateInfo.shortNameHash;
	}

	public void Pause() {
		BaseAnimation.speed = 0f;
	}

	public void Resume() {
		BaseAnimation.speed = 1f;
	}


	#endregion
}
