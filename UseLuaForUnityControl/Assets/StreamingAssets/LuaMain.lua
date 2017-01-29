--Unity側から呼ばれ、Unity側の処理を呼び出す--Unity～というのは、Unity側から関数の登録がされていないと使えない（というか、処理がない）

ScreenWidth = ""
ScreenHeight = ""
StreamingDataPath = ""
PersistentDataPath = ""
CanvasFactor = 0.0

--StreamingAssets内にある、Lua用分割スクリプト。最終的には、ここはアセットバンドルから読み込むことになるはず
LuaFileList = {
	"LuaUtility.lua",
	"LuaUtility2.txt",
	"LuaUtilityClass.lua",
	"SceneBase.lua",
	"CallbackManager.lua",
	"TimerCallbackManager.lua",
	"AreaCellManager.lua",
	"BootScene.lua",
	"TitleScene.lua",
	"HomeScene.lua",
	"CustomScene.lua",
	"QuestScene.lua",
	"OptionScene.lua",
	"BattleScene.lua",
	"SceneManager.lua",
	"DialogManager.lua",
	"SkillLevelUpDialog.lua",
	"MoveConfig.lua",
	"BaseMoveController.lua",
	"MoveControllerSinCurve.lua",
	"MoveControllerStraight.lua",
	"MoveControllerHoming.lua",
	"SpawnController.lua",
	"EnemyBase.lua",
	"EmitterConfig.lua",
	"BulletConfig.lua",
	"EnemyConfig.lua",
	"BulletEmitter.lua",
	"SkillConfig.lua",
	"BulletManager.lua",
	"EnemyManager.lua",
	"EffectManager.lua",
	"ObjectBase.lua",
	"BulletBase.lua",
	"NormalBullet.lua",
	"HomingBullet.lua",
	"CharacterBase.lua",
	"NormalEnemyCharacter.lua",
	"EnemyShooter.lua",
	"SinCurveEnemy.lua",
	"PlayerCharacter.lua",
	"PlayerManager.lua",
	"PlayerCharacterConfig.lua",
	"GameManager.lua",
	"EnemySpawnData.lua",
	"EnemySpawnTable.lua",
	"QuestDataConfig.lua",
	"FileIOManager.lua",
}
LuaFileLoadedCount = 0

--
function LuaUnityLoadFileAsync(loadPath, savePath, callbackName)
	UnityLoadFileAsync(loadPath, savePath, callbackName)
end

----LuaのMain関数みたいな奴
--function LuaMain()
--	LuaChangeScene("Title", "MainCanvas")
--	LuaLoadPrefabAfter("Prefabs/System/FadeObject", "", "SystemCanvas")
--	LuaLoadPrefabAfter("Prefabs/System/LoadingTextObject", "", "SystemCanvas")
--	LuaLoadPrefabAfter("Prefabs/HeaderObject", "", "HeaderFooterCanvas")
--	LuaLoadPrefabAfter("Prefabs/FooterObject", "", "HeaderFooterCanvas")
--	LuaSetActive("FadeObject", false)
--	LuaSetActive("HeaderObject", false)
--	LuaSetActive("FooterObject", false)
--	LuaSetActive("LoadingTextObject", false)
--	LuaLoadPrefabAfter("Prefabs/System/DebugDisplayObject", "", "SystemCanvas")
--	LuaFindObject("DebugDisplayText")
--end

--LuaのMain関数みたいな奴
function LuaMain()
	LuaLoadPrefabAfter("Prefabs/System/FadeObject", "FadeObject", "SystemCanvas")
	LuaSetActive("FadeObject", false)
	LuaLoadPrefabAfter("Prefabs/System/DebugDisplayObject", "DebugDisplayObject", "SystemCanvas")
	LuaFindObject("DebugDisplayText")
	LuaPlayAnimator("FadeObject", "FadeIn", false, false, "InitLoadingScene", "")
end

function InitLoadingScene()
	LuaChangeScene("Loading", "MainCanvas")
	UpdateLoadingData()
	LuaPlayAnimator("FadeObject", "FadeOut", false, false, "StartLoadLuaScript", "")
end

function StartLoadLuaScript()
	LoadAllLuaScript()
end

--ゲームの情報
function SetUnityGameData(screenWidth, screenHeight, canvasFactor, streamingDataPath, persistentDataPath)
	ScreenWidth = screenWidth
	ScreenHeight = screenHeight
	CanvasFactor = canvasFactor
	StreamingDataPath = streamingDataPath 
	PersistentDataPath = persistentDataPath
	
end

--Luaの分割ファイル読み込み
function LoadAllLuaScript()
	local fileCount = #LuaFileList
	if LuaFileLoadedCount < fileCount then
		local index = LuaFileLoadedCount + 1
		local loadPath = StreamingDataPath.."/"..LuaFileList[index]
		local savePath = PersistentDataPath.."/"..LuaFileList[index]
		LuaUnityLoadFileAsync(loadPath, savePath, "LoadAllLuaScriptCallback")
	else
		InitGame()
	end
end

function InitGame()
	-- とりあえず、ゲーム開始時の初期設定をする
	UtilityFunction.Instance():Initialize()
	GameManager.Instance():Initialize()
	CallbackManager.Instance():Initialize()
	TimerCallbackManager.Instance():Initialize()
	FileIOManager.Instance():Initialize()
	SceneManager.Instance():Initialize()
	DialogManager.Instance():Initialize()
	
	--FileIOManager.Instance():DebugDeleteSaveFile()
	--FileIOManager.Instance():Save()
	SceneManager.Instance():ChangeScene(SceneNameEnum.Boot)
	
	--customSelectIndex = SaveObject.CustomScene_SelectIndex
	--GameManager.Instance():SetSelectPlayerCharacterData(PlayerCharacterConfig[customSelectIndex])
	----SceneManager.Instance():ChangeScene(SceneNameEnum.Title)
	--SceneManager.Instance():ChangeScene(SceneNameEnum.Quest)
end

--Luaの分割ファイル読み込み
function LoadAllLuaScriptCallback()
	local index = LuaFileLoadedCount+1
	dofile(PersistentDataPath.."/"..LuaFileList[index])
	LuaFileLoadedCount = LuaFileLoadedCount + 1
	UpdateLoadingData()
	LoadAllLuaScript()
end

function UpdateLoadingData()
	local barRate = LuaFileLoadedCount / #LuaFileList
	LuaSetScale("LoadingAllLoadingGaugeBar", barRate, 1.0, 1.0)
	--LuaSetScale("LoadingCurrentLoadingGaugeBar", 0.0, 1.0, 1.0)
	LuaSetText("LoadingLoadedValueText", LuaFileLoadedCount)
	LuaSetText("LoadingMaxValueText", #LuaFileList)
end

function LuaUnityLoadSaveFile(path, oneTimeFileName, callbackName, callbackArg)
	UnityLoadSaveFile(path, oneTimeFileName, callbackName, callbackArg)
end

function LuaUnityDeleteFile(path, callbackName, callbackArg)
	UnityDeleteFile(path, callbackName, callbackArg)
end

function LuaUnityDebugLog(log)
	UnityDebugLog(log)
end

function LuaUnitySaveFile(fileName, saveString, callbackName, callbackTag)
	UnitySaveFile(fileName, saveString, callbackName, callbackTag)
end

function LuaUnityLoadFile(fileName, saveString, callbackName, callbackTag)
	UnitySaveFile(fileName, saveString, callbackName, callbackTag)
end

--オブジェクト破棄
--引数：ヒエラルキに登録しているオブジェクト名を指定する
--結果：Unity側のヒエラルキオブジェクトディクショナリから削除する
function LuaDestroyObject(hierarchyName)
	UnityDestroyObject(hierarchyName)
end

--オブジェクト検索
--引数：ヒエラルキに登録しているオブジェクト名を指定する
--結果：Unity側のヒエラルキオブジェクトディクショナリに登録されて、アクセス可能になる
function LuaFindObject(hierarchyName)
	UnityFindObject(hierarchyName)
end

--テキスト設定
--引数：ヒエラルキに登録しているオブジェクト名と、設定する文字列
function LuaSetText(hierarchyName, text)
	UnitySetText(hierarchyName, text)
end

--スライダー量設定
--引数：ヒエラルキに登録しているオブジェクト名と、量
function LuaSetSliderValue(hierarchyName, value)
	UnitySetSliderValue(hierarchyName, value)
end

--アニメーション再生
--引数：オブジェクト名、アニメーション名、アニメーションが終わった後のLua側のコールバック関数名
function LuaPlayAnimator(hierarchyName, animationName, isLoop, isAutoActiveFalse, callbackMethodName, callbackMethodArg)
	UnityPlayAnimator(hierarchyName, animationName, isLoop, isAutoActiveFalse, callbackMethodName, callbackMethodArg)
end

--アニメーション一時停止
--引数：オブジェクト名
function LuaPauseAnimator(hierarchyName)
	UnityPauseAnimator(hierarchyName)
end

--アニメーション一時停止の解除
--引数：オブジェクト名
function LuaResumeAnimator(hierarchyName)
	UnityResumeAnimator(hierarchyName)
end

--シーンオブジェクトの切り替え
--引数：シーン名、SetParentしたい親のオブジェクト名
function LuaChangeScene(sceneName, parentHierarchyName)
	UnityChangeScene(sceneName, parentHierarchyName)
end

--座標の設定
--引数：hierarchy名と、x,y,zの座標
function LuaSetPosition(hierarchyName, x, y, z)
	UnitySetPosition(hierarchyName, x, y, z)
end

--ローテーションの設定
--引数：hierarchy名と、x,y,zの回転角度(degree)
function LuaSetRotate(hierarchyName, x, y, z)
	UnitySetRotate(hierarchyName, x, y, z)
end

--スケールの設定
--引数：hierarchy名と、x,y,zの拡大率
function LuaSetScale(hierarchyName, x, y, z)
	UnitySetScale(hierarchyName, x, y, z)
end

--アクティブの切り替え
--引数：
function LuaSetActive(hierarchyName, active)
	UnitySetActive(hierarchyName, active)
end

--プレハブをロードするだけ
function LuaLoadPrefabAfter(prefabPath, hierarchyName, parentHierarchyName)
	UnityLoadPrefabAfter(prefabPath, hierarchyName, parentHierarchyName)
end

--親の設定
function LuaSetParent(hierarchyName, parentHierarchyName)
	UnitySetParent(hierarchyName, parentHierarchyName)
end

--ボタンのインタラクティブ設定
function LuaSetButtonInteractable(hierarchyName, interactable)
	UnitySetButtonInteractable(hierarchyName, interactable)
end

--プレハブのロード
function LuaLoadPrefab(prefabName)
	UnityLoadPrefab(prefabName)
end

--シーンの切り替え
function LuaLoadLevel(sceneName)
	UnityLoadLevel(sceneName)
end

--基本Lua関数を使えるようにする
function LuaBindCommonFunction(fileName)
	UnityBindCommonFunction(fileName)
end

--Luaファイルを読み込んで、アクセスできる状態にする
function LoadLuaFile(filename)
	UnityLoadLuaFile(filename)
end

--Unity側から呼び出される。Event系の関数
function EventClickButtonFromUnity(buttonName)
	SceneManager.Instance():OnClickButton(buttonName) 
	DialogManager.Instance():OnClickButton(buttonName) 
end

function EventSliderFromUnity(sliderName, value)
	SceneManager.Instance():OnChangeSliderValue(sliderName, value) 
end

function OnMouseDownFromUnity(touchx, touchy)
	SceneManager.Instance():OnMouseDown(touchx, touchy)
end

function OnMouseDragFromUnity(touchx, touchy)
	SceneManager.Instance():OnMouseDrag(touchx, touchy)
end

--Unity側から呼ばれる、更新関数
function UpdateFromUnity(deltaTime)
	-- 線形補間で計算はしないので、実際に経過しているフレーム自体を固定にして、処理落ち対策とする
	SceneManager.Instance():Update(GameManager:GetBattleDeltaTime())
	TimerCallbackManager.Instance():Update(GameManager:GetBattleDeltaTime())
end

function LuaCallback(callbackName, unityArg) 
	CallbackManager.Instance():ExecuteCallback(callbackName, unityArg)
end

--ホームシーン関数

----コルーチンテスト
--function CallCoroutine()
--	local coro = coroutine.create(LuaMainLoop)
--	coroutine.resume(coro)-- これで、初めて一回実行される
--	coroutine.resume(coro)-- 以降、yieldで止めていた所から再開される
--end
--
--function LuaMainLoop()
--	counter = 0
--	while true do
--		LuaUnityDebugLog(counter)
--		counter = counter + 1
--		coroutine.yield(0)
--	end
--end

