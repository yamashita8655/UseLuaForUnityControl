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

		PlayerSettings.Android.keystorePass = "user.keystore";
		PlayerSettings.Android.keyaliasName = "mochimoffu";
		PlayerSettings.Android.keyaliasPass = "yaranaika-8655";

		BuildPipeline.BuildPlayer( 
			allScene.ToArray(),
			"Mofuneko.apk",
			BuildTarget.Android,
			BuildOptions.None
		);
	}
}
