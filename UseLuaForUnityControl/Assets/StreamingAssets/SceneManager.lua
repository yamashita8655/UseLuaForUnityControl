--直接Unityには登録しないスクリプト。いわゆる、ライブラリ化した奴

SceneNameEnum = {
	Title   = 1,
	--Loading = 2,
	Home    = 2,
	Custom  = 3,
	Quest   = 4,
	Option  = 5,
	Battle  = 6,
}

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
		TitleScene.new(),
		--LoadingScene.new(),
		HomeScene.new(),
		CustomScene.new(),
		QuestScene.new(),
		OptionScene.new(),
		BattleScene.new(),
	}

	LuaLoadPrefabAfter("Prefabs/HeaderObject", "HeaderObject", "HeaderFooterCanvas")
	LuaLoadPrefabAfter("Prefabs/FooterObject", "FooterObject", "HeaderFooterCanvas")
	LuaSetActive("HeaderObject", false)
	LuaSetActive("FooterObject", false)
end

-- シーンの切り替え
function SceneManager:ChangeScene(sceneNameEnum) 
	CallbackManager.Instance():AddCallback("SceneManager_CallbackStartFade", {self, sceneNameEnum}, self.CallbackFadeIn)
	LuaPlayAnimator("FadeObject", "FadeIn", false, false, "LuaCallback", "SceneManager_CallbackStartFade")
end

-- フェード後コールバック
function SceneManager.CallbackFadeIn(argList, unityArg) 
	self			= argList[1]
	sceneNameEnum	= argList[2]
	
	if self.CurrentScene == nil then
	else
		self.CurrentScene:End()
	end
		
	scene = self.SceneCacheTable[sceneNameEnum]
	scene:Initialize()
	self.CurrentScene = scene
	LuaPlayAnimator("FadeObject", "FadeOut", false, true, "", "")
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
	else
		self.CurrentScene:OnClickButton(buttonName)
	end
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
