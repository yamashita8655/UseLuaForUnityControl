--直接Unityには登録しないスクリプト。いわゆる、ライブラリ化した奴

MoveTypeEnum = {
	Straight = 0,
	SinCurve = 1,
}

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
	MoveType = MoveTypeEnum.Straight,
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
	MoveType = MoveTypeEnum.SinCurve,
	EnemyType = EnemyTypeEnum.Normal,
}

