--直接Unityには登録しないスクリプト。いわゆる、ライブラリ化した奴
BulletTypeEnum = {
	Normal = 0,--ノーマルって書いてあるけど、弾の情報だけで処理できる弾
	UseTargetPosition = 1,--他の何かの座標値が影響する弾の情報
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
	MoveType = MoveSinCurve.new(0, 10, 10),
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

Bullet0003 = {
	PrefabName = "Prefabs/EnemyCharacterObject",
	Name = "EnemyCharacterObject",
	Width = 64,
	Height = 64,
	NowHp = 1,
	MaxHp = 1,
	Attack = 1,
	ExistTime = 3,
	MoveType = MoveSinCurve.new(180, 10, 10),
	BulletType = BulletTypeEnum.Normal,
}

BulletHomingTest = {
	PrefabName = "Prefabs/EnemyCharacterObject",
	Name = "EnemyCharacterObject",
	Width = 64,
	Height = 64,
	NowHp = 30,
	MaxHp = 30,
	Attack = 1,
	ExistTime = 50,
	MoveType = MoveHoming.new(0.25, 0, 10),
	BulletType = BulletTypeEnum.UseTargetPosition,
}
