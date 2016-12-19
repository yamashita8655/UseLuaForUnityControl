--直接Unityには登録しないスクリプト。いわゆる、ライブラリ化した奴

EnemyTypeEnum = {
	Normal = 0,
	BulletShooter = 1,
}

-- 敵の定義
--ステージ番号_連番号
--000_000
--ステージ1
Enemy001_001 = {
	PrefabName = "Prefabs/EnemyCharacterObject",
	Name = "EnemyCharacterObject",
	Width = 32,
	Height = 32,
	NowHp = 1,
	MaxHp = 1,
	Attack = 1,
	MoveType = MoveStraight.new(1),
	EnemyType = EnemyTypeEnum.Normal,
}

Enemy001_002 = {
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
--!ステージ1

--ステージ2
Enemy002_001 = {
	PrefabName = "Prefabs/EnemyCharacterObject",
	Name = "EnemyCharacterObject",
	Width = 32,
	Height = 32,
	NowHp = 1,
	MaxHp = 1,
	Attack = 1,
	MoveType = MoveSinCurve.new(0, 1.5, 3),
	EnemyType = EnemyTypeEnum.Normal,
}

Enemy002_002 = {
	PrefabName = "Prefabs/EnemyCharacterObject",
	Name = "EnemyCharacterObject",
	Width = 32,
	Height = 32,
	NowHp = 1,
	MaxHp = 1,
	Attack = 1,
	MoveType = MoveSinCurve.new(180, 1.5, 3),
	EnemyType = EnemyTypeEnum.Normal,
}
--!ステージ2

--ステージ3
Enemy003_001 = {
	PrefabName = "Prefabs/EnemyCharacterObject",
	Name = "EnemyCharacterObject",
	Width = 32,
	Height = 32,
	NowHp = 1,
	MaxHp = 1,
	Attack = 1,
	MoveType = MoveStraight.new(1),
	EnemyType = EnemyTypeEnum.BulletShooter,
}

Enemy003_002 = {
	PrefabName = "Prefabs/EnemyCharacterObject",
	Name = "EnemyCharacterObject",
	Width = 32,
	Height = 32,
	NowHp = 1,
	MaxHp = 1,
	Attack = 1,
	MoveType = MoveSinCurve.new(0, 1.5, 3),
	EnemyType = EnemyTypeEnum.BulletShooter,
}

Enemy003_003 = {
	PrefabName = "Prefabs/EnemyCharacterObject",
	Name = "EnemyCharacterObject",
	Width = 32,
	Height = 32,
	NowHp = 1,
	MaxHp = 1,
	Attack = 1,
	MoveType = MoveSinCurve.new(180, 1.5, 3),
	EnemyType = EnemyTypeEnum.BulletShooter,
}
