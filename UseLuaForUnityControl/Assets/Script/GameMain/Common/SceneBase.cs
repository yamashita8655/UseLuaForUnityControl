/*
 * シーンファイルの基底クラス
 */

using UnityEngine;
using UnityEngine.UI;
using System;
using System.Collections;
using System.Collections.Generic;

/// <summary>
/// シーンファイルの基底クラス
/// これは、LoadLevelで切り替えるレベルのまとまり
/// </summary>
public class SceneBase : MonoBehaviour
{
	/// <summary>
	/// 初期化処理
	/// </summary>
	public virtual IEnumerator Initialize()
	{
		Debug.Log("SceneBase : Initialize");
		yield return null;
	}

	/// <summary>
	/// キャッシュ時と終了時共通の解放処理
	/// </summary>
	public virtual IEnumerator Release()
	{
		Debug.Log("SceneBase : Release");
		yield return null;
	}

	/// <summary>
	/// キャッシュ削除などでシーンを終わらせる場合の終了処理
	/// </summary>
	public virtual IEnumerator End()
	{
		Debug.Log("SceneBase : End");
		yield return null;
	}
}
