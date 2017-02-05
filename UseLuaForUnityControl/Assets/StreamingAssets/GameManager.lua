--直接Unityには登録しないスクリプト。いわゆる、ライブラリ化した奴

-- クラス定義
GameManager = {}

-- シングルトン用定義
local _instance = nil
function GameManager.Instance() 
	if not _instance then
		_instance = GameManager
		--_instance:Initialize()
	end

	return _instance
end

-- メソッド定義
function GameManager:Initialize() 
	self.SelectPlayerCharacterData = nil
	self.BattleDeltaTime = 1.0/60.0
	self.SelectQuestId = 0
	self.HaveKarikariValue = 0
	self.HaveMochiPointValue = 0
	self.KarikariSpawnRate = 1000--1%扱い。乱数は1000で割る為。
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

-- 選択されたクエストID
function GameManager:SetSelectQuestId(id) 
	self.SelectQuestId = id
end
function GameManager:GetSelectQuestId() 
	return self.SelectQuestId
end

-- 持っているカリカリの量
function GameManager:SetKarikariValue(value) 
	self.HaveKarikariValue = value
end
function GameManager:GetKarikariValue() 
	return self.HaveKarikariValue
end
function GameManager:AddKarikariValue(value) 
	self.HaveKarikariValue = self.HaveKarikariValue + value
end

-- 持っているもちポイントの量
function GameManager:SetMochiPointValue(value) 
	self.HaveMochiPointValue = value
end
function GameManager:GetMochiPointValue() 
	return self.HaveMochiPointValue
end
function GameManager:AddMochiPointValue(value) 
	self.HaveMochiPointValue = self.HaveMochiPointValue + value
end

-- カリカリポイント出現レート
function GameManager:GetKarikariRate() 
	return self.KarikariSpawnRate
end

function GameManager:Update(deltaTime) 
end

function GameManager:Release()
end

