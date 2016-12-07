--直接Unityには登録しないスクリプト。いわゆる、ライブラリ化した奴
BulletTypeEnum = {
	Normal = 0,
}

-- 弾の定義
Bullet0001 = {
	PrefabName = "Prefabs/EnemyCharacterObject",
	Name = "EnemyCharacterObject",
	Width = 64,
	Height = 64,
	NowHp = 1,
	MaxHp = 1,
	Attack = 1,
	ExistTime = 3,
	MoveType = MoveSinCurve.new(3, 3, 3),
	BulletType = BulletTypeEnum.Normal,
}

Bullet0002 = {
	PrefabName = "Prefabs/EnemyCharacterObject",
	Name = "EnemyCharacterObject",
	Width = 64,
	Height = 64,
	NowHp = 1,
	MaxHp = 1,
	Attack = 1,
	ExistTime = 3,
	MoveType = MoveStraight.new(15),
	BulletType = BulletTypeEnum.Normal,
}

