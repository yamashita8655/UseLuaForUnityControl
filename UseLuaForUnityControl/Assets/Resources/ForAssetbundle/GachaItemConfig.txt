--直接Unityには登録しないスクリプト。いわゆる、ライブラリ化した奴

-- コンストラクタ
ParameterItemData = {}
function ParameterItemData.new(itemType, prefabName, rarity, parameterType, addValue, kindType)
	local this = {
		ItemType = itemType,
		PrefabName = prefabName,
		Rarity = rarity,
		ParameterType = parameterType,
		AddValue = addValue,
		KindType = kindType,
	}
	
	this.GetItemType = function(self)
		return self.ItemType
	end
	this.GetPrefabName = function(self)
		return self.PrefabName
	end
	this.GetRarity = function(self)
		return self.Rarity
	end
	this.GetParameterType = function(self)
		return self.ParameterType
	end
	this.GetAddValue = function(self)
		return self.AddValue
	end
	this.GetKindType = function(self)
		return self.KindType
	end

	return this
end

-- ガチャから排出されるアイテムの定義
GachaItemTable = {
	-- アイテムタイプ
	-- アイコンオブジェクト名
	-- レアリティ
	-- パラメータタイプ
	-- 増加量
	-- キャラタイプ
	ParameterUpHp1_001 = ParameterItemData.new(
		ItemType.ParameterUp,
		"CommonCharacterIcon1",
		RarityType.Normal,
		ParameterType.AddHp,
		1,
		CharacterTypeEnum.Mochi
	),
	ParameterUpAttack1_001 = ParameterItemData.new(
		ItemType.ParameterUp,
		"CommonCharacterIcon1",
		RarityType.Normal,
		ParameterType.AddAttack,
		0.05,
		CharacterTypeEnum.Mochi
	),
	ParameterUpDeffense1_001 = ParameterItemData.new(
		ItemType.ParameterUp,
		"CommonCharacterIcon1",
		RarityType.Normal,
		ParameterType.AddDeffense,
		0.05,
		CharacterTypeEnum.Mochi
	),
	ParameterUpFriendPoint1_001 = ParameterItemData.new(
		ItemType.ParameterUp,
		"CommonCharacterIcon1",
		RarityType.Normal,
		ParameterType.FriendPoint,
		0.01,
		CharacterTypeEnum.Mochi
	),
	ParameterUpHp2_001 = ParameterItemData.new(
		ItemType.ParameterUp,
		"CommonCharacterIcon1",
		RarityType.Normal,
		ParameterType.AddHp,
		10,
		CharacterTypeEnum.Mochi
	),
	ParameterUpAttack2_001 = ParameterItemData.new(
		ItemType.ParameterUp,
		"CommonCharacterIcon1",
		RarityType.Normal,
		ParameterType.AddAttack,
		1,
		CharacterTypeEnum.Mochi
	),
	ParameterUpDeffense2_001 = ParameterItemData.new(
		ItemType.ParameterUp,
		"CommonCharacterIcon1",
		RarityType.Normal,
		ParameterType.AddDeffense,
		1,
		CharacterTypeEnum.Mochi
	),
	ParameterUpFriendPoint2_001 = ParameterItemData.new(
		ItemType.ParameterUp,
		"CommonCharacterIcon1",
		RarityType.Normal,
		ParameterType.FriendPoint,
		1,
		CharacterTypeEnum.Mochi
	),
	
	ParameterUpHp1_002 = ParameterItemData.new(
		ItemType.ParameterUp,
		"CommonCharacterIcon2",
		RarityType.Normal,
		ParameterType.AddHp,
		0.1,
		CharacterTypeEnum.Tora),
	
	ParameterUpAttack1_002 = ParameterItemData.new(
		ItemType.ParameterUp,
		"CommonCharacterIcon2",
		RarityType.Normal,
		ParameterType.AddAttack,
		0.1,
		CharacterTypeEnum.Tora
	),
	ParameterUpDeffense1_002 = ParameterItemData.new(
		ItemType.ParameterUp,
		"CommonCharacterIcon2",
		RarityType.Normal,
		ParameterType.AddDeffense,
		0.1,
		CharacterTypeEnum.Tora
	),
	ParameterUpFriendPoint1_002 = ParameterItemData.new(
		ItemType.ParameterUp,
		"CommonCharacterIcon2",
		RarityType.Normal,
		ParameterType.FriendPoint,
		1,
		CharacterTypeEnum.Tora
	),
	
	ParameterUpHp1_003 = ParameterItemData.new(
		ItemType.ParameterUp,
		"CommonCharacterIcon3",
		RarityType.Normal,
		ParameterType.AddHp,
		0.1,
		CharacterTypeEnum.Buchi
	),
	ParameterUpAttack1_003 = ParameterItemData.new(
		ItemType.ParameterUp,
		"CommonCharacterIcon3",
		RarityType.Normal,
		ParameterType.AddAttack,
		0.1,
		CharacterTypeEnum.Buchi
	),
	ParameterUpDeffense1_003 = ParameterItemData.new(
		ItemType.ParameterUp,
		"CommonCharacterIcon3",
		RarityType.Normal,
		ParameterType.AddDeffense,
		0.1,
		CharacterTypeEnum.Buchi
	),
	ParameterUpFriendPoint1_003 = ParameterItemData.new(
		ItemType.ParameterUp,
		"CommonCharacterIcon3",
		RarityType.Normal,
		ParameterType.FriendPoint,
		1,
		CharacterTypeEnum.Buchi
	),
	
	ParameterUpHp1_004 = ParameterItemData.new(
		ItemType.ParameterUp,
		"CommonCharacterIcon4",
		RarityType.Normal,
		ParameterType.AddHp,
		0.1,
		CharacterTypeEnum.Sakura
	),
	ParameterUpAttack1_004 = ParameterItemData.new(
		ItemType.ParameterUp,
		"CommonCharacterIcon4",
		RarityType.Normal,
		ParameterType.AddAttack,
		0.1,
		CharacterTypeEnum.Sakura
	),
	ParameterUpDeffense1_004 = ParameterItemData.new(
		ItemType.ParameterUp,
		"CommonCharacterIcon4",
		RarityType.Normal,
		ParameterType.AddDeffense,
		0.1,
		CharacterTypeEnum.Sakura
	),
	ParameterUpFriendPoint1_004 = ParameterItemData.new(
		ItemType.ParameterUp,
		"CommonCharacterIcon4",
		RarityType.Normal,
		ParameterType.FriendPoint,
		1,
		CharacterTypeEnum.Sakura
	),
}


