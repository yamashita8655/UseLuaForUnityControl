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
	self.HaveBillingPointValue = 0
	self.HaveSpecialPointValue = 0
	self.KarikariSpawnRate = 1000--1%扱い。乱数は1000で割る為。
	self.GachaItemList = {}
	self.GachaItemAddParameterList = {}
	self.GachaItemCanNotAddParameterList = {}
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

-- 持っている課金ポイントの量
function GameManager:SetBillingPointValue(value) 
	self.HaveBillingPointValue = value
end
function GameManager:GetBillingPointValue() 
	return self.HaveBillingPointValue
end
function GameManager:AddBillingPointValue(value) 
	self.HaveBillingPointValue = self.HaveBillingPointValue + value
end

-- 持っている特別ポイントの量
function GameManager:SetSpecialPointValue(value) 
	self.HaveSpecialPointValue = value
end
function GameManager:GetSpecialPointValue() 
	return self.HaveSpecialPointValue
end
function GameManager:AddSpecialPointValue(value) 
	self.HaveSpecialPointValue = self.HaveSpecialPointValue + value
end

-- カリカリポイント出現レート
function GameManager:GetKarikariRate() 
	return self.KarikariSpawnRate
end

-- ガチャで引いた結果
function GameManager:SetGachaItemList(list) 
	self.GachaItemList = list
end
function GameManager:GetGachaItemList() 
	return self.GachaItemList
end
-- ガチャで引いた結果、キャラ毎の加算値計算後の値のリスト
function GameManager:SetGachaItemAddParameterList(list) 
	self.GachaItemAddParameterList = list
end
function GameManager:GetGachaItemAddParameterList() 
	return self.GachaItemAddParameterList
end
-- パラメータアップ数上限に引っかかったアイテムリスト
function GameManager:SetGachaItemCanNotAddParameterList(list) 
	self.GachaItemCanNotAddParameterList = list
end
function GameManager:GetGachaItemCanNotAddParameterList() 
	return self.GachaItemCanNotAddParameterList
end


function GameManager:Update(deltaTime) 
end

function GameManager:Release()
end

