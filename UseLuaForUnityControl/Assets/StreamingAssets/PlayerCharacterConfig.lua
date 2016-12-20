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
		Emitter001.new(1.0, Vector2.new(0, 0), EmitterTypeEnum.Normal),
		Emitter001.new(0.25, Vector2.new(100, 0), EmitterTypeEnum.Satellite),
		Emitter001.new(0.25, Vector2.new(-100, 0), EmitterTypeEnum.Satellite),
	},
	EquipBulletList = {
		BulletStrong,
		Bullet0002,
		Bullet0002,
	},-- 今は、BulletEmitterListとEquipBulletListの数は同じにしておかないとダメ
	DetailText = "PlayerCharacter001の特徴です\n改行コード見れるのかな",
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
		Emitter001.new(1.0, Vector2.new(0, 0), EmitterTypeEnum.Normal),
		Emitter001.new(0.25, Vector2.new(0, 0), EmitterTypeEnum.Normal),
	},
	EquipBulletList = {
		Bullet0002,
		Bullet0001,
		Bullet0002,
	},-- 今は、BulletEmitterListとEquipBulletListの数は同じにしておかないとダメ
	DetailText = "PlayerCharacter002の特徴です\n\n改行コード見れるのかな",
}


-- キャラ選択画面に表示する方
PlayerSelect_PlayerCharacter001 = {
}

