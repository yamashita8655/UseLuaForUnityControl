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
		//PlayerSettings.bundleIdentifier = "com.yourcompany.newgame";
		//PlayerSettings.statusBarHidden = true;
		BuildPipeline.BuildPlayer( 
			allScene.ToArray(),
			"Mofuneko.apk",
			BuildTarget.Android,
			BuildOptions.None
		);
	}
}
