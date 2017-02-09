--直接Unityには登録しないスクリプト。いわゆる、ライブラリ化した奴

-- コンストラクタ
ParameterItemData = {}
function ParameterItemData.new(rarity, parameterType, addValue)
	local this = {
		Rarity = rarity,
		ParameterType = parameterType,
		AddValue = addValue,
	}
	
	this.GetRarity = function(self)
		return self.Rarity
	end
	this.GetParameterType = function(self)
		return self.ParameterType
	end
	this.GetAddValue = function(self)
		return self.AddValue
	end

	return this
end

-- ガチャから排出されるアイテムの定義
GachaItemTable = {
	ParameterUpHp1_001 = ParameterItemData.new(1, ParameterType.AddHp, 0.1),
	
	ParameterUpAttack1_001 = ParameterItemData.new(1, ParameterType.AddAttack, 0.1),
	
	ParameterUpDeffense1_001 = ParameterItemData.new(1, ParameterType.AddDeffense, 0.1)
}


