--直接Unityには登録しないスクリプト。いわゆる、ライブラリ化した奴

EnemyTypeEnum = {
	Normal = 0,
	BulletShooter = 1,
}

-- 敵の定義
--ステージ番号_連番号
--000_000
--検証
EnemyTest = {
	PrefabName = "Prefabs/EnemyCharacterObject2",
	Name = "EnemyCharacterObject",
	Width = 48,
	Height = 48,
	NowHp = 1,
	MaxHp = 1,
	Attack = 1,
	EXP = 1,
	MoveType = MoveStraight.new(0),
	EnemyType = EnemyTypeEnum.Normal,
}
EnemyTestBullet = {
	PrefabName = "Prefabs/EnemyCharacterObject2",
	Name = "EnemyCharacterObject",
	Width = 48,
	Height = 48,
	NowHp = 1,
	MaxHp = 1,
	Attack = 1,
	EXP = 1,
	MoveType = MoveStraight.new(0),
	EnemyType = EnemyTypeEnum.BulletShooter,
	BulletEmitterList = {
		Emitter001.new(0.5, Vector2.new(0, 0), EmitterTypeEnum.Normal),
	},
	EquipBulletList = {
		EnemyBullet0001,
	},-- 今は、BulletEmitterListとEquipBulletListの数は同じにしておかないとダメ
}
--"検証

--敵情報1
Enemy001_001 = {
	PrefabName = "Prefabs/EnemyCharacterObject",
	Name = "EnemyCharacterObject",
	Width = 32,
	Height = 32,
	NowHp = 1,
	MaxHp = 1,
	Attack = 1,
	EXP = 1,
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
	EXP = 1,
	MoveType = MoveStraight.new(5),
	EnemyType = EnemyTypeEnum.Normal,
}
--!敵情報1

--敵情報2
Enemy002_001 = {
	PrefabName = "Prefabs/EnemyCharacterObject3",
	Name = "EnemyCharacterObject3",
	Width = 32,
	Height = 32,
	NowHp = 1,
	MaxHp = 1,
	Attack = 1,
	EXP = 1,
	MoveType = MoveSinCurve.new(0, 1.5, 3),
	EnemyType = EnemyTypeEnum.Normal,
}

Enemy002_002 = {
	PrefabName = "Prefabs/EnemyCharacterObject3",
	Name = "EnemyCharacterObject3",
	Width = 32,
	Height = 32,
	NowHp = 1,
	MaxHp = 1,
	Attack = 1,
	EXP = 1,
	MoveType = MoveSinCurve.new(180, 1.5, 3),
	EnemyType = EnemyTypeEnum.Normal,
}
--!敵情報2

--敵情報3
Enemy003_001 = {
	PrefabName = "Prefabs/EnemyCharacterObject",
	Name = "EnemyCharacterObject",
	Width = 32,
	Height = 32,
	NowHp = 1,
	MaxHp = 1,
	Attack = 1,
	EXP = 1,
	MoveType = MoveStraight.new(1),
	EnemyType = EnemyTypeEnum.BulletShooter,
	BulletEmitterList = {
		Emitter001.new(0.5, Vector2.new(0, 0), EmitterTypeEnum.Normal),
	},
	EquipBulletList = {
		Bullet0002,
	},-- 今は、BulletEmitterListとEquipBulletListの数は同じにしておかないとダメ
}

Enemy003_002 = {
	PrefabName = "Prefabs/EnemyCharacterObject",
	Name = "EnemyCharacterObject",
	Width = 32,
	Height = 32,
	NowHp = 1,
	MaxHp = 1,
	Attack = 1,
	EXP = 1,
	MoveType = MoveSinCurve.new(0, 1.5, 3),
	EnemyType = EnemyTypeEnum.BulletShooter,
	BulletEmitterList = {
		Emitter001.new(0.5, Vector2.new(0, 0), EmitterTypeEnum.Normal),
	},
	EquipBulletList = {
		Bullet0002,
	},-- 今は、BulletEmitterListとEquipBulletListの数は同じにしておかないとダメ
}

Enemy003_003 = {
	PrefabName = "Prefabs/EnemyCharacterObject",
	Name = "EnemyCharacterObject",
	Width = 32,
	Height = 32,
	NowHp = 1,
	MaxHp = 1,
	Attack = 1,
	EXP = 1,
	MoveType = MoveSinCurve.new(180, 1.5, 3),
	EnemyType = EnemyTypeEnum.BulletShooter,
	BulletEmitterList = {
		Emitter001.new(0.5, Vector2.new(0, 0), EmitterTypeEnum.Normal),
	},
	EquipBulletList = {
		Bullet0002,
	},-- 今は、BulletEmitterListとEquipBulletListの数は同じにしておかないとダメ
}
--!敵情報3
