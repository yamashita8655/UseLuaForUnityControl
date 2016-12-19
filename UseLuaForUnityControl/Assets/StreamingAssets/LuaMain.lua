--Unity側から呼ばれ、Unity側の処理を呼び出す--Unity～というのは、Unity側から関数の登録がされていないと使えない（というか、処理がない）

QuestCount = 5
ScreenWidth = ""
ScreenHeight = ""
StreamingDataPath = ""
PersistentDataPath = ""
CanvasFactor = 0.0

IsLoading = false

--StreamingAssets内にある、Lua用分割スクリプト。最終的には、ここはアセットバンドルから読み込むことになるはず
LuaFileList = {
	"LuaUtility.lua",
	"LuaUtility2.txt",
	"LuaUtilityClass.lua",
	"SceneBase.lua",
	"CallbackManager.lua",
	"TitleScene.lua",
	"HomeScene.lua",
	"CustomScene.lua",
	"QuestScene.lua",
	"OptionScene.lua",
	"BattleScene.lua",
	"SceneManager.lua",
	"MoveConfig.lua",
	"BaseMoveController.lua",
	"MoveControllerSinCurve.lua",
	"MoveControllerStraight.lua",
	"MoveControllerHoming.lua",
	"SpawnController.lua",
	"EnemyBase.lua",
	"EmitterConfig.lua",
	"EnemyConfig.lua",
	"BulletConfig.lua",
	"BulletEmitter.lua",
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
		index = LuaFileLoadedCount + 1
		loadPath = StreamingDataPath.."/"..LuaFileList[index]
		savePath = PersistentDataPath.."/"..LuaFileList[index]
		LuaUnityLoadFileAsync(loadPath, savePath, "LoadAllLuaScriptCallback")
	else
		InitGame()
	end
end

function InitGame()
	-- とりあえず、ゲーム開始時の初期設定をする
	GameManager.Instance():Initialize()
	GameManager.Instance():SetSelectPlayerCharacterData(PlayerCharacter001)

	CallbackManager.Instance():Initialize()

	SceneManager.Instance():Initialize()
	--SceneManager.Instance():ChangeScene(SceneNameEnum.Title)
	SceneManager.Instance():ChangeScene(SceneNameEnum.Custom)
end

--Luaの分割ファイル読み込み
function LoadAllLuaScriptCallback()
	index = LuaFileLoadedCount+1
	dofile(PersistentDataPath.."/"..LuaFileList[index])
	LuaFileLoadedCount = LuaFileLoadedCount + 1
	UpdateLoadingData()
	LoadAllLuaScript()
end

function UpdateLoadingData()
	barRate = LuaFileLoadedCount / #LuaFileList
	LuaSetScale("LoadingAllLoadingGaugeBar", barRate, 1.0, 1.0)
	--LuaSetScale("LoadingCurrentLoadingGaugeBar", 0.0, 1.0, 1.0)
	LuaSetText("LoadingLoadedValueText", LuaFileLoadedCount)
	LuaSetText("LoadingMaxValueText", #LuaFileList)
end

function LuaUnityDebugLog(log)
	UnityDebugLog(log)
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

--アニメーション再生
--引数：オブジェクト名、アニメーション名、アニメーションが終わった後のLua側のコールバック関数名
function LuaPlayAnimator(hierarchyName, animationName, isLoop, isAutoActiveFalse, callbackMethodName, callbackMethodArg)
	UnityPlayAnimator(hierarchyName, animationName, isLoop, isAutoActiveFalse, callbackMethodName, callbackMethodArg)
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

--プレハブのロード
function LuaLoadPrefab(prefabName)
	UnityLoadPrefab(prefabName)
end

--シーンの切り替え
function LuaLoadLevel(sceneName)
	UnityLoadLevel(sceneName)
end

--他のLuaの関数を呼び出す
function LuaCallLuaFunction(fileName, functionName)
	UnityCallLuaFunction(fileName, functionName)
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
	--if eventName == "TitleSceneGoHomeButton" then
	--	LuaPlayAnimator("FadeObject", "FadeIn", false, false, "TitleScene_ClickHome_Callback", "")
	--elseif eventName == "HomeButton" then
	--	LuaPlayAnimator("FadeObject", "FadeIn", false, false, "Footer_ClickHome_Callback", "")
	--elseif eventName == "CustomButton" then
	--	LuaPlayAnimator("FadeObject", "FadeIn", false, false, "Footer_ClickCustom_Callback", "")
	--elseif eventName == "QuestButton" then
	--	LuaPlayAnimator("FadeObject", "FadeIn", false, false, "Footer_ClickQuest_Callback", "")
	--elseif eventName == "OptionButton" then
	--	LuaPlayAnimator("FadeObject", "FadeIn", false, false, "Footer_ClickOption_Callback", "")
	--elseif eventName == "QuestSelectListNode1" then
	--	LuaPlayAnimator("FadeObject", "FadeIn", false, false, "QuestScene_ClickButton_Callback", "")
	--elseif eventName == "BattleOptionButton" then
	--	LuaPlayAnimator("FadeObject", "FadeIn", false, false, "BattleScene_ClickBackButton_Callback", "")
	--end
end

--タイトルシーン関数
--ホームへ行く
function TitleScene_ClickHome_Callback(arg)
	LuaPlayAnimator("LoadingTextObject", "Play", true, false, "", "")
	LuaChangeScene("Loading", "MainCanvas")
	LuaFindObject("LoadingAllLoadingGaugeBar")
	--LuaFindObject("LoadingCurrentLoadingGaugeBar")
	LuaFindObject("LoadingLoadedValueText")
	LuaFindObject("LoadingMaxValueText")

	UpdateLoadingData()
	LoadAllLuaScript()
	
	--LuaChangeScene("Home", "MainCanvas")
	--LuaSetActive("HeaderObject", true)
	--LuaSetActive("FooterObject", true)
	LuaPlayAnimator("FadeObject", "FadeOut", false, true, "", "")
end

--フッターボタン関数
function Footer_ClickHome_Callback(arg)
	LuaChangeScene("Home", "MainCanvas")
	LuaFindObject("HomeSceneTitleText")
	--LuaSetText("HomeSceneTitleText", "あいうえお")
	LuaSetText("HomeSceneTitleText", [[あいうえお]])


	LuaPlayAnimator("FadeObject", "FadeOut", false, true, "", "")
end
function Footer_ClickCustom_Callback(arg)
	LuaChangeScene("Custom", "MainCanvas")
	LuaFindObject("CustomPlayerSelectContent")
	LuaLoadPrefabAfter("Prefabs/CustomPlayerSelectListNode1", "CustomPlayerSelectListNode1", "CustomPlayerSelectContent")
	LuaLoadPrefabAfter("Prefabs/CustomPlayerSelectListNode2", "CustomPlayerSelectListNode2", "CustomPlayerSelectContent")
	LuaPlayAnimator("FadeObject", "FadeOut", false, true, "", "")
end
function Footer_ClickQuest_Callback(arg)
	LuaChangeScene("Quest", "MainCanvas")
	LuaFindObject("QuestScrollContent")
	for i = 1, QuestCount do
		LuaDestroyObject("QuestSelectListNode"..i, "QuestScrollContent")
	end

	for i = 1, QuestCount do
		LuaLoadPrefabAfter("Prefabs/QuestSelectListNode", "QuestSelectListNode"..i, "QuestScrollContent")
		LuaSetActive("QuestSelectListNode"..i, true)
	end
	LuaPlayAnimator("FadeObject", "FadeOut", false, true, "", "")
end
function Footer_ClickOption_Callback(arg)
	LuaChangeScene("Option", "MainCanvas")
	LuaPlayAnimator("FadeObject", "FadeOut", false, true, "", "")
end

flag = 0
--クエストシーン関数
function QuestScene_ClickButton_Callback(arg)
	LuaChangeScene("Battle", "MainCanvas")
	PlayerManager.Instance():Initialize()

	BulletManager.Instance():Initialize()
	EffectManager.Instance():Initialize()
	
	EnemyManager.Instance():Initialize()
	EnemyManager:CreateSpawnController(SpawnTable) 
	
	local posx = ScreenWidth/2
	local posy = ScreenHeight/2
	
	-- キャラ切り替えテスト
	selectCharacter = nil
	if flag == 0 then
		selectCharacter = GameManager.Instance():GetSelectPlayerCharacterData()
		flag = 1
	else
		selectCharacter = GameManager.Instance():GetSelectPlayerCharacterData()
	end

	PlayerManager.Instance():CreatePlayer(selectCharacter, posx, posy, 0)
	
	LuaSetActive("HeaderObject", false)
	LuaSetActive("FooterObject", false)
	LuaPlayAnimator("FadeObject", "FadeOut", false, true, "", "")
end

--バトルシーン関数
function BattleScene_ClickBackButton_Callback(arg)
	EnemyManager.Instance():Release()
	BulletManager.Instance():Release()
	PlayerManager.Instance():Release()
	LuaChangeScene("Home", "MainCanvas")
	LuaSetActive("HeaderObject", true)
	LuaSetActive("FooterObject", true)
	LuaFindObject("PlayerBulletRoot")
	LuaFindObject("EnemyObjectRoot")
	LuaPlayAnimator("FadeObject", "FadeOut", false, true, "", "")
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
end

function LuaCallback(callbackName) 
	CallbackManager.Instance():ExecuteCallback(callbackName)
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

