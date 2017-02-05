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
		Emitter001.new(0.5, Vector2.new(0, 0), 0, EmitterTypeEnum.Normal),
	},
	EquipBulletList = {
		EnemyBullet0001,
	},-- 今は、BulletEmitterListとEquipBulletListの数は同じにしておかないとダメ
}
EnemyTestBullet1 = {
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
		Emitter001.new(0.5, Vector2.new(0, 0), 0, EmitterTypeEnum.Normal),
	},
	EquipBulletList = {
		EnemyBullet0001,
	},-- 今は、BulletEmitterListとEquipBulletListの数は同じにしておかないとダメ
}
EnemyTestBullet2 = {
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
		Emitter001.new(0.5, Vector2.new(0, 0), 0, EmitterTypeEnum.Normal),
	},
	EquipBulletList = {
		EnemyBullet0002,
	},-- 今は、BulletEmitterListとEquipBulletListの数は同じにしておかないとダメ
}
EnemyTestBullet3 = {
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
		Emitter001.new(0.5, Vector2.new(0, 0), 0, EmitterTypeEnum.Normal),
	},
	EquipBulletList = {
		EnemyBullet0003,
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
		Emitter001.new(0.5, Vector2.new(0, 0), 0, EmitterTypeEnum.Normal),
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
		Emitter001.new(0.5, Vector2.new(0, 0), 0, EmitterTypeEnum.Normal),
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
		Emitter001.new(0.5, Vector2.new(0, 0), 0, EmitterTypeEnum.Normal),
	},
	EquipBulletList = {
		Bullet0002,
	},-- 今は、BulletEmitterListとEquipBulletListの数は同じにしておかないとダメ
}
--!敵情報3

EnemyMiniMouseStraight1_10 = {
	PrefabName = "Prefabs/EnemyCharacterMiniMouse",
	Name = "EnemyCharacterMiniMouse",
	Width = 32,
	Height = 32,
	NowHp = 1,
	MaxHp = 1,
	Attack = 1,
	EXP = 1,
	MoveType = MoveStraight.new(1),
	EnemyType = EnemyTypeEnum.Normal,
}

EnemyMiniMouseSinCurve1_10 = {
	PrefabName = "Prefabs/EnemyCharacterMiniMouse",
	Name = "EnemyCharacterMiniMouse",
	Width = 32,
	Height = 32,
	NowHp = 1,
	MaxHp = 1,
	Attack = 1,
	EXP = 1,
	MoveType = MoveSinCurve.new(0, 1.5, 1.5),
	EnemyType = EnemyTypeEnum.Normal,
}

EnemyMiniMouseSinCurve1_10_1 = {
	PrefabName = "Prefabs/EnemyCharacterMiniMouse",
	Name = "EnemyCharacterMiniMouse",
	Width = 32,
	Height = 32,
	NowHp = 1,
	MaxHp = 1,
	Attack = 1,
	EXP = 1,
	MoveType = MoveSinCurve.new(0, 1.5, 1.5),
	EnemyType = EnemyTypeEnum.Normal,
}

EnemyMiniMouseSinCurve1_10_2 = {
	PrefabName = "Prefabs/EnemyCharacterMiniMouse",
	Name = "EnemyCharacterMiniMouse",
	Width = 32,
	Height = 32,
	NowHp = 1,
	MaxHp = 1,
	Attack = 1,
	EXP = 1,
	MoveType = MoveSinCurve.new(180, 1.5, 1.5),
	EnemyType = EnemyTypeEnum.Normal,
}

EnemyMiddleMouse1_10 = {
	PrefabName = "Prefabs/EnemyCharacterMiddleMouse",
	Name = "EnemyCharacterMiddleMouse",
	Width = 48,
	Height = 48,
	NowHp = 10,
	MaxHp = 10,
	Attack = 1,
	EXP = 1,
	MoveType = MoveStraight.new(1),
	EnemyType = EnemyTypeEnum.BulletShooter,
	BulletEmitterList = {
		Emitter001.new(2, Vector2.new(0, 0), 0, EmitterTypeEnum.Normal),
	},
	EquipBulletList = {
		EnemyBullet_Middle1_10,
	},-- 今は、BulletEmitterListとEquipBulletListの数は同じにしておかないとダメ
}

EnemySpeedMouse1_10 = {
	PrefabName = "Prefabs/EnemyCharacterSpeedMouse",
	Name = "EnemyCharacterSpeedMouse",
	Width = 32,
	Height = 32,
	NowHp = 1,
	MaxHp = 1,
	Attack = 1,
	EXP = 1,
	MoveType = MoveStraight.new(5),
	EnemyType = EnemyTypeEnum.Normal,
}

EnemyCircleMouse1_10 = {
	PrefabName = "Prefabs/EnemyCharacterCircleBulletMouse",
	Name = "EnemyCharacterCircleBulletMouse",
	Width = 32,
	Height = 32,
	NowHp = 1,
	MaxHp = 1,
	Attack = 1,
	EXP = 1,
	MoveType = MoveCircle.new(0, 1.5, 0),
	EnemyType = EnemyTypeEnum.Normal,
}

EnemyTankMouse1_10 = {
	PrefabName = "Prefabs/EnemyCharacterTankMouse",
	Name = "EnemyCharacterTankMouse",
	Width = 32,
	Height = 32,
	NowHp = 25,
	MaxHp = 25,
	Attack = 1,
	EXP = 1,
	MoveType = MoveStraight.new(1),
	EnemyType = EnemyTypeEnum.Normal,
}

EnemyMiniMouseStraight11_20 = {
	PrefabName = "Prefabs/EnemyCharacterMiniMouse",
	Name = "EnemyCharacterMiniMouse",
	Width = 32,
	Height = 32,
	NowHp = 2,
	MaxHp = 2,
	Attack = 2,
	EXP = 2,
	MoveType = MoveStraight.new(1),
	EnemyType = EnemyTypeEnum.Normal,
}

EnemyMiniMouseSinCurve11_20_1 = {
	PrefabName = "Prefabs/EnemyCharacterMiniMouse",
	Name = "EnemyCharacterMiniMouse",
	Width = 32,
	Height = 32,
	NowHp = 2,
	MaxHp = 2,
	Attack = 2,
	EXP = 2,
	MoveType = MoveSinCurve.new(0, 1.5, 1.5),
	EnemyType = EnemyTypeEnum.Normal,
}

EnemyMiniMouseSinCurve11_20_2 = {
	PrefabName = "Prefabs/EnemyCharacterMiniMouse",
	Name = "EnemyCharacterMiniMouse",
	Width = 32,
	Height = 32,
	NowHp = 2,
	MaxHp = 2,
	Attack = 2,
	EXP = 2,
	MoveType = MoveSinCurve.new(180, 1.5, 1.5),
	EnemyType = EnemyTypeEnum.Normal,
}

EnemyMiddleMouse11_20 = {
	PrefabName = "Prefabs/EnemyCharacterMiddleMouse",
	Name = "EnemyCharacterMiddleMouse",
	Width = 48,
	Height = 48,
	NowHp = 20,
	MaxHp = 20,
	Attack = 2,
	EXP = 2,
	MoveType = MoveStraight.new(1),
	EnemyType = EnemyTypeEnum.BulletShooter,
	BulletEmitterList = {
		Emitter001.new(2, Vector2.new(0, 0), 0, EmitterTypeEnum.Normal),
	},
	EquipBulletList = {
		EnemyBullet_Middle1_10,
	},-- 今は、BulletEmitterListとEquipBulletListの数は同じにしておかないとダメ
}

EnemySpeedMouse11_20 = {
	PrefabName = "Prefabs/EnemyCharacterSpeedMouse",
	Name = "EnemyCharacterSpeedMouse",
	Width = 32,
	Height = 32,
	NowHp = 2,
	MaxHp = 2,
	Attack = 2,
	EXP = 2,
	MoveType = MoveStraight.new(5),
	EnemyType = EnemyTypeEnum.Normal,
}

EnemyCircleMouse11_20 = {
	PrefabName = "Prefabs/EnemyCharacterCircleBulletMouse",
	Name = "EnemyCharacterCircleBulletMouse",
	Width = 32,
	Height = 32,
	NowHp = 2,
	MaxHp = 2,
	Attack = 2,
	EXP = 2,
	MoveType = MoveCircle.new(0, 1.5, 0),
	EnemyType = EnemyTypeEnum.Normal,
}

EnemyTankMouse11_20 = {
	PrefabName = "Prefabs/EnemyCharacterTankMouse",
	Name = "EnemyCharacterTankMouse",
	Width = 32,
	Height = 32,
	NowHp = 25,
	MaxHp = 25,
	Attack = 2,
	EXP = 2,
	MoveType = MoveStraight.new(1),
	EnemyType = EnemyTypeEnum.Normal,
}

EnemyMiniMouseStraight21_30 = {
	PrefabName = "Prefabs/EnemyCharacterMiniMouse",
	Name = "EnemyCharacterMiniMouse",
	Width = 32,
	Height = 32,
	NowHp = 3,
	MaxHp = 3,
	Attack = 3,
	EXP = 3,
	MoveType = MoveStraight.new(1),
	EnemyType = EnemyTypeEnum.Normal,
}

EnemyMiniMouseSinCurve21_30_1 = {
	PrefabName = "Prefabs/EnemyCharacterMiniMouse",
	Name = "EnemyCharacterMiniMouse",
	Width = 32,
	Height = 32,
	NowHp = 3,
	MaxHp = 3,
	Attack = 3,
	EXP = 3,
	MoveType = MoveSinCurve.new(0, 1.5, 1.5),
	EnemyType = EnemyTypeEnum.Normal,
}

EnemyMiniMouseSinCurve21_30_2 = {
	PrefabName = "Prefabs/EnemyCharacterMiniMouse",
	Name = "EnemyCharacterMiniMouse",
	Width = 32,
	Height = 32,
	NowHp = 3,
	MaxHp = 3,
	Attack = 3,
	EXP = 3,
	MoveType = MoveSinCurve.new(180, 1.5, 1.5),
	EnemyType = EnemyTypeEnum.Normal,
}

EnemyMiddleMouse21_30 = {
	PrefabName = "Prefabs/EnemyCharacterMiddleMouse",
	Name = "EnemyCharacterMiddleMouse",
	Width = 48,
	Height = 48,
	NowHp = 30,
	MaxHp = 30,
	Attack = 3,
	EXP = 3,
	MoveType = MoveStraight.new(1),
	EnemyType = EnemyTypeEnum.BulletShooter,
	BulletEmitterList = {
		Emitter001.new(2, Vector2.new(0, 0), 0, EmitterTypeEnum.Normal),
	},
	EquipBulletList = {
		EnemyBullet_Middle1_10,
	},-- 今は、BulletEmitterListとEquipBulletListの数は同じにしておかないとダメ
}

EnemySpeedMouse21_30 = {
	PrefabName = "Prefabs/EnemyCharacterSpeedMouse",
	Name = "EnemyCharacterSpeedMouse",
	Width = 32,
	Height = 32,
	NowHp = 3,
	MaxHp = 3,
	Attack = 3,
	EXP = 3,
	MoveType = MoveStraight.new(5),
	EnemyType = EnemyTypeEnum.Normal,
}

EnemyCircleMouse21_30 = {
	PrefabName = "Prefabs/EnemyCharacterCircleBulletMouse",
	Name = "EnemyCharacterCircleBulletMouse",
	Width = 32,
	Height = 32,
	NowHp = 3,
	MaxHp = 3,
	Attack = 3,
	EXP = 3,
	MoveType = MoveCircle.new(0, 1.5, 3),
	EnemyType = EnemyTypeEnum.BulletShooter,
	BulletEmitterList = {
		Emitter001.new(2, Vector2.new(0, 0), 0, EmitterTypeEnum.Normal),
	},
	EquipBulletList = {
		EnemyBullet_Middle1_10,
	},-- 今は、BulletEmitterListとEquipBulletListの数は同じにしておかないとダメ
}

EnemyTankMouse21_30 = {
	PrefabName = "Prefabs/EnemyCharacterTankMouse",
	Name = "EnemyCharacterTankMouse",
	Width = 32,
	Height = 32,
	NowHp = 50,
	MaxHp = 50,
	Attack = 3,
	EXP = 3,
	MoveType = MoveStraight.new(1),
	EnemyType = EnemyTypeEnum.Normal,
}
