--直接Unityには登録しないスクリプト。いわゆる、ライブラリ化した奴

-- クラス定義
GameManager = {}

-- シングルトン用定義
local _instance = nil
function GameManager.Instance() 
	if not _instance then
		_instance = GameManager
		_instance:Initialize()
	end

	return _instance
end

-- メソッド定義
function GameManager:Initialize() 
	self.SelectPlayerCharacterData = nil
	self.BattleDeltaTime = 1.0/60.0
end

-- 選択しているキャラクターデータ指定
function GameManager:SetSelectPlayerCharacterData(selectCharacterData) 
	self.SelectPlayerCharacterData = selectCharacterData
end
function GameManager:GetSelectPlayerCharacterData() 
	return self.SelectPlayerCharacterData
end

-- 呼び出される毎に加算する時間
function GameManager:GetBattleDeltaTime() 
	return self.BattleDeltaTime
end

function GameManager:Update(deltaTime) 
end

function GameManager:Release()
end

