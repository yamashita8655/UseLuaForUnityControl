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

	-- ウッドガチャ用
	-- モチの強化アイテムしか出ない
	ParameterUpHp1_001 = ParameterItemData.new(
		ItemType.ParameterUp,
		"CommonCharacterIcon1",
		RarityType.Normal,
		ParameterType.AddHp,
		0.2,
		CharacterTypeEnum.Mochi
	),
	ParameterUpAttack1_001 = ParameterItemData.new(
		ItemType.ParameterUp,
		"CommonCharacterIcon1",
		RarityType.Normal,
		ParameterType.AddAttack,
		0.01,
		CharacterTypeEnum.Mochi
	),
	ParameterUpDeffense1_001 = ParameterItemData.new(
		ItemType.ParameterUp,
		"CommonCharacterIcon1",
		RarityType.Normal,
		ParameterType.AddDeffense,
		0.01,
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
		2,
		CharacterTypeEnum.Mochi
	),
	ParameterUpAttack2_001 = ParameterItemData.new(
		ItemType.ParameterUp,
		"CommonCharacterIcon1",
		RarityType.Normal,
		ParameterType.AddAttack,
		0.1,
		CharacterTypeEnum.Mochi
	),
	ParameterUpDeffense2_001 = ParameterItemData.new(
		ItemType.ParameterUp,
		"CommonCharacterIcon1",
		RarityType.Normal,
		ParameterType.AddDeffense,
		0.1,
		CharacterTypeEnum.Mochi
	),
	ParameterUpFriendPoint2_001 = ParameterItemData.new(
		ItemType.ParameterUp,
		"CommonCharacterIcon1",
		RarityType.Normal,
		ParameterType.FriendPoint,
		0.1,
		CharacterTypeEnum.Mochi
	),
	
	-- ブロンズガチャ用
	MochiBronzeHpNormal = ParameterItemData.new(
		ItemType.ParameterUp,
		"CommonCharacterIcon1",
		RarityType.Normal,
		ParameterType.AddHp,
		0.4,
		CharacterTypeEnum.Mochi
	),
	MochiBronzeAttackNormal = ParameterItemData.new(
		ItemType.ParameterUp,
		"CommonCharacterIcon1",
		RarityType.Normal,
		ParameterType.AddAttack,
		0.02,
		CharacterTypeEnum.Mochi
	),
	MochiBronzeDeffenseNormal = ParameterItemData.new(
		ItemType.ParameterUp,
		"CommonCharacterIcon1",
		RarityType.Normal,
		ParameterType.AddDeffense,
		0.02,
		CharacterTypeEnum.Mochi
	),
	MochiBronzeFriendPointNormal = ParameterItemData.new(
		ItemType.ParameterUp,
		"CommonCharacterIcon1",
		RarityType.Normal,
		ParameterType.FriendPoint,
		0.02,
		CharacterTypeEnum.Mochi
	),
	MochiBronzeHpRare = ParameterItemData.new(
		ItemType.ParameterUp,
		"CommonCharacterIcon1",
		RarityType.Normal,
		ParameterType.AddHp,
		4,
		CharacterTypeEnum.Mochi
	),
	MochiBronzeAttackRare = ParameterItemData.new(
		ItemType.ParameterUp,
		"CommonCharacterIcon1",
		RarityType.Normal,
		ParameterType.AddAttack,
		0.2,
		CharacterTypeEnum.Mochi
	),
	MochiBronzeDeffenseRare = ParameterItemData.new(
		ItemType.ParameterUp,
		"CommonCharacterIcon1",
		RarityType.Normal,
		ParameterType.AddDeffense,
		0.2,
		CharacterTypeEnum.Mochi
	),
	MochiBronzeFriendPointRare = ParameterItemData.new(
		ItemType.ParameterUp,
		"CommonCharacterIcon1",
		RarityType.Normal,
		ParameterType.FriendPoint,
		0.2,
		CharacterTypeEnum.Mochi
	),
	
	ToraBronzeHpNormal = ParameterItemData.new(
		ItemType.ParameterUp,
		"CommonCharacterIcon2",
		RarityType.Normal,
		ParameterType.AddHp,
		0.5,
		CharacterTypeEnum.Tora
	),
	ToraBronzeAttackNormal = ParameterItemData.new(
		ItemType.ParameterUp,
		"CommonCharacterIcon2",
		RarityType.Normal,
		ParameterType.AddAttack,
		0.04,
		CharacterTypeEnum.Tora
	),
	ToraBronzeDeffenseNormal = ParameterItemData.new(
		ItemType.ParameterUp,
		"CommonCharacterIcon2",
		RarityType.Normal,
		ParameterType.AddDeffense,
		0.01,
		CharacterTypeEnum.Tora
	),
	ToraBronzeFriendPointNormal = ParameterItemData.new(
		ItemType.ParameterUp,
		"CommonCharacterIcon2",
		RarityType.Normal,
		ParameterType.FriendPoint,
		0.02,
		CharacterTypeEnum.Tora
	),
	ToraBronzeHpRare = ParameterItemData.new(
		ItemType.ParameterUp,
		"CommonCharacterIcon2",
		RarityType.Normal,
		ParameterType.AddHp,
		5,
		CharacterTypeEnum.Tora
	),
	ToraBronzeAttackRare = ParameterItemData.new(
		ItemType.ParameterUp,
		"CommonCharacterIcon2",
		RarityType.Normal,
		ParameterType.AddAttack,
		0.4,
		CharacterTypeEnum.Tora
	),
	ToraBronzeDeffenseRare = ParameterItemData.new(
		ItemType.ParameterUp,
		"CommonCharacterIcon2",
		RarityType.Normal,
		ParameterType.AddDeffense,
		0.1,
		CharacterTypeEnum.Tora
	),
	ToraBronzeFriendPointRare = ParameterItemData.new(
		ItemType.ParameterUp,
		"CommonCharacterIcon2",
		RarityType.Normal,
		ParameterType.FriendPoint,
		0.2,
		CharacterTypeEnum.Tora
	),

	BuchiBronzeHpNormal = ParameterItemData.new(
		ItemType.ParameterUp,
		"CommonCharacterIcon3",
		RarityType.Normal,
		ParameterType.AddHp,
		0.1,
		CharacterTypeEnum.Buchi
	),
	BuchiBronzeAttackNormal = ParameterItemData.new(
		ItemType.ParameterUp,
		"CommonCharacterIcon3",
		RarityType.Normal,
		ParameterType.AddAttack,
		0.01,
		CharacterTypeEnum.Buchi
	),
	BuchiBronzeDeffenseNormal = ParameterItemData.new(
		ItemType.ParameterUp,
		"CommonCharacterIcon3",
		RarityType.Normal,
		ParameterType.AddDeffense,
		0.04,
		CharacterTypeEnum.Buchi
	),
	BuchiBronzeFriendPointNormal = ParameterItemData.new(
		ItemType.ParameterUp,
		"CommonCharacterIcon3",
		RarityType.Normal,
		ParameterType.FriendPoint,
		0.02,
		CharacterTypeEnum.Buchi
	),
	BuchiBronzeHpRare = ParameterItemData.new(
		ItemType.ParameterUp,
		"CommonCharacterIcon3",
		RarityType.Normal,
		ParameterType.AddHp,
		1,
		CharacterTypeEnum.Buchi
	),
	BuchiBronzeAttackRare = ParameterItemData.new(
		ItemType.ParameterUp,
		"CommonCharacterIcon3",
		RarityType.Normal,
		ParameterType.AddAttack,
		0.1,
		CharacterTypeEnum.Buchi
	),
	BuchiBronzeDeffenseRare = ParameterItemData.new(
		ItemType.ParameterUp,
		"CommonCharacterIcon3",
		RarityType.Normal,
		ParameterType.AddDeffense,
		0.4,
		CharacterTypeEnum.Buchi
	),
	BuchiBronzeFriendPointRare = ParameterItemData.new(
		ItemType.ParameterUp,
		"CommonCharacterIcon3",
		RarityType.Normal,
		ParameterType.FriendPoint,
		0.2,
		CharacterTypeEnum.Buchi
	),

	SakuraBronzeHpNormal = ParameterItemData.new(
		ItemType.ParameterUp,
		"CommonCharacterIcon4",
		RarityType.Normal,
		ParameterType.AddHp,
		0.4,
		CharacterTypeEnum.Sakura
	),
	SakuraBronzeAttackNormal = ParameterItemData.new(
		ItemType.ParameterUp,
		"CommonCharacterIcon4",
		RarityType.Normal,
		ParameterType.AddAttack,
		0.02,
		CharacterTypeEnum.Sakura
	),
	SakuraBronzeDeffenseNormal = ParameterItemData.new(
		ItemType.ParameterUp,
		"CommonCharacterIcon4",
		RarityType.Normal,
		ParameterType.AddDeffense,
		0.02,
		CharacterTypeEnum.Sakura
	),
	SakuraBronzeFriendPointNormal = ParameterItemData.new(
		ItemType.ParameterUp,
		"CommonCharacterIcon4",
		RarityType.Normal,
		ParameterType.FriendPoint,
		0.02,
		CharacterTypeEnum.Sakura
	),
	SakuraBronzeHpRare = ParameterItemData.new(
		ItemType.ParameterUp,
		"CommonCharacterIcon4",
		RarityType.Normal,
		ParameterType.AddHp,
		4,
		CharacterTypeEnum.Sakura
	),
	SakuraBronzeAttackRare = ParameterItemData.new(
		ItemType.ParameterUp,
		"CommonCharacterIcon4",
		RarityType.Normal,
		ParameterType.AddAttack,
		0.2,
		CharacterTypeEnum.Sakura
	),
	SakuraBronzeDeffenseRare = ParameterItemData.new(
		ItemType.ParameterUp,
		"CommonCharacterIcon4",
		RarityType.Normal,
		ParameterType.AddDeffense,
		0.2,
		CharacterTypeEnum.Sakura
	),
	SakuraBronzeFriendPointRare = ParameterItemData.new(
		ItemType.ParameterUp,
		"CommonCharacterIcon4",
		RarityType.Normal,
		ParameterType.FriendPoint,
		0.2,
		CharacterTypeEnum.Sakura
	),
	
}


