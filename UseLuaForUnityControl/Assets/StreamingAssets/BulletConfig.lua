--直接Unityには登録しないスクリプト。いわゆる、ライブラリ化した奴
BulletTypeEnum = {
	Normal = 0,--ノーマルって書いてあるけど、弾の情報だけで処理できる弾
	UseTargetPosition = 1,--他の何かの座標値が影響する弾の情報
}

-- 弾の定義
Character1_Bullet0001 = {
	PrefabName = "Prefabs/BulletObjectNormal",
	Name = "PlayerBullet1",
	Width = 64,
	Height = 64,
	NowHp = 1,
	MaxHp = 1,
	Attack = 1,
	ExistTime = 3,
	MoveType = MoveStraight.new(15),
	BulletType = BulletTypeEnum.Normal,
}

Character1_Bullet0002 = {
	PrefabName = "Prefabs/BulletObjectNormal",
	Name = "PlayerBullet2",
	Width = 64,
	Height = 64,
	NowHp = 1,
	MaxHp = 1,
	Attack = 1.5,
	ExistTime = 3,
	MoveType = MoveStraight.new(15),
	BulletType = BulletTypeEnum.Normal,
}

Character1_Bullet0003 = {
	PrefabName = "Prefabs/BulletObjectEnemyTooth1",
	Name = "PlayerBullet3",
	Width = 64,
	Height = 64,
	NowHp = 1,
	MaxHp = 1,
	Attack = 2,
	ExistTime = 3,
	MoveType = MoveStraight.new(15),
	BulletType = BulletTypeEnum.Normal,
}

Bullet0001 = {
	PrefabName = "Prefabs/EnemyCharacterObject",
	Name = "EnemyBullet1",
	Width = 64,
	Height = 64,
	NowHp = 10,
	MaxHp = 10,
	Attack = 1,
	ExistTime = 3,
	MoveType = MoveSinCurve.new(0, 10, 10),
	BulletType = BulletTypeEnum.Normal,
}

Bullet0002 = {
	PrefabName = "Prefabs/EnemyCharacterObject",
	Name = "EnemyBullet2",
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
	Name = "EnemyBullet3",
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
	Name = "EnemyBulletHoming",
	Width = 64,
	Height = 64,
	NowHp = 1,
	MaxHp = 1,
	Attack = 1,
	ExistTime = 3,
	MoveType = MoveHoming.new(0.25, 0, 10),
	BulletType = BulletTypeEnum.UseTargetPosition,
}

BulletStrong = {
	PrefabName = "Prefabs/EnemyCharacterObject",
	Name = "EnemyBulletStrong",
	Width = 64,
	Height = 64,
	NowHp = 10,
	MaxHp = 10,
	Attack = 1,
	ExistTime = 5,
	MoveType = MoveSinCurve.new(180, 10, 10),
	BulletType = BulletTypeEnum.Normal,
}

EnemyBullet0001 = {
	PrefabName = "Prefabs/BulletObjectEnemyTooth1",
	Name = "EnemyBulletTooth1",
	Width = 24,
	Height = 24,
	NowHp = 1,
	MaxHp = 1,
	Attack = 1,
	ExistTime = 3,
	MoveType = MoveStraight.new(10),
	BulletType = BulletTypeEnum.Normal,
}

EnemyBullet0002 = {
	PrefabName = "Prefabs/EnemyCharacterObject",
	Name = "EnemyBulletTooth2",
	Width = 64,
	Height = 64,
	NowHp = 1,
	MaxHp = 1,
	Attack = 1,
	ExistTime = 3,
	MoveType = MoveStraight.new(10),
	BulletType = BulletTypeEnum.Normal,
}

EnemyBullet0003 = {
	PrefabName = "Prefabs/BulletObjectNormal",
	Name = "EnemyBulletTooth3",
	Width = 64,
	Height = 64,
	NowHp = 1,
	MaxHp = 1,
	Attack = 1,
	ExistTime = 3,
	MoveType = MoveStraight.new(10),
	BulletType = BulletTypeEnum.Normal,
}

EnemyBullet_Middle1_10 = {
	PrefabName = "Prefabs/BulletObjectEnemyTooth1",
	Name = "EnemyBulletTooth1",
	Width = 24,
	Height = 24,
	NowHp = 1,
	MaxHp = 1,
	Attack = 1,
	ExistTime = 10,
	MoveType = MoveStraight.new(3),
	BulletType = BulletTypeEnum.Normal,
}
