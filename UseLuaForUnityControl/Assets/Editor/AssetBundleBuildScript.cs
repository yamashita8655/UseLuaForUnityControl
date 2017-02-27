using UnityEngine;
using UnityEditor;
using System.Collections;
using System.Collections.Generic;

// 注意点として、一度ユーザーに配布したアセットバンドルの種類は、削除してはいけない
// 削除すると、バージョンファイルからも削除されてしまうので
// 古いAアセットを配布⇒A削除⇒新しいAアセットを配布とすると、
// ユーザーのバージョン情報が古い場合に、Aアセットが同じバージョンで別の物を見る可能性がある
// ⇒まぁ、ハッシュ値見ればいいんだけどさ…
public class AssetBundleBuildScript {
	class AssetBundleData {
		public string AssetBundleName = "";
		public string Version = "";
		public string Hash = "";
		public AssetBundleData(string assetBundleName, string version, string hash) {
			AssetBundleName = assetBundleName;
			Version = version;
			Hash = hash;
		}
	}

	[MenuItem ("Assets/Build AssetBundles Android")]
	static void BuildAllAssetBundlesAndroid ()
	{
		//BuildPipeline.BuildAssetBundles("Assets/AssetBundles/Android", BuildAssetBundleOptions.ChunkBasedCompression, BuildTarget.Android);
		BuildAssetBundle("Assets/AssetBundles/Android", "Android", BuildTarget.Android);
	}

	[MenuItem ("Assets/Build AssetBundles IOS")]
	static void BuildAllAssetBundlesIOS ()
	{
		//BuildPipeline.BuildAssetBundles("Assets/AssetBundles/IOS", BuildAssetBundleOptions.ChunkBasedCompression, BuildTarget.iOS);
		BuildAssetBundle("Assets/AssetBundles/IOS", "IOS", BuildTarget.iOS);
	}
	
	[MenuItem ("Assets/Build AssetBundles PC")]
	static void BuildAllAssetBundlesPC ()
	{
		//BuildPipeline.BuildAssetBundles("Assets/AssetBundles/PC", BuildAssetBundleOptions.ChunkBasedCompression, BuildTarget.StandaloneWindows64);
		BuildAssetBundle("Assets/AssetBundles/PC", "PC", BuildTarget.StandaloneWindows64);
	}
	
	static void BuildAssetBundle(string outputPath, string platform, BuildTarget target) {
		AssetBundleManifest manifest = BuildPipeline.BuildAssetBundles(outputPath, BuildAssetBundleOptions.ChunkBasedCompression, target);
		SortedDictionary<string, AssetBundleData> CreateAssetBundleDataSortedDict = new SortedDictionary<string, AssetBundleData>();

		string outputString = "";
		string[] assetBundles = manifest.GetAllAssetBundles();
		for (int i = 0; i < assetBundles.Length; i++) {
			string hash = manifest.GetAssetBundleHash(assetBundles[i]).ToString();
			string lineString = string.Format("{0},{1},{2}\n", assetBundles[i], "1", hash);
			outputString += lineString;
			AssetBundleData assetBundleData = new AssetBundleData(assetBundles[i], "0", hash);
			CreateAssetBundleDataSortedDict.Add(assetBundles[i], assetBundleData);
		}

		string serverVersionHashString = "";
		string stringForCreateHash = "";
		foreach (var data in CreateAssetBundleDataSortedDict) {
			stringForCreateHash += data.Value.Hash;
		}
		serverVersionHashString = CreateMD5Hash(stringForCreateHash);

		if (System.IO.File.Exists("C:/yamashita/github/UseLuaForUnityControl/UseLuaForUnityControl/Assets/AssetBundles/" + platform + "/version") == true) {
			System.IO.StreamReader sr = new System.IO.StreamReader(
				"C:/yamashita/github/UseLuaForUnityControl/UseLuaForUnityControl/Assets/AssetBundles/" + platform + "/version", 
				System.Text.Encoding.UTF8
			);
			string input = sr.ReadToEnd();
			sr.Close();
			
			string[] loadAssetBundleDataStringList = input.Split("\n" [0]);
			string output = "";
			SortedDictionary<string, AssetBundleData> LocalAssetBundleDataSortedDict = new SortedDictionary<string, AssetBundleData>();
			
			string localVersionNumber = "";
			for (int i = 0; i < loadAssetBundleDataStringList.Length; i++) {
				string[] lineString = loadAssetBundleDataStringList[i].Replace("\n", "").Split(","[0]);
				if (lineString.Length < 3) {
					continue;
				}
				
				string loadAssetBundleName = lineString[0];
				string loadVersion = lineString[1];
				string loadHash = lineString[2];
					
				if (loadAssetBundleName == "version") {
					localVersionNumber = loadVersion;
					continue;
				}

				AssetBundleData assetBundleData = new AssetBundleData(loadAssetBundleName, loadVersion, loadHash);
				LocalAssetBundleDataSortedDict.Add(loadAssetBundleName, assetBundleData);
			}

			string localVersionHashString = "";
			string hashStringForLocalVersion = "";
			foreach (var data in LocalAssetBundleDataSortedDict) {
				hashStringForLocalVersion += data.Value.Hash;
			}
			localVersionHashString = CreateMD5Hash(hashStringForLocalVersion);

			if (localVersionHashString == serverVersionHashString) {
				Debug.Log("差分が無いので、バージョンファイルは更新されません");
				return;
			}


			SortedDictionary<string, AssetBundleData> NewAssetBundleDataSortedDict = new SortedDictionary<string, AssetBundleData>();
			
			foreach (var serverData in CreateAssetBundleDataSortedDict) {
				bool isFind = false;
				foreach (var localData in LocalAssetBundleDataSortedDict) {
					if (serverData.Value.AssetBundleName == localData.Value.AssetBundleName) {
						if (serverData.Value.Hash != localData.Value.Hash) {
							serverData.Value.Version = (int.Parse(localData.Value.Version) + 1).ToString();
							NewAssetBundleDataSortedDict.Add(serverData.Value.AssetBundleName, serverData.Value);
							//output += string.Format ("{0},{1},{2}\n", serverData.Value.AssetBundleName, (int.Parse(localData.Value.Version) + 1).ToString(), serverData.Value.Hash);
							isFind = true;
							break;
						} else {
							NewAssetBundleDataSortedDict.Add(localData.Value.AssetBundleName, localData.Value);
							//output += string.Format ("{0},{1},{2}\n", localData.Value.AssetBundleName, localData.Value.Version, localData.Value.Hash);
							isFind = true;
							break;
						}
					}
				}
				
				if (isFind == false) {
					NewAssetBundleDataSortedDict.Add(serverData.Value.AssetBundleName, serverData.Value);
					//output += string.Format("{0},{1},{2}\n", serverData.Value.AssetBundleName, "0", serverData.Value.Hash);
				}
			}

			string newAssetBundleHashString = "";
			string stringForNewAssetBundleHash = "";
			foreach(var data in NewAssetBundleDataSortedDict) {
				stringForNewAssetBundleHash += data.Value.Hash;
				output += string.Format("{0},{1},{2}\n", data.Value.AssetBundleName, data.Value.Version, data.Value.Hash);
			}
			newAssetBundleHashString = CreateMD5Hash(stringForNewAssetBundleHash);
			output += string.Format("{0},{1},{2}\n", "version", (int.Parse(localVersionNumber)+1).ToString(), newAssetBundleHashString);
			
			System.IO.StreamWriter sw = new System.IO.StreamWriter(
				"C:/yamashita/github/UseLuaForUnityControl/UseLuaForUnityControl/Assets/AssetBundles/" + platform + "/version", 
				false, 
				System.Text.Encoding.UTF8
			);
			sw.Write(output);
			sw.Close();
		} else {
			Debug.Log("完全に新規作成です。意図していない場合は、諸々確認をしてください。");
			string lineString = string.Format("{0},{1},{2}\n", "version", "1", serverVersionHashString);
			outputString += lineString;
			System.IO.StreamWriter sw = new System.IO.StreamWriter(
				"C:/yamashita/github/UseLuaForUnityControl/UseLuaForUnityControl/Assets/AssetBundles/" + platform + "/version", 
				false, 
				System.Text.Encoding.UTF8
			);
			sw.Write(outputString);
			sw.Close();
		}

	}

	static string CreateMD5Hash(string baseString) {
		//MD5ハッシュ値を計算する文字列
		string s = baseString;
		//文字列をbyte型配列に変換する
		byte[] data = System.Text.Encoding.UTF8.GetBytes(s);
		
		//MD5CryptoServiceProviderオブジェクトを作成
		System.Security.Cryptography.MD5CryptoServiceProvider md5 = new System.Security.Cryptography.MD5CryptoServiceProvider();
		//または、次のようにもできる
		//System.Security.Cryptography.MD5 md5 =
		// System.Security.Cryptography.MD5.Create();
		
		//ハッシュ値を計算する
		byte[] bs = md5.ComputeHash(data);
		
		//リソースを解放する
		md5.Clear();
		
		//byte型配列を16進数の文字列に変換
		System.Text.StringBuilder result = new System.Text.StringBuilder();
		foreach (byte b in bs) {
			result.Append(b.ToString("x2"));
		}
		//ここの部分は次のようにもできる
		//string result = BitConverter.ToString(bs).ToLower().Replace("-","");
		
		return result.ToString();
	}

}
