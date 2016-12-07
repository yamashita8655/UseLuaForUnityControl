--直接Unityには登録しないスクリプト。いわゆる、ライブラリ化した奴

EnemyTypeEnum = {
	Normal = 0,
	BulletShooter = 1,
}

-- 敵の定義
Enemy0001 = {
	PrefabName = "Prefabs/EnemyCharacterObject",
	Name = "EnemyCharacterObject",
	Width = 32,
	Height = 32,
	NowHp = 1,
	MaxHp = 1,
	Attack = 1,
	MoveType = MoveStraight.new(5),
	EnemyType = EnemyTypeEnum.Normal,
}

Enemy0002 = {
	PrefabName = "Prefabs/EnemyCharacterObject",
	Name = "EnemyCharacterObject",
	Width = 32,
	Height = 32,
	NowHp = 1,
	MaxHp = 1,
	Attack = 1,
	MoveType = MoveSinCurve.new(1, 1, 1),
	EnemyType = EnemyTypeEnum.Normal,
}

Enemy0003 = {
	PrefabName = "Prefabs/EnemyCharacterObject",
	Name = "EnemyCharacterObject",
	Width = 32,
	Height = 32,
	NowHp = 1,
	MaxHp = 1,
	Attack = 1,
	MoveType = MoveSinCurve.new(2, 2, 2),
	EnemyType = EnemyTypeEnum.BulletShooter,
}

