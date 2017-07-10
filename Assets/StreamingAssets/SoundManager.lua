--直接Unityには登録しないスクリプト。いわゆる、ライブラリ化した奴

--SceneNameEnum = {
--}

-- クラス定義
SoundManager = {}

-- シングルトン用定義
local _instance = nil
function SoundManager.Instance() 
	if not _instance then
		_instance = SoundManager
		--setmetatable(_instance, { __index = SoundManager })
	end

	return _instance
end

-- メソッド定義
function SoundManager:Initialize() 
	self.CurrentScene = nil
	self.BGMIndexList = {
		TitleSceneBgm = 0,
		HomeSceneBgm = 1,
		BattleSceneBgm = 2,
	}
	self.BGMNameList = {
		"BGM_MusMus_TitleBgm",
		"BGM_MusMus_HomeBgm",
		"BGM_MusMus_BattleBgm",
	}

	for i = 1, #self.BGMNameList do
		LuaUnityDebugLog("SoundManagerInit!!")
		LuaUnityAddBGMAudioSourceAndClip("Sound", self.BGMNameList[i])
	end
end

-- シーンの切り替え
function SoundManager:PlayBGM(index) 
	LuaUnityPlayBGM(index)
end

