--直接Unityには登録しないスクリプト。いわゆる、ライブラリ化した奴

--SceneNameEnum = {
--}

-- クラス定義
SceneManager = {}

-- シングルトン用定義
local _instance = nil
function SceneManager.Instance() 
	if not _instance then
		_instance = SceneManager
		--setmetatable(_instance, { __index = SceneManager })
	end

	return _instance
end

-- メソッド定義
function SceneManager:Initialize() 
	self.CurrentScene = nil
	self.SceneCacheTable = {
		BootScene.new(),
		TitleScene.new(),
		--LoadingScene.new(),
		HomeScene.new(),
		CustomScene.new(),
		QuestScene.new(),
		OptionScene.new(),
		BattleScene.new(),
		GachaScene.new(),
		GachaEffectScene.new(),
		GachaResultScene.new(),
		CreditScene.new(),
	}

	LuaLoadPrefabAfter("common", "HeaderObject", "HeaderObject", "HeaderFooterCanvas")
	LuaLoadPrefabAfter("common", "FooterObject", "FooterObject", "HeaderFooterCanvas")
	LuaSetActive("HeaderObject", false)
	LuaSetActive("FooterObject", false)
end

-- シーンの切り替え
function SceneManager:ChangeScene(sceneNameEnum) 
	LuaUnityDebugLog("ChangeScene"..sceneNameEnum)
	CallbackManager.Instance():AddCallback("SceneManager_CallbackStartFade", {self, sceneNameEnum}, self.CallbackFadeIn)
	LuaPlayAnimator("FadeObject", "FadeIn", false, false, "LuaCallback", "SceneManager_CallbackStartFade")
end

-- フェード後コールバック
function SceneManager.CallbackFadeIn(argList, unityArg) 
	local self			= argList[1]
	local sceneNameEnum	= argList[2]
	
	LuaUnityDebugLog("CallbackFadeIn"..sceneNameEnum)
	
	if self.CurrentScene == nil then
	else
		self.CurrentScene:End()
	end
		
	local scene = self.SceneCacheTable[sceneNameEnum]
	self.CurrentScene = scene
	scene:Initialize()
	
	CallbackManager.Instance():AddCallback("SceneManager_AfterInitialize", {self, sceneNameEnum}, self.AfterInitialize)
	LuaPlayAnimator("FadeObject", "FadeOut", false, true, "LuaCallback", "SceneManager_AfterInitialize")
end

-- フェードあけた後の、初期化
function SceneManager.AfterInitialize(argList, unityArg) 
	local self			= argList[1]
	local sceneNameEnum	= argList[2]
	
	local scene = self.SceneCacheTable[sceneNameEnum]
	scene:AfterInitialize()
	LuaSetActive("FadeObject", false)
end

-- ボタンイベント検知
function SceneManager:OnClickButton(buttonName) 
	if buttonName == "HomeButton" then
		self:ChangeScene(SceneNameEnum.Home)
	elseif buttonName == "CustomButton" then
		self:ChangeScene(SceneNameEnum.Custom)
	elseif buttonName == "QuestButton" then
		self:ChangeScene(SceneNameEnum.Quest)
	elseif buttonName == "OptionButton" then
		self:ChangeScene(SceneNameEnum.Option)
	elseif buttonName == "HomeCharacter1" then
		-- ホームシーンで猫タッチしたら鳴かせる
		SoundManager.Instance():PlaySE("sound", SoundManager.Instance().SENameList.SelfHit)
	elseif buttonName == "HomeCharacter2" then
		-- ホームシーンで猫タッチしたら鳴かせる
		SoundManager.Instance():PlaySE("sound", SoundManager.Instance().SENameList.SelfHit)
	elseif buttonName == "HomeCharacter3" then
		-- ホームシーンで猫タッチしたら鳴かせる
		SoundManager.Instance():PlaySE("sound", SoundManager.Instance().SENameList.SelfHit)
	elseif buttonName == "HomeCharacter4" then
		-- ホームシーンで猫タッチしたら鳴かせる
		SoundManager.Instance():PlaySE("sound", SoundManager.Instance().SENameList.SelfHit)
	else
		SoundManager.Instance():PlaySE("sound", SoundManager.Instance().SENameList.ButtonePush)
		self.CurrentScene:OnClickButton(buttonName)
	end
end

-- トグルイベント検知
function SceneManager:OnToggleValueChange(hierarchyName, value) 
	SoundManager.Instance():PlaySE("sound", SoundManager.Instance().SENameList.ButtonePush)
	self.CurrentScene:OnToggleValueChange(hierarchyName, value)
end

-- スライダーイベント検知
function SceneManager:OnChangeSliderValue(sliderName, value) 
	self.CurrentScene:OnChangeSliderValue(sliderName, value)
end

-- サスペンド
function SceneManager:OnSuspend() 
	self.CurrentScene:OnSuspend()
end

-- レジューム
function SceneManager:OnResume() 
	self.CurrentScene:OnResume()
end

-- 更新
function SceneManager:Update(deltaTime) 
	self.CurrentScene:Update(deltaTime)
end

-- 画面タッチ処理
function SceneManager:OnMouseDown(touchx, touchy) 
	self.CurrentScene:OnMouseDown(touchx, touchy)
end

function SceneManager:OnMouseDrag(touchx, touchy) 
	self.CurrentScene:OnMouseDrag(touchx, touchy)
end

function SceneManager:OnMouseUp(touchx, touchy) 
	self.CurrentScene:OnMouseUp(touchx, touchy)
end
