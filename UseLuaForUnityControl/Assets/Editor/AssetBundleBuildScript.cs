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
		Dictionary<string, AssetBundleData> CreateAssetBundleDataDict = new Dictionary<string, AssetBundleData>();

		string outputString = "";
		string[] assetBundles = manifest.GetAllAssetBundles();
		for (int i = 0; i < assetBundles.Length; i++) {
			string hash = manifest.GetAssetBundleHash(assetBundles[i]).ToString();
			string lineString = string.Format("{0},{1},{2}\n", assetBundles[i], "1", hash);
			outputString += lineString;
			AssetBundleData assetBundleData = new AssetBundleData(assetBundles[i], "0", hash);
			CreateAssetBundleDataDict.Add(assetBundles[i], assetBundleData);
		}
		
		if (System.IO.File.Exists("C:/yamashita/github/UseLuaForUnityControl/UseLuaForUnityControl/Assets/AssetBundles/" + platform + "/version") == true) {
			System.IO.StreamReader sr = new System.IO.StreamReader(
				"C:/yamashita/github/UseLuaForUnityControl/UseLuaForUnityControl/Assets/AssetBundles/" + platform + "/version", 
				System.Text.Encoding.UTF8
			);
			string input = sr.ReadToEnd();
			sr.Close();
			
			string[] loadAssetBundleDataStringList = input.Split("\n" [0]);
			string output = "";
			foreach (var data in CreateAssetBundleDataDict) {
				bool isFind = false;
				for (int i = 0; i < loadAssetBundleDataStringList.Length; i++) {
					string[] lineString = loadAssetBundleDataStringList[i].Replace("\n", "").Split(","[0]);
					if (lineString.Length < 3) {
						continue;
					}
					
					string loadAssetBundleName = lineString[0];
					string loadVersion = lineString[1];
					string loadHash = lineString[2];

					if (data.Value.AssetBundleName == loadAssetBundleName) {
						if (data.Value.Hash != loadHash) {
							output += string.Format ("{0},{1},{2}\n", data.Value.AssetBundleName, (int.Parse (loadVersion) + 1).ToString (), data.Value.Hash);
							isFind = true;
							break;
						} else {
							output += string.Format ("{0},{1},{2}\n", loadAssetBundleName, loadVersion, loadHash);
							isFind = true;
							break;
						}
					}
				}
				
				if (isFind == false) {
					output += string.Format("{0},{1},{2}\n", data.Value.AssetBundleName, "0", data.Value.Hash);
				}
			}
			
			System.IO.StreamWriter sw = new System.IO.StreamWriter(
				"C:/yamashita/github/UseLuaForUnityControl/UseLuaForUnityControl/Assets/AssetBundles/" + platform + "/version", 
				false, 
				System.Text.Encoding.UTF8
			);
			sw.Write(output);
			sw.Close();
		} else {
			System.IO.StreamWriter sw = new System.IO.StreamWriter(
				"C:/yamashita/github/UseLuaForUnityControl/UseLuaForUnityControl/Assets/AssetBundles/" + platform + "/version", 
				false, 
				System.Text.Encoding.UTF8
			);
			sw.Write(outputString);
			sw.Close();
		}

	}
}
