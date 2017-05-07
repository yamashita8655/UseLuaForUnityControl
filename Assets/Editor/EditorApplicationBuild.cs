using UnityEngine;
using UnityEditor;
using System.IO;
using System.Collections;
using System.Collections.Generic;

public class EditorApplicationBuild {

	// ビルド実行でAndroidのapkを作成する例
	[UnityEditor.MenuItem("Tools/Build Android")]
	public static void BuildAndroid() {
		EditorUserBuildSettings.SwitchActiveBuildTarget( BuildTarget.Android );
		List<string> allScene = new List<string>();
		foreach( EditorBuildSettingsScene scene in EditorBuildSettings.scenes ){
			if (scene.enabled) {
				allScene.Add (scene.path);
			}
		}
		PlayerSettings.bundleIdentifier = "com.mochimoffu.mofuneko";
		PlayerSettings.statusBarHidden = true;
		PlayerSettings.defaultInterfaceOrientation = UIOrientation.LandscapeLeft;
		PlayerSettings.use32BitDisplayBuffer = true;
		PlayerSettings.renderingPath = RenderingPath.Forward;

		BuildPipeline.BuildPlayer( 
			allScene.ToArray(),
			"Mofuneko.apk",
			BuildTarget.Android,
			BuildOptions.None
		);
	}
	
	[UnityEditor.MenuItem("Tools/Build Android Release")]
	public static void BuildAndroidRelease() {
		EditorUserBuildSettings.SwitchActiveBuildTarget( BuildTarget.Android );
		List<string> allScene = new List<string>();
		foreach( EditorBuildSettingsScene scene in EditorBuildSettings.scenes ){
			if (scene.enabled) {
				allScene.Add (scene.path);
			}
		}
		PlayerSettings.bundleIdentifier = "com.mochimoffu.mofuneko";
		PlayerSettings.statusBarHidden = true;
		PlayerSettings.defaultInterfaceOrientation = UIOrientation.LandscapeLeft;
		PlayerSettings.use32BitDisplayBuffer = true;
		PlayerSettings.renderingPath = RenderingPath.Forward;

		PlayerSettings.Android.keystorePass = "yaranaika-8655";
		PlayerSettings.Android.keyaliasName = "mofuneko";
		PlayerSettings.Android.keyaliasPass = "yaranaika-8655";

		BuildPipeline.BuildPlayer( 
			allScene.ToArray(),
			"Mofuneko.apk",
			BuildTarget.Android,
			BuildOptions.None
		);
	}
	
	[UnityEditor.MenuItem("Tools/Build IOS")]
	public static void BuildIOSRelease() {
		EditorUserBuildSettings.SwitchActiveBuildTarget(BuildTarget.iOS);
		List<string> allScene = new List<string>();
		foreach (EditorBuildSettingsScene scene in EditorBuildSettings.scenes) {
			if (scene.enabled) {
				allScene.Add (scene.path);
			}
		}

		BuildOptions opt = BuildOptions.SymlinkLibraries;

		//BUILD for Device
		PlayerSettings.iOS.sdkVersion = iOSSdkVersion.DeviceSDK;
		PlayerSettings.bundleIdentifier = "com.mochimoffu.mofuneko";
		PlayerSettings.statusBarHidden = true;
		string errorMsg_Device = BuildPipeline.BuildPlayer (
									allScene.ToArray(),
									"Mofuneko",
									BuildTarget.iOS,
									opt
								 );

		if (string.IsNullOrEmpty (errorMsg_Device)) {
		} else {
			// エラー処理
		}
	}
}
