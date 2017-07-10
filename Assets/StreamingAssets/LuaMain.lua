--Unity側から呼ばれ、Unity側の処理を呼び出す--Unity～というのは、Unity側から関数の登録がされていないと使えない（というか、処理がない）

ScreenWidth = ""
ScreenHeight = ""
LocalVersionString = ""
ServerVersionString = ""
StreamingDataPath = ""
PersistentDataPath = ""
CanvasFactor = 0.0
LoadAssetBundleStringList = {}
SaveAssetBundleStringList = {}

AfterSaveAssetBundleCallback = nil
AfterLoadAssetBundleCallback = nil

SaveAssetBundleCounter = 0
SaveScriptFileCounter = 0

-- TODO 実機確認するときは、HTTPの方にする事！
URL = "http://natural-nail-eye.sakura.ne.jp"
--URL = "file:///C:/yamashita/github/UseLuaForUnityControl/UseLuaForUnityControl/Assets/AssetBundles";

-- TODO ローカルのリソースを使って、ローカルのLuaスクリプトを使う時は、これをTrueにする事
IsUseLocalFile = true

Platform = ""

--StreamingAssets内にある、Lua用分割スクリプト。最終的には、ここはアセットバンドルから読み込むことになるはず
LuaFileList = {
	"DefineEnum.lua",
	"GachaItemConfig.lua",
	"GachaTable.lua",
	"GachaConfig.lua",
	"LuaUtility.lua",
	--"LuaUtility2.txt",
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
	"GachaScene.lua",
	"GachaEffectScene.lua",
	"GachaResultScene.lua",
	"SceneManager.lua",
	"DialogManager.lua",
	"SkillLevelUpDialog.lua",
	"ResultDialog.lua",
	"CharacterDetailDialog.lua",
	"GachaRollDialog.lua",
	"CharacterParameterUpDialog.lua",
	"GachaResultGetItemListDialog.lua",
	"MoveConfig.lua",
	"BaseMoveController.lua",
	"MoveControllerSinCurve.lua",
	"MoveControllerStraight.lua",
	"MoveControllerHoming.lua",
	"MoveControllerCircle.lua",
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
	"CharacterParameter.lua",
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
SaveLuaScriptIndex = 1
DoFileCount = 1

--
function LuaUnityLoadFileAsync(loadPath, savePath, callbackName)
	UnityLoadFileAsync(loadPath, savePath, callbackName)
end


--LuaのMain関数みたいな奴
--function LuaMain()
--	LuaLoadPrefabAfter("common", "FadeObject", "FadeObject", "SystemCanvas")
--	LuaSetActive("FadeObject", false)
--	LuaLoadPrefabAfter("Prefabs/System/DebugDisplayObject", "DebugDisplayObject", "SystemCanvas")
--	LuaFindObject("DebugDisplayText")
--	LuaPlayAnimator("FadeObject", "FadeIn", false, false, "InitLoadingScene", "")
--end
function LuaMain()
	-- 進行状況を確認する為のオブジェクトをFindしておく

--〇プログレスが必要な物
--・アセットバンドルダウンロード
--・LuaScriptセーブ
--・LuaScriptのDoFile

	LuaFindObject("InAppSlider")
	LuaFindObject("InAppText")
	LuaFindObject("InAppNowLoadText")
	LuaFindObject("InAppMaxLoadText")
	LuaFindObject("InAppRootObject")

	-- Unity側では、バージョンファイルの読み込みとLuaMainの読み込み自体（このファイルその物）の実行をしてくれているので
	-- 渡されたバージョン情報から、各種データの比較・更新を行う
	LuaUnityDebugLog(LocalVersionString)
	LuaUnityDebugLog(ServerVersionString)

	if IsUseLocalFile == true then
		DoFileLuaScriptFromLocal()
	else
		if LocalVersionString == "" then
			-- とりあえず、アセットバンドルを全部読み込んで、ファイル化しておく
			-- セーブの方は、ファイル化するついでに、マネージャにキャッシュもしてる
			SaveAssetBundleStringList = StringSplit(ServerVersionString, "\n")
			LuaUnityDebugLog(#SaveAssetBundleStringList)
			SaveAssetBundleCounter = 1
			LuaSetSliderValue("InAppSlider", SaveAssetBundleCounter)
			LuaSetMaxSliderValue("InAppSlider", #SaveAssetBundleStringList-2)-- LuaMainとVersionは読まないデータなので、その分差し引く
			LuaSetText("InAppNowLoadText", SaveAssetBundleCounter)
			LuaSetText("InAppMaxLoadText", #SaveAssetBundleStringList-2)

			AfterSaveAssetBundleCallback = SaveScriptFile
			SaveAssetBundle()
		else
			local serverStringList = StringSplit(ServerVersionString, "\n")
			local localStringList = StringSplit(LocalVersionString, "\n")

			local serverVersion = 0
			local localVersion = 0

			for i = 1, #serverStringList do
				local params = StringSplit(serverStringList[i], ",")
				if #params < 3 then
				else
					if (params[1] == "version") then
						serverVersion = params[2]
					end
				end
			end
			
			for i = 1, #localStringList do
				local params = StringSplit(localStringList[i], ",")
				if #params < 3 then
				else
					if (params[1] == "version") then
						localVersion = params[2]
					end
				end
			end

			-- バージョンチェック
			if serverVersion == localVersion then
				LoadAssetBundleStringList = localStringList
				AfterLoadAssetBundleCallback = DoFileLuaScript
				LoadAssetBundle()
			else
				local isUpdateLuaScript = false
				for i = 1, #serverStringList do
					local serverParams = StringSplit(serverStringList[i], ",")
					if #serverParams >= 3 then
						for j = 1, #localStringList do
							local localParams = StringSplit(localStringList[j], ",")
							if #localParams >= 3 then
								if serverParams[1] ~= "version" and serverParams[1] ~= "luamain" then
									if (serverParams[1] == localParams[1]) then
										if (serverParams[2] ~= localParams[2]) then
											-- バージョンが違うので、セーブリストにリスト追加
											table.insert(SaveAssetBundleStringList, serverStringList[i])
											if serverParams[1] == "luascript" then
												isUpdateLuaScript = true
											end
										else
											-- バージョンが同じなので、ロードリストにリスト追加
											table.insert(LoadAssetBundleStringList, serverStringList[i])
										end
									end
								end
							end
						end
					end
				end

				LuaUnityDebugLog("Save")
				for i = 1, #SaveAssetBundleStringList do
					LuaUnityDebugLog(SaveAssetBundleStringList[i])
				end
				LuaUnityDebugLog("Load")
				for i = 1, #LoadAssetBundleStringList do
					LuaUnityDebugLog(LoadAssetBundleStringList[i])
				end
			
				SaveAssetBundleCounter = 1
				LuaSetSliderValue("InAppSlider", SaveAssetBundleCounter)
				LuaSetMaxSliderValue("InAppSlider", #SaveAssetBundleStringList)-- こっちは、すでにLuaMainとVersionは除いてある
				LuaSetText("InAppNowLoadText", SaveAssetBundleCounter)
				LuaSetText("InAppMaxLoadText", #SaveAssetBundleStringList)
				
				AfterSaveAssetBundleCallback = LoadAssetBundle
				if isUpdateLuaScript == true then
					AfterLoadAssetBundleCallback = SaveScriptFile
				else
					AfterLoadAssetBundleCallback = DoFileLuaScript
				end
				
				SaveAssetBundle()
			end
		end
	end

end

function LoadAssetBundle()
	LuaUnityDebugLog("LoadAssetBundle")
	LuaSetText("InAppText", "ゲーム実行準備中")
	if #LoadAssetBundleStringList == 0 then
		-- LuaScriptはすでに存在しているので、DoFileを行う
		LuaUnityDebugLog("GO:DoFileLuaScript")
		--DoFileLuaScript()
		AfterLoadAssetBundleCallback()
	else
		LuaUnityDebugLog("a")
		local params = StringSplit(LoadAssetBundleStringList[1], ",")
		table.remove(LoadAssetBundleStringList, 1)

		LuaUnityDebugLog("b")
		if #params < 3 then
			-- 次へ
			LuaUnityDebugLog("c")
			LoadAssetBundle()
		else
			LuaUnityDebugLog("d")
			if (params[1] == "version") or (params[1] == "luamain") then
				-- 次へ
				LuaUnityDebugLog("e")
				LoadAssetBundle()
			else
				if Platform == "Editor" then
					LuaUnityDebugLog("f")
					LuaLoadAssetBundle("file:///"..PersistentDataPath.."/"..params[1], params[1], "LoadAssetBundleCallback", "")
				else
					LuaUnityDebugLog("g")
					LuaLoadAssetBundle("file:///"..PersistentDataPath.."/"..params[1], params[1], "LoadAssetBundleCallback", "")
				end
			end
		end
	end
end

function SaveAssetBundle()
	LuaSetText("InAppText", "ゲーム起動に必要なデータをダウンロード中")

	if #SaveAssetBundleStringList == 0 then
		-- スクリプトファイルの生成に移る
		LuaUnityDebugLog("CreateScriptFile")
		SaveLuaScriptCount = 1
		--SaveScriptFile()

		SaveScriptFileCounter = 1
		LuaSetSliderValue("InAppSlider", SaveScriptFileCounter)
		LuaSetMaxSliderValue("InAppSlider", #LuaFileList)-- LuaMainとVersionは読まないデータなので、その分差し引く
		LuaSetText("InAppNowLoadText", SaveScriptFileCounter)
		LuaSetText("InAppMaxLoadText", #LuaFileList)
		AfterSaveAssetBundleCallback()
	else
		local params = StringSplit(SaveAssetBundleStringList[1], ",")
		table.remove(SaveAssetBundleStringList, 1)

		if #params < 3 then
			-- 次へ
			SaveAssetBundle()
		else
			if (params[1] == "version") or (params[1] == "luamain") then
				-- 次へ
				SaveAssetBundle()
			else
				if Platform == "Editor" then
					LuaSaveAssetBundle(URL.."/Android/"..params[1], PersistentDataPath, params[1], "SaveAssetBundleCallback")
				else
					LuaSaveAssetBundle(URL.."/"..Platform.."/"..params[1], PersistentDataPath, params[1], "SaveAssetBundleCallback")
				end
			end
		end
	end
end

function SaveScriptFile()
	LuaSetText("InAppText", "データセーブ中")
	if SaveLuaScriptIndex > #LuaFileList then
		-- dofileに入る
		DoFileLuaScript()
	else
		-- luascriptの具現化
		local findPos = string.find(LuaFileList[SaveLuaScriptIndex], ".lua")
		local scriptName = string.sub(LuaFileList[SaveLuaScriptIndex], 0, findPos-1)
		LuaSaveScriptFile(PersistentDataPath, PersistentDataPath, "luascript", scriptName, scriptName..".lua", "SaveScriptFileCallback")
	end
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
function SetUnityGameData(screenWidth, screenHeight, canvasFactor, localVersionString, serverVersionString, streamingDataPath, persistentDataPath, platform)
	LuaUnityDebugLog(streamingDataPath)
	ScreenWidth = screenWidth
	ScreenHeight = screenHeight
	CanvasFactor = canvasFactor
	LocalVersionString = localVersionString
	ServerVersionString = serverVersionString
	StreamingDataPath = streamingDataPath 
	PersistentDataPath = persistentDataPath
	Platform = platform
	
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
	LuaSetText("InAppText", "ゲーム実行準備完了！")
	LuaLoadPrefabAfter("common", "FadeObject", "FadeObject", "SystemCanvas")
	LuaSetActive("FadeObject", false)
	--LuaLoadPrefabAfter("common", "DebugDisplayObject", "DebugDisplayObject", "SystemCanvas")
	--LuaFindObject("DebugDisplayText")
	LuaPlayAnimator("FadeObject", "FadeIn", false, false, "InitLoadingScene", "")

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

--ローカルのLuaScriptをDoFileする
function DoFileLuaScriptFromLocal()
	LuaSetText("InAppText", "ゲーム実行準備中")
	if DoFileCount <= #LuaFileList then
		local index = DoFileCount
		dofile(StreamingDataPath.."/"..LuaFileList[index])
		DoFileCount = DoFileCount + 1
		DoFileLuaScriptFromLocal()
	else
		InitGame()
	end
end

--doFileのみを行う処理
function DoFileLuaScript()
	LuaSetText("InAppText", "ゲーム実行準備中")
	if DoFileCount <= #LuaFileList then
		local index = DoFileCount
		dofile(PersistentDataPath.."/"..LuaFileList[index])
		DoFileCount = DoFileCount + 1
		DoFileLuaScript()
	else
		LuaUnitySaveVersionFile(PersistentDataPath, ServerVersionString, "SaveVersionFileCallback", "")
	end
end

function UpdateLoadingData()
	local barRate = LuaFileLoadedCount / #LuaFileList
	LuaSetScale("LoadingAllLoadingGaugeBar", barRate, 1.0, 1.0)
	--LuaSetScale("LoadingCurrentLoadingGaugeBar", 0.0, 1.0, 1.0)
	LuaSetText("LoadingLoadedValueText", LuaFileLoadedCount)
	LuaSetText("LoadingMaxValueText", #LuaFileList)
end

function LuaUnitySaveVersionFile(path, src, callbackName, callbackArg)
	UnitySaveVersionFile(path, src, callbackName, callbackArg)
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

--オブジェクト破棄
--引数：ヒエラルキに登録しているオブジェクト名を指定する
--結果：Unity側のヒエラルキオブジェクトディクショナリから削除する
function LuaDestroyObject(hierarchyName)
	UnityDestroyObject(hierarchyName)
end

--オブジェクト名リネーム
--引数：オブジェクトマネージャに登録していない、ヒエラルキ上に存在しているオブジェクト名と、変更後の名前
--結果：変更後のオブジェクトをオブジェクトマネージャに登録し、アクセスできるようjにする
function LuaRenameObject(hierarchyName, renameName)
	UnityRenameObject(hierarchyName, renameName)
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

--スライダー最大量設定
--引数：ヒエラルキに登録しているオブジェクト名と、量
function LuaSetMaxSliderValue(hierarchyName, value)
	UnitySetMaxSliderValue(hierarchyName, value)
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

function LuaLoadAssetBundle(persistentDataPath, assetBundleName, callbackName, callbackArg)
	UnityLoadAssetBundle(persistentDataPath, assetBundleName, callbackName, callbackArg)
end

function LuaSaveAssetBundle(loadPath, savePath, assetBundleName, callbackName)
	UnitySaveAssetBundle(loadPath, savePath, assetBundleName, callbackName)
end

function LuaSaveScriptFile(loadPath, savePath, assetBundleName, assetName, scriptName, callbackName)
	UnitySaveScriptFile(loadPath, savePath, assetBundleName, assetName, scriptName, callbackName)
end

--プレハブをロードするだけ
--function LuaLoadPrefabAfter(prefabPath, hierarchyName, parentHierarchyName)
function LuaLoadPrefabAfter(assetBundleName, prefabName, hierarchyName, parentHierarchyName)
	UnityLoadPrefabAfter(assetBundleName, prefabName, hierarchyName, parentHierarchyName)
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

--例外処理呼び出し
function LuaUnityCallExeptionCallback(errorString, errorNumber)
	UnityCallExeptionCallback(errorString, errorNumber)
end

--LuaMainの初期化が終わった事を通知する
function LuaUnityCallLuaMainEndCallback()
	UnityCallLuaMainEndCallback()
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

function OnMouseUpFromUnity(touchx, touchy)
	SceneManager.Instance():OnMouseUp(touchx, touchy)
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

function LoadAssetBundleCallback(arg, errorString)
	LuaUnityDebugLog(errorString)
	if errorString ~= nil and errorString ~= "" then
		LuaUnityCallExeptionCallback(errorString, 7)
	else
		LoadAssetBundle()
	end
end

function SaveAssetBundleCallback(errorString)
	LuaUnityDebugLog(errorString)
	if errorString ~= nil and errorString ~= "" then
		LuaUnityCallExeptionCallback(errorString, 3)
	else
		SaveAssetBundleCounter = SaveAssetBundleCounter + 1
		LuaSetSliderValue("InAppSlider", SaveAssetBundleCounter)
		LuaSetText("InAppNowLoadText", SaveAssetBundleCounter)
		SaveAssetBundle()
	end
end

function SaveScriptFileCallback(errorString)
	LuaUnityDebugLog(errorString)
	if errorString ~= nil and errorString ~= "" then
		LuaUnityCallExeptionCallback(errorString, 4)
	else
		SaveLuaScriptIndex = SaveLuaScriptIndex + 1
		LuaSetSliderValue("InAppSlider", SaveLuaScriptIndex)
		LuaSetText("InAppNowLoadText", SaveLuaScriptIndex)
		SaveScriptFile()
	end
end

function SaveVersionFileCallback(callbackArg, errorString)
	LuaUnityDebugLog(errorString)
	if errorString ~= nil and errorString ~= "" then
		LuaUnityCallExeptionCallback(errorString, 5)
	else
		LuaUnityCallLuaMainEndCallback()
		InitGame()
	end
end

-- 自作split関数
-- delimは一文字想定
function StringSplit(str, delim)
    -- Eliminate bad cases...
    if string.find(str, delim) == nil then
        return { str }
    end

    local result = {}
    local lastPos

	local count = 0

	while string.find(str, delim) ~= nil do
		local findPos = string.find(str, delim)
		local item = string.sub(str, 0, findPos-1)
		str = string.sub(str, findPos+1)
		table.insert(result, item)
	end
	table.insert(result, str)
    
	return result
end

