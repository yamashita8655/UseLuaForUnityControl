using UnityEngine;
using UnityEngine.UI;
using System.Collections;
using System;
using LuaDLLTest;
using System.Runtime.InteropServices;
using System.Collections.Generic;
using System.IO;

public class RijindaelManager : SingletonMonoBehaviour<RijindaelManager> {

	private readonly string GeneratePassward = "yaranaika";

	public void Init()
	{
	}
	
	/// <summary>
	/// パスワードから共有キーと初期化ベクタを生成する
	/// </summary>
	/// <param name="password">基になるパスワード</param>
	/// <param name="keySize">共有キーのサイズ（ビット）</param>
	/// <param name="key">作成された共有キー</param>
	/// <param name="blockSize">初期化ベクタのサイズ（ビット）</param>
	/// <param name="iv">作成された初期化ベクタ</param>
	private void GenerateKeyFromPassword(string password, int keySize, out byte[] key, int blockSize, out byte[] iv) {
	    //パスワードから共有キーと初期化ベクタを作成する
	    //saltを決める
		// saltは必ず8バイト以上らしい
	    byte[] salt = System.Text.Encoding.UTF8.GetBytes("abcdefghijklmnopqrstuvwxyabcdefghijklmnopqrstuvwxyabcdefghijklmn");
	    //Rfc2898DeriveBytesオブジェクトを作成する
	    System.Security.Cryptography.Rfc2898DeriveBytes deriveBytes =
	        new System.Security.Cryptography.Rfc2898DeriveBytes(password, salt);
	    //.NET Framework 1.1以下の時は、PasswordDeriveBytesを使用する
	    //System.Security.Cryptography.PasswordDeriveBytes deriveBytes =
	    //    new System.Security.Cryptography.PasswordDeriveBytes(password, salt);
	    //反復処理回数を指定する デフォルトで1000回
	    deriveBytes.IterationCount = 1000;
	
	    //共有キーと初期化ベクタを生成する
	    key = deriveBytes.GetBytes(keySize / 8);
	    iv = deriveBytes.GetBytes(blockSize / 8);
	}

	// 暗号化された文字列を返す
	public string CreateEncryptorString(string baseString) {
		string output = "";
		
		System.Security.Cryptography.RijndaelManaged rijndael = new System.Security.Cryptography.RijndaelManaged ();
		
		byte[] key;
		byte[] iv;

		GenerateKeyFromPassword(
			GeneratePassward, // password
			rijndael.KeySize, 
			out key, 
			rijndael.BlockSize, 
			out iv
		);
		
		rijndael.Key = key;
	    rijndael.IV = iv;
	    
		//文字列をバイト型配列に変換する
	    byte[] strBytes = System.Text.Encoding.UTF8.GetBytes(baseString);
	    
		//対称暗号化オブジェクトの作成
	    System.Security.Cryptography.ICryptoTransform encryptor = rijndael.CreateEncryptor();
		
		//バイト型配列を暗号化する
	    byte[] encBytes = encryptor.TransformFinalBlock(strBytes, 0, strBytes.Length);
		
		//閉じる
	    encryptor.Dispose();
	    
		//バイト型配列を文字列に変換して返す
	    output = System.Convert.ToBase64String(encBytes);

		return output;
	}
	
	// 復号化された文字列を返す
	public string CreateDecryptorString(string baseString) {
		string output = "";
		
		System.Security.Cryptography.RijndaelManaged rijndael = new System.Security.Cryptography.RijndaelManaged ();
    	
		//パスワードから共有キーと初期化ベクタを作成
    	byte[] key;
    	byte[] iv;
    	GenerateKeyFromPassword(
    	    GeneratePassward,//password
			rijndael.KeySize, 
			out key, 
			rijndael.BlockSize, 
			out iv
		);
    	
		rijndael.Key = key;
    	rijndael.IV = iv;

    	//文字列をバイト型配列に戻す
		byte[] strBytes = System.Convert.FromBase64String(baseString);

    	//対称暗号化オブジェクトの作成
    	System.Security.Cryptography.ICryptoTransform decryptor = rijndael.CreateDecryptor();
    	
		//バイト型配列を復号化する
    	//復号化に失敗すると例外CryptographicExceptionが発生
    	byte[] decBytes = decryptor.TransformFinalBlock(strBytes, 0, strBytes.Length);
    	
		//閉じる
    	decryptor.Dispose();

    	//バイト型配列を文字列に戻して返す
    	output = System.Text.Encoding.UTF8.GetString(decBytes);

		return output;
	}

}

