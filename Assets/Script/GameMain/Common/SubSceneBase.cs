/*
 * SubSceneBase.cs
 */

using UnityEngine;
using System;
using System.Collections;
using System.Collections.Generic;

/// <summary>
/// サブシーンの基底クラス
/// </summary>
public class SubSceneBase : MonoBehaviour
{
	/// <summary>
	/// 初期化処理
	/// </summary>
	public virtual IEnumerator Initialize()
	{
		Debug.Log("SubSceneBase : Initialize");
		yield return null;
	}

	/// <summary>
	/// キャッシュ時と終了時共通の解放処理
	/// </summary>
	public virtual IEnumerator Release()
	{
		Debug.Log("SubSceneBase : Release");
		yield return null;
	}

	/// <summary>
	/// キャッシュ削除などでシーンを終わらせる場合の終了処理
	/// </summary>
	public virtual IEnumerator End()
	{
		Debug.Log("SubSceneBase : End");
		yield return null;
	}
}
