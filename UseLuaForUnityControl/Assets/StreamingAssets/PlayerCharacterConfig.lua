--直接Unityには登録しないスクリプト。いわゆる、ライブラリ化した奴

-- プレイヤーキャラクター定義
PlayerCharacter001 = {
	PrefabName = "Prefabs/PlayerCharacterObject001",
	Name = "PlayerCharacterObject001",
	Width = 128,
	Height = 128,
	NowHp = 100,
	MaxHp = 100,
	BulletEmitterPointList = {
		Vector2.new(0, 100),
		Vector2.new(0, -100),
		--Vector2.new(100, 0),
		--Vector2.new(-100, 0),
	},
}

PlayerCharacter002 = {
	PrefabName = "Prefabs/PlayerCharacterObject002",
	Name = "PlayerCharacterObject002",
	Width = 64,
	Height = 64,
	NowHp = 50,
	MaxHp = 100,
	BulletEmitterPointList = {
		Vector2.new(0, 0),
	},
}

