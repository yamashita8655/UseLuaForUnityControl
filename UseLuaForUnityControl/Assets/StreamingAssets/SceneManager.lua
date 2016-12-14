--直接Unityには登録しないスクリプト。いわゆる、ライブラリ化した奴

SceneNameEnum = {
	Title   = 1,
	Loading = 2,
	Home    = 3,
	Custom  = 4,
	Quest   = 5,
	Option  = 6,
	Battle  = 7,
}

-- クラス定義
SceneManager = {}

-- シングルトン用定義
local _instance = nil
function SceneManager.Instance() 
	if not _instance then
		_instance = SceneManager
		_instance:Initialize()
		--setmetatable(_instance, { __index = SceneManager })
	end

	return _instance
end

-- メソッド定義
function SceneManager:Initialize() 
	CurrentScene = nil
	SceneCacheTable = {
		TitleScene.new(),
		LoadingScene.new(),
		HomeScene.new(),
		CustomScene.new(),
		QuestScene.new(),
		OptionScene.new(),
		BattleScene.new(),
	}
end

-- シーンの切り替え
function SceneManager:ChangeScene(sceneNameEnum) 
	if CurrentScene == nil then
	else
		CurrentScene:End()
	end
		
	scene = SceneCacheTable[sceneNameEnum]
	scene:Initialize()
	CurrentScene = scene
end

