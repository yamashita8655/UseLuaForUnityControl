--直接Unityには登録しないスクリプト。いわゆる、ライブラリ化した奴

-- プレイヤーキャラクター定義
PlayerCharacter001 = {
	PrefabName = "Prefabs/PlayerCharacterObject001",
	Name = "PlayerCharacterObject001",
	Width = 128,
	Height = 128,
	NowHp = 100,
	MaxHp = 100,
	BulletEmitterList = {
		Emitter001.new(0.5, Vector2.new(0, 0), EmitterTypeEnum.Normal),
	},
	EquipBulletList = {
		BulletHomingTest,
	},-- 今は、BulletEmitterListとEquipBulletListの数は同じにしておかないとダメ
}

PlayerCharacter002 = {
	PrefabName = "Prefabs/PlayerCharacterObject002",
	Name = "PlayerCharacterObject002",
	Width = 64,
	Height = 64,
	NowHp = 50,
	MaxHp = 100,
	BulletEmitterList = {
		Emitter001.new(0.25, Vector2.new(0, 0), EmitterTypeEnum.Normal),
	},
}

