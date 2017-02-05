--直接Unityには登録しないスクリプト。いわゆる、ライブラリ化した奴

-- 敵出現情報
--ステージ番号_ウェーブ_連番号
--000_000_000
--検証
SpawnTest = {
	Position  = Vector2.new(400, 0),	--座標
	EnemyType = EnemyTestBullet,		--敵の種類
	Interval  = 1,						--間隔
	Value     = 1,						--出現総数
}

SpawnTest1 = {
	Position  = Vector2.new(400, 0),	--座標
	EnemyType = EnemyTestBullet1,		--敵の種類
	Interval  = 1,						--間隔
	Value     = 1,						--出現総数
}
SpawnTest2 = {
	Position  = Vector2.new(-400, 0),	--座標
	EnemyType = EnemyTestBullet2,		--敵の種類
	Interval  = 1,						--間隔
	Value     = 1,						--出現総数
}
SpawnTest3 = {
	Position  = Vector2.new(0, 400),	--座標
	EnemyType = EnemyTestBullet3,		--敵の種類
	Interval  = 1,						--間隔
	Value     = 1,						--出現総数
}
--!検証

--ステージ1
Spawn001_001_001 = {
	Position  = Vector2.new(0, 500),	--座標
	EnemyType = Enemy001_001,				--敵の種類
	Interval  = 1,						--間隔
	Value     = 5,						--出現総数
}

Spawn001_002_001 = {
	Position  = Vector2.new(0, -500),	--座標
	EnemyType = Enemy001_001,			--敵の種類
	Interval  = 1,						--間隔
	Value     = 5,						--出現総数
}

Spawn001_003_001 = {
	Position  = Vector2.new(-500, 0),	--座標
	EnemyType = Enemy001_002,			--敵の種類
	Interval  = 1,						--間隔
	Value     = 5,						--出現総数
}

Spawn001_004_001 = {
	Position  = Vector2.new(500, 0),	--座標
	EnemyType = Enemy001_002,			--敵の種類
	Interval  = 1,						--間隔
	Value     = 5,						--出現総数
}
--!ステージ1

--ステージ2
Spawn002_001_001 = {
	Position  = Vector2.new(500, 0),	--座標
	EnemyType = Enemy002_001,			--敵の種類
	Interval  = 0.5,					--間隔
	Value     = 10,						--出現総数
}

Spawn002_001_002 = {
	Position  = Vector2.new(500, 0),	--座標
	EnemyType = Enemy002_002,			--敵の種類
	Interval  = 0.5,					--間隔
	Value     = 10,						--出現総数
}

Spawn002_001_003 = {
	Position  = Vector2.new(-500, 0),	--座標
	EnemyType = Enemy002_001,			--敵の種類
	Interval  = 0.5,					--間隔
	Value     = 10,						--出現総数
}

Spawn002_001_004 = {
	Position  = Vector2.new(-500, 0),	--座標
	EnemyType = Enemy002_002,			--敵の種類
	Interval  = 0.5,					--間隔
	Value     = 10,						--出現総数
}

Spawn002_001_005 = {
	Position  = Vector2.new(0, 500),	--座標
	EnemyType = Enemy002_001,			--敵の種類
	Interval  = 0.5,					--間隔
	Value     = 10,						--出現総数
}

Spawn002_001_006 = {
	Position  = Vector2.new(0, 500),	--座標
	EnemyType = Enemy002_002,			--敵の種類
	Interval  = 0.5,					--間隔
	Value     = 10,						--出現総数
}

Spawn002_001_007 = {
	Position  = Vector2.new(0, -500),	--座標
	EnemyType = Enemy002_001,			--敵の種類
	Interval  = 0.5,					--間隔
	Value     = 10,						--出現総数
}

Spawn002_001_008 = {
	Position  = Vector2.new(0, -500),	--座標
	EnemyType = Enemy002_002,			--敵の種類
	Interval  = 0.5,					--間隔
	Value     = 10,						--出現総数
}
--!ステージ2

--ステージ3
Spawn003_001_001 = {
	Position  = Vector2.new(-500, 0),	--座標
	EnemyType = Enemy003_001,			--敵の種類
	Interval  = 1,						--間隔
	Value     = 5,						--出現総数
}

Spawn003_001_002 = {
	Position  = Vector2.new(500, 0),	--座標
	EnemyType = Enemy003_001,			--敵の種類
	Interval  = 1,						--間隔
	Value     = 5,						--出現総数
}

Spawn003_001_003 = {
	Position  = Vector2.new(0, 500),	--座標
	EnemyType = Enemy003_001,			--敵の種類
	Interval  = 1,						--間隔
	Value     = 5,						--出現総数
}

Spawn003_001_004 = {
	Position  = Vector2.new(0, -500),	--座標
	EnemyType = Enemy003_001,			--敵の種類
	Interval  = 1,						--間隔
	Value     = 5,						--出現総数
}

Spawn003_001_005 = {
	Position  = Vector2.new(500, 500),	--座標
	EnemyType = Enemy003_002,			--敵の種類
	Interval  = 1,						--間隔
	Value     = 5,						--出現総数
}

Spawn003_001_006 = {
	Position  = Vector2.new(-500, 500),	--座標
	EnemyType = Enemy003_002,			--敵の種類
	Interval  = 1,						--間隔
	Value     = 5,						--出現総数
}

Spawn003_001_007 = {
	Position  = Vector2.new(500, -500),	--座標
	EnemyType = Enemy003_003,			--敵の種類
	Interval  = 1,						--間隔
	Value     = 5,						--出現総数
}

Spawn003_001_008 = {
	Position  = Vector2.new(-500, -500),--座標
	EnemyType = Enemy003_003,			--敵の種類
	Interval  = 1,						--間隔
	Value     = 5,						--出現総数
}
--!ステージ3

--ステージ
SpawnWave001_001 = {
	Position  = Vector2.new(0, 1000),			--座標
	EnemyType = EnemyMiniMouseStraight1_10,		--敵の種類
	Interval  = 2,								--間隔
	Value     = 5,								--出現総数
}
SpawnWave001_002 = {
	Position  = Vector2.new(700, 700),			--座標
	EnemyType = EnemyMiniMouseStraight1_10,		--敵の種類
	Interval  = 2,								--間隔
	Value     = 5,								--出現総数
}
SpawnWave001_003 = {
	Position  = Vector2.new(-700, 700),			--座標
	EnemyType = EnemyMiniMouseStraight1_10,		--敵の種類
	Interval  = 2,								--間隔
	Value     = 5,								--出現総数
}

SpawnWave002_001 = {
	Position  = Vector2.new(0, 1000),			--座標
	EnemyType = EnemyMiniMouseStraight1_10,		--敵の種類
	Interval  = 2,								--間隔
	Value     = 5,								--出現総数
}
SpawnWave002_002 = {
	Position  = Vector2.new(700, 700),			--座標
	EnemyType = EnemyMiniMouseStraight1_10,		--敵の種類
	Interval  = 2,								--間隔
	Value     = 5,								--出現総数
}
SpawnWave002_003 = {
	Position  = Vector2.new(-700, 700),			--座標
	EnemyType = EnemyMiniMouseStraight1_10,		--敵の種類
	Interval  = 2,								--間隔
	Value     = 5,								--出現総数
}
SpawnWave002_004 = {
	Position  = Vector2.new(1000, 0),			--座標
	EnemyType = EnemyMiniMouseStraight1_10,		--敵の種類
	Interval  = 2,								--間隔
	Value     = 5,								--出現総数
}
SpawnWave002_005 = {
	Position  = Vector2.new(-1000, 0),			--座標
	EnemyType = EnemyMiniMouseStraight1_10,		--敵の種類
	Interval  = 2,								--間隔
	Value     = 5,								--出現総数
}

SpawnWave003_001 = {
	Position  = Vector2.new(0, 1000),			--座標
	EnemyType = EnemyMiddleMouse1_10,	--敵の種類
	Interval  = 2,								--間隔
	Value     = 1,								--出現総数
}
SpawnWave003_002 = {
	Position  = Vector2.new(0, -1000),			--座標
	EnemyType = EnemyMiddleMouse1_10,	--敵の種類
	Interval  = 2,								--間隔
	Value     = 1,								--出現総数
}

SpawnWave004_001 = {
	Position  = Vector2.new(0, 1000),			--座標
	EnemyType = EnemyMiniMouseStraight1_10,		--敵の種類
	Interval  = 2,								--間隔
	Value     = 5,								--出現総数
}
SpawnWave004_002 = {
	Position  = Vector2.new(700, 700),			--座標
	EnemyType = EnemyMiniMouseStraight1_10,		--敵の種類
	Interval  = 2,								--間隔
	Value     = 5,								--出現総数
}
SpawnWave004_003 = {
	Position  = Vector2.new(-700, 700),			--座標
	EnemyType = EnemyMiniMouseStraight1_10,		--敵の種類
	Interval  = 2,								--間隔
	Value     = 5,								--出現総数
}
SpawnWave004_004 = {
	Position  = Vector2.new(0, -1000),			--座標
	EnemyType = EnemyMiniMouseStraight1_10,		--敵の種類
	Interval  = 2,								--間隔
	Value     = 5,								--出現総数
}
SpawnWave004_005 = {
	Position  = Vector2.new(700, -700),			--座標
	EnemyType = EnemyMiniMouseStraight1_10,		--敵の種類
	Interval  = 2,								--間隔
	Value     = 5,								--出現総数
}
SpawnWave004_006 = {
	Position  = Vector2.new(-700, -700),			--座標
	EnemyType = EnemyMiniMouseStraight1_10,		--敵の種類
	Interval  = 2,								--間隔
	Value     = 5,								--出現総数
}

SpawnWave005_001 = {
	Position  = Vector2.new(0, 1000),			--座標
	EnemyType = EnemyMiniMouseStraight1_10,		--敵の種類
	Interval  = 2,								--間隔
	Value     = 5,								--出現総数
}
SpawnWave005_002 = {
	Position  = Vector2.new(700, 700),			--座標
	EnemyType = EnemyMiniMouseStraight1_10,		--敵の種類
	Interval  = 2,								--間隔
	Value     = 5,								--出現総数
}
SpawnWave005_003 = {
	Position  = Vector2.new(-700, 700),			--座標
	EnemyType = EnemyMiniMouseStraight1_10,		--敵の種類
	Interval  = 2,								--間隔
	Value     = 5,								--出現総数
}
SpawnWave005_004 = {
	Position  = Vector2.new(0, -1000),			--座標
	EnemyType = EnemyMiniMouseStraight1_10,		--敵の種類
	Interval  = 2,								--間隔
	Value     = 5,								--出現総数
}
SpawnWave005_005 = {
	Position  = Vector2.new(700, -700),			--座標
	EnemyType = EnemyMiniMouseStraight1_10,		--敵の種類
	Interval  = 2,								--間隔
	Value     = 5,								--出現総数
}
SpawnWave005_006 = {
	Position  = Vector2.new(-700, -700),			--座標
	EnemyType = EnemyMiniMouseStraight1_10,		--敵の種類
	Interval  = 2,								--間隔
	Value     = 5,								--出現総数
}

SpawnWave006_001 = {
	Position  = Vector2.new(-700, -700),			--座標
	EnemyType = EnemyMiniMouseSinCurve1_10,		--敵の種類
	Interval  = 2,								--間隔
	Value     = 5,								--出現総数
}
SpawnWave006_002 = {
	Position  = Vector2.new(700, -700),			--座標
	EnemyType = EnemyMiniMouseSinCurve1_10,		--敵の種類
	Interval  = 2,								--間隔
	Value     = 5,								--出現総数
}
SpawnWave006_003 = {
	Position  = Vector2.new(700, 700),			--座標
	EnemyType = EnemyMiniMouseSinCurve1_10,		--敵の種類
	Interval  = 2,								--間隔
	Value     = 5,								--出現総数
}
SpawnWave006_004 = {
	Position  = Vector2.new(-700, 700),			--座標
	EnemyType = EnemyMiniMouseSinCurve1_10,		--敵の種類
	Interval  = 2,								--間隔
	Value     = 5,								--出現総数
}

SpawnWave007_001 = {
	Position  = Vector2.new(0, 1000),			--座標
	EnemyType = EnemyMiniMouseStraight1_10,		--敵の種類
	Interval  = 1,								--間隔
	Value     = 5,								--出現総数
}
SpawnWave007_002 = {
	Position  = Vector2.new(700, 700),			--座標
	EnemyType = EnemyMiniMouseStraight1_10,		--敵の種類
	Interval  = 1,								--間隔
	Value     = 5,								--出現総数
}
SpawnWave007_003 = {
	Position  = Vector2.new(-700, 700),			--座標
	EnemyType = EnemyMiniMouseStraight1_10,		--敵の種類
	Interval  = 1,								--間隔
	Value     = 5,								--出現総数
}
SpawnWave007_004 = {
	Position  = Vector2.new(0, -1000),			--座標
	EnemyType = EnemyMiniMouseStraight1_10,		--敵の種類
	Interval  = 1,								--間隔
	Value     = 5,								--出現総数
}
SpawnWave007_005 = {
	Position  = Vector2.new(700, -700),			--座標
	EnemyType = EnemyMiniMouseStraight1_10,		--敵の種類
	Interval  = 1,								--間隔
	Value     = 5,								--出現総数
}
SpawnWave007_006 = {
	Position  = Vector2.new(-700, -700),			--座標
	EnemyType = EnemyMiniMouseStraight1_10,		--敵の種類
	Interval  = 1,								--間隔
	Value     = 5,								--出現総数
}

SpawnWave008_001 = {
	Position  = Vector2.new(-1000, 0),			--座標
	EnemyType = EnemyMiniMouseSinCurve1_10_1,	--敵の種類
	Interval  = 1,								--間隔
	Value     = 10,								--出現総数
}
SpawnWave008_002 = {
	Position  = Vector2.new(-1000, 0),			--座標
	EnemyType = EnemyMiniMouseSinCurve1_10_2,	--敵の種類
	Interval  = 1,								--間隔
	Value     = 10,								--出現総数
}
SpawnWave008_003 = {
	Position  = Vector2.new(1000, 0),			--座標
	EnemyType = EnemyMiniMouseSinCurve1_10_1,	--敵の種類
	Interval  = 1,								--間隔
	Value     = 10,								--出現総数
}
SpawnWave008_004 = {
	Position  = Vector2.new(1000, 0),			--座標
	EnemyType = EnemyMiniMouseSinCurve1_10_2,	--敵の種類
	Interval  = 1,								--間隔
	Value     = 10,								--出現総数
}
SpawnWave008_005 = {
	Position  = Vector2.new(0, 1000),			--座標
	EnemyType = EnemyMiniMouseSinCurve1_10_1,	--敵の種類
	Interval  = 1,								--間隔
	Value     = 10,								--出現総数
}
SpawnWave008_006 = {
	Position  = Vector2.new(0, 1000),			--座標
	EnemyType = EnemyMiniMouseSinCurve1_10_2,	--敵の種類
	Interval  = 1,								--間隔
	Value     = 10,								--出現総数
}
SpawnWave008_007 = {
	Position  = Vector2.new(0, -1000),			--座標
	EnemyType = EnemyMiniMouseSinCurve1_10_1,	--敵の種類
	Interval  = 1,								--間隔
	Value     = 10,								--出現総数
}
SpawnWave008_008 = {
	Position  = Vector2.new(0, -1000),			--座標
	EnemyType = EnemyMiniMouseSinCurve1_10_2,	--敵の種類
	Interval  = 1,								--間隔
	Value     = 10,								--出現総数
}

SpawnWave009_001 = {
	Position  = Vector2.new(0, -1000),			--座標
	EnemyType = EnemySpeedMouse1_10,	--敵の種類
	Interval  = 2,								--間隔
	Value     = 3,								--出現総数
}
SpawnWave009_002 = {
	Position  = Vector2.new(0, 1000),			--座標
	EnemyType = EnemySpeedMouse1_10,	--敵の種類
	Interval  = 2,								--間隔
	Value     = 3,								--出現総数
}
SpawnWave009_003 = {
	Position  = Vector2.new(1000, 0),			--座標
	EnemyType = EnemySpeedMouse1_10,	--敵の種類
	Interval  = 2,								--間隔
	Value     = 3,								--出現総数
}
SpawnWave009_004 = {
	Position  = Vector2.new(-1000, 0),			--座標
	EnemyType = EnemySpeedMouse1_10,	--敵の種類
	Interval  = 2,								--間隔
	Value     = 3,								--出現総数
}

SpawnWave010_001 = {
	Position  = Vector2.new(0, 1000),			--座標
	EnemyType = EnemySpeedMouse1_10,	--敵の種類
	Interval  = 2,								--間隔
	Value     = 10,								--出現総数
}
SpawnWave010_002 = {
	Position  = Vector2.new(1000, 0),			--座標
	EnemyType = EnemySpeedMouse1_10,	--敵の種類
	Interval  = 2,								--間隔
	Value     = 10,								--出現総数
}
SpawnWave010_003 = {
	Position  = Vector2.new(-1000, 0),			--座標
	EnemyType = EnemySpeedMouse1_10,	--敵の種類
	Interval  = 2,								--間隔
	Value     = 10,								--出現総数
}
SpawnWave010_004 = {
	Position  = Vector2.new(700, 700),			--座標
	EnemyType = EnemyMiddleMouse1_10,		--敵の種類
	Interval  = 1,								--間隔
	Value     = 1,								--出現総数
}
SpawnWave010_005 = {
	Position  = Vector2.new(-700, 700),			--座標
	EnemyType = EnemyMiddleMouse1_10,		--敵の種類
	Interval  = 1,								--間隔
	Value     = 1,								--出現総数
}

SpawnWave011_001 = {
	Position  = Vector2.new(0, 1000),			--座標
	EnemyType = EnemyMiniMouseStraight11_20,		--敵の種類
	Interval  = 2,								--間隔
	Value     = 5,								--出現総数
}
SpawnWave011_002 = {
	Position  = Vector2.new(700, 700),			--座標
	EnemyType = EnemyMiniMouseStraight11_20,		--敵の種類
	Interval  = 2,								--間隔
	Value     = 5,								--出現総数
}
SpawnWave011_003 = {
	Position  = Vector2.new(-700, 700),			--座標
	EnemyType = EnemyMiniMouseStraight11_20,		--敵の種類
	Interval  = 2,								--間隔
	Value     = 5,								--出現総数
}

SpawnWave012_001 = {
	Position  = Vector2.new(0, 1000),			--座標
	EnemyType = EnemyMiniMouseStraight11_20,		--敵の種類
	Interval  = 2,								--間隔
	Value     = 5,								--出現総数
}
SpawnWave012_002 = {
	Position  = Vector2.new(700, 700),			--座標
	EnemyType = EnemyMiniMouseStraight11_20,		--敵の種類
	Interval  = 2,								--間隔
	Value     = 5,								--出現総数
}
SpawnWave012_003 = {
	Position  = Vector2.new(-700, 700),			--座標
	EnemyType = EnemyMiniMouseStraight11_20,		--敵の種類
	Interval  = 2,								--間隔
	Value     = 5,								--出現総数
}
SpawnWave012_004 = {
	Position  = Vector2.new(1000, 0),			--座標
	EnemyType = EnemyMiniMouseStraight11_20,		--敵の種類
	Interval  = 2,								--間隔
	Value     = 5,								--出現総数
}
SpawnWave012_005 = {
	Position  = Vector2.new(-1000, 0),			--座標
	EnemyType = EnemyMiniMouseStraight11_20,		--敵の種類
	Interval  = 2,								--間隔
	Value     = 5,								--出現総数
}

SpawnWave013_001 = {
	Position  = Vector2.new(0, 1000),			--座標
	EnemyType = EnemyMiddleMouse11_20,	--敵の種類
	Interval  = 2,								--間隔
	Value     = 1,								--出現総数
}
SpawnWave013_002 = {
	Position  = Vector2.new(0, -1000),			--座標
	EnemyType = EnemyMiddleMouse11_20,	--敵の種類
	Interval  = 2,								--間隔
	Value     = 1,								--出現総数
}

SpawnWave014_001 = {
	Position  = Vector2.new(0, 1000),			--座標
	EnemyType = EnemyMiniMouseStraight11_20,		--敵の種類
	Interval  = 2,								--間隔
	Value     = 5,								--出現総数
}
SpawnWave014_002 = {
	Position  = Vector2.new(700, 700),			--座標
	EnemyType = EnemyMiniMouseStraight11_20,		--敵の種類
	Interval  = 2,								--間隔
	Value     = 5,								--出現総数
}
SpawnWave014_003 = {
	Position  = Vector2.new(-700, 700),			--座標
	EnemyType = EnemyMiniMouseStraight11_20,		--敵の種類
	Interval  = 2,								--間隔
	Value     = 5,								--出現総数
}
SpawnWave014_004 = {
	Position  = Vector2.new(0, -1000),			--座標
	EnemyType = EnemyMiniMouseStraight11_20,		--敵の種類
	Interval  = 2,								--間隔
	Value     = 5,								--出現総数
}
SpawnWave014_005 = {
	Position  = Vector2.new(700, -700),			--座標
	EnemyType = EnemyMiniMouseStraight11_20,		--敵の種類
	Interval  = 2,								--間隔
	Value     = 5,								--出現総数
}
SpawnWave014_006 = {
	Position  = Vector2.new(-700, -700),			--座標
	EnemyType = EnemyMiniMouseStraight11_20,		--敵の種類
	Interval  = 2,								--間隔
	Value     = 5,								--出現総数
}

SpawnWave015_001 = {
	Position  = Vector2.new(0, 1000),			--座標
	EnemyType = EnemyMiniMouseStraight11_20,		--敵の種類
	Interval  = 2,								--間隔
	Value     = 5,								--出現総数
}
SpawnWave015_002 = {
	Position  = Vector2.new(700, 700),			--座標
	EnemyType = EnemyMiniMouseStraight11_20,		--敵の種類
	Interval  = 2,								--間隔
	Value     = 5,								--出現総数
}
SpawnWave015_003 = {
	Position  = Vector2.new(-700, 700),			--座標
	EnemyType = EnemyMiniMouseStraight11_20,		--敵の種類
	Interval  = 2,								--間隔
	Value     = 5,								--出現総数
}
SpawnWave015_004 = {
	Position  = Vector2.new(0, -1000),			--座標
	EnemyType = EnemyMiniMouseStraight11_20,		--敵の種類
	Interval  = 2,								--間隔
	Value     = 5,								--出現総数
}
SpawnWave015_005 = {
	Position  = Vector2.new(700, -700),			--座標
	EnemyType = EnemyMiniMouseStraight11_20,		--敵の種類
	Interval  = 2,								--間隔
	Value     = 5,								--出現総数
}
SpawnWave015_006 = {
	Position  = Vector2.new(-700, -700),			--座標
	EnemyType = EnemyMiniMouseStraight11_20,		--敵の種類
	Interval  = 2,								--間隔
	Value     = 5,								--出現総数
}

SpawnWave016_001 = {
	Position  = Vector2.new(-700, -700),			--座標
	EnemyType = EnemyMiniMouseSinCurve11_20_1,		--敵の種類
	Interval  = 2,								--間隔
	Value     = 5,								--出現総数
}
SpawnWave016_002 = {
	Position  = Vector2.new(700, -700),			--座標
	EnemyType = EnemyMiniMouseSinCurve11_20_1,		--敵の種類
	Interval  = 2,								--間隔
	Value     = 5,								--出現総数
}
SpawnWave016_003 = {
	Position  = Vector2.new(700, 700),			--座標
	EnemyType = EnemyMiniMouseSinCurve11_20_1,		--敵の種類
	Interval  = 2,								--間隔
	Value     = 5,								--出現総数
}
SpawnWave016_004 = {
	Position  = Vector2.new(-700, 700),			--座標
	EnemyType = EnemyMiniMouseSinCurve11_20_1,		--敵の種類
	Interval  = 2,								--間隔
	Value     = 5,								--出現総数
}

SpawnWave017_001 = {
	Position  = Vector2.new(0, 1000),			--座標
	EnemyType = EnemyMiniMouseStraight11_20,		--敵の種類
	Interval  = 1,								--間隔
	Value     = 5,								--出現総数
}
SpawnWave017_002 = {
	Position  = Vector2.new(700, 700),			--座標
	EnemyType = EnemyMiniMouseStraight11_20,		--敵の種類
	Interval  = 1,								--間隔
	Value     = 5,								--出現総数
}
SpawnWave017_003 = {
	Position  = Vector2.new(-700, 700),			--座標
	EnemyType = EnemyMiniMouseStraight11_20,		--敵の種類
	Interval  = 1,								--間隔
	Value     = 5,								--出現総数
}
SpawnWave017_004 = {
	Position  = Vector2.new(0, -1000),			--座標
	EnemyType = EnemyMiniMouseStraight11_20,		--敵の種類
	Interval  = 1,								--間隔
	Value     = 5,								--出現総数
}
SpawnWave017_005 = {
	Position  = Vector2.new(700, -700),			--座標
	EnemyType = EnemyMiniMouseStraight11_20,		--敵の種類
	Interval  = 1,								--間隔
	Value     = 5,								--出現総数
}
SpawnWave017_006 = {
	Position  = Vector2.new(-700, -700),			--座標
	EnemyType = EnemyMiniMouseStraight11_20,		--敵の種類
	Interval  = 1,								--間隔
	Value     = 5,								--出現総数
}

SpawnWave018_001 = {
	Position  = Vector2.new(-1000, 0),			--座標
	EnemyType = EnemyMiniMouseSinCurve11_20_1,	--敵の種類
	Interval  = 1,								--間隔
	Value     = 10,								--出現総数
}
SpawnWave018_002 = {
	Position  = Vector2.new(-1000, 0),			--座標
	EnemyType = EnemyMiniMouseSinCurve11_20_2,	--敵の種類
	Interval  = 1,								--間隔
	Value     = 10,								--出現総数
}
SpawnWave018_003 = {
	Position  = Vector2.new(1000, 0),			--座標
	EnemyType = EnemyMiniMouseSinCurve11_20_1,	--敵の種類
	Interval  = 1,								--間隔
	Value     = 10,								--出現総数
}
SpawnWave018_004 = {
	Position  = Vector2.new(1000, 0),			--座標
	EnemyType = EnemyMiniMouseSinCurve11_20_2,	--敵の種類
	Interval  = 1,								--間隔
	Value     = 10,								--出現総数
}
SpawnWave018_005 = {
	Position  = Vector2.new(0, 1000),			--座標
	EnemyType = EnemyMiniMouseSinCurve11_20_1,	--敵の種類
	Interval  = 1,								--間隔
	Value     = 10,								--出現総数
}
SpawnWave018_006 = {
	Position  = Vector2.new(0, 1000),			--座標
	EnemyType = EnemyMiniMouseSinCurve11_20_2,	--敵の種類
	Interval  = 1,								--間隔
	Value     = 10,								--出現総数
}
SpawnWave018_007 = {
	Position  = Vector2.new(0, -1000),			--座標
	EnemyType = EnemyMiniMouseSinCurve11_20_1,	--敵の種類
	Interval  = 1,								--間隔
	Value     = 10,								--出現総数
}
SpawnWave018_008 = {
	Position  = Vector2.new(0, -1000),			--座標
	EnemyType = EnemyMiniMouseSinCurve11_20_2,	--敵の種類
	Interval  = 1,								--間隔
	Value     = 10,								--出現総数
}

SpawnWave019_001 = {
	Position  = Vector2.new(0, -1000),			--座標
	EnemyType = EnemySpeedMouse11_20,	--敵の種類
	Interval  = 2,								--間隔
	Value     = 3,								--出現総数
}
SpawnWave019_002 = {
	Position  = Vector2.new(0, 1000),			--座標
	EnemyType = EnemySpeedMouse11_20,	--敵の種類
	Interval  = 2,								--間隔
	Value     = 3,								--出現総数
}
SpawnWave019_003 = {
	Position  = Vector2.new(1000, 0),			--座標
	EnemyType = EnemySpeedMouse11_20,	--敵の種類
	Interval  = 2,								--間隔
	Value     = 3,								--出現総数
}
SpawnWave019_004 = {
	Position  = Vector2.new(-1000, 0),			--座標
	EnemyType = EnemySpeedMouse11_20,	--敵の種類
	Interval  = 2,								--間隔
	Value     = 3,								--出現総数
}

SpawnWave020_001 = {
	Position  = Vector2.new(0, 1000),			--座標
	EnemyType = EnemyTankMouse11_20,	--敵の種類
	Interval  = 2,								--間隔
	Value     = 1,								--出現総数
}
SpawnWave020_002 = {
	Position  = Vector2.new(0, 1000),			--座標
	EnemyType = EnemyMiddleMouse11_20,	--敵の種類
	Interval  = 1,								--間隔
	Value     = 3,								--出現総数
}
SpawnWave020_003 = {
	Position  = Vector2.new(700, 700),			--座標
	EnemyType = EnemyTankMouse11_20,	--敵の種類
	Interval  = 2,								--間隔
	Value     = 1,								--出現総数
}
SpawnWave020_004 = {
	Position  = Vector2.new(700, 700),			--座標
	EnemyType = EnemyMiddleMouse11_20,	--敵の種類
	Interval  = 1,								--間隔
	Value     = 3,								--出現総数
}
SpawnWave020_005 = {
	Position  = Vector2.new(-700, 700),			--座標
	EnemyType = EnemyTankMouse11_20,	--敵の種類
	Interval  = 2,								--間隔
	Value     = 1,								--出現総数
}
SpawnWave020_006 = {
	Position  = Vector2.new(-700, 700),			--座標
	EnemyType = EnemyMiddleMouse11_20,	--敵の種類
	Interval  = 1,								--間隔
	Value     = 3,								--出現総数
}

SpawnWave021_001 = {
	Position  = Vector2.new(0, 1000),			--座標
	EnemyType = EnemyMiniMouseStraight21_30,		--敵の種類
	Interval  = 2,								--間隔
	Value     = 5,								--出現総数
}
SpawnWave021_002 = {
	Position  = Vector2.new(700, 700),			--座標
	EnemyType = EnemyMiniMouseStraight21_30,		--敵の種類
	Interval  = 2,								--間隔
	Value     = 5,								--出現総数
}
SpawnWave021_003 = {
	Position  = Vector2.new(-700, 700),			--座標
	EnemyType = EnemyMiniMouseStraight21_30,		--敵の種類
	Interval  = 2,								--間隔
	Value     = 5,								--出現総数
}

SpawnWave022_001 = {
	Position  = Vector2.new(0, 1000),			--座標
	EnemyType = EnemyMiniMouseStraight21_30,		--敵の種類
	Interval  = 2,								--間隔
	Value     = 5,								--出現総数
}
SpawnWave022_002 = {
	Position  = Vector2.new(700, 700),			--座標
	EnemyType = EnemyMiniMouseStraight21_30,		--敵の種類
	Interval  = 2,								--間隔
	Value     = 5,								--出現総数
}
SpawnWave022_003 = {
	Position  = Vector2.new(-700, 700),			--座標
	EnemyType = EnemyMiniMouseStraight21_30,		--敵の種類
	Interval  = 2,								--間隔
	Value     = 5,								--出現総数
}
SpawnWave022_004 = {
	Position  = Vector2.new(1000, 0),			--座標
	EnemyType = EnemyMiniMouseStraight21_30,		--敵の種類
	Interval  = 2,								--間隔
	Value     = 5,								--出現総数
}
SpawnWave022_005 = {
	Position  = Vector2.new(-1000, 0),			--座標
	EnemyType = EnemyMiniMouseStraight21_30,		--敵の種類
	Interval  = 2,								--間隔
	Value     = 5,								--出現総数
}

SpawnWave023_001 = {
	Position  = Vector2.new(350, 350),			--座標
	EnemyType = EnemyCircleMouse21_30,	--敵の種類
	Interval  = 1,								--間隔
	Value     = 8,								--出現総数
}
SpawnWave023_002 = {
	Position  = Vector2.new(-350, 350),			--座標
	EnemyType = EnemyCircleMouse21_30,	--敵の種類
	Interval  = 1,								--間隔
	Value     = 8,								--出現総数
}

SpawnWave024_001 = {
	Position  = Vector2.new(0, 1000),			--座標
	EnemyType = EnemyMiniMouseStraight21_30,		--敵の種類
	Interval  = 2,								--間隔
	Value     = 5,								--出現総数
}
SpawnWave024_002 = {
	Position  = Vector2.new(700, 700),			--座標
	EnemyType = EnemyMiniMouseStraight21_30,		--敵の種類
	Interval  = 2,								--間隔
	Value     = 5,								--出現総数
}
SpawnWave024_003 = {
	Position  = Vector2.new(-700, 700),			--座標
	EnemyType = EnemyMiniMouseStraight21_30,		--敵の種類
	Interval  = 2,								--間隔
	Value     = 5,								--出現総数
}
SpawnWave024_004 = {
	Position  = Vector2.new(0, -1000),			--座標
	EnemyType = EnemyMiniMouseStraight21_30,		--敵の種類
	Interval  = 2,								--間隔
	Value     = 5,								--出現総数
}
SpawnWave024_005 = {
	Position  = Vector2.new(700, -700),			--座標
	EnemyType = EnemyMiniMouseStraight21_30,		--敵の種類
	Interval  = 2,								--間隔
	Value     = 5,								--出現総数
}
SpawnWave024_006 = {
	Position  = Vector2.new(-700, -700),			--座標
	EnemyType = EnemyMiniMouseStraight21_30,		--敵の種類
	Interval  = 2,								--間隔
	Value     = 5,								--出現総数
}

SpawnWave025_001 = {
	Position  = Vector2.new(0, 1000),			--座標
	EnemyType = EnemyMiniMouseStraight21_30,		--敵の種類
	Interval  = 2,								--間隔
	Value     = 5,								--出現総数
}
SpawnWave025_002 = {
	Position  = Vector2.new(700, 700),			--座標
	EnemyType = EnemyMiniMouseStraight21_30,		--敵の種類
	Interval  = 2,								--間隔
	Value     = 5,								--出現総数
}
SpawnWave025_003 = {
	Position  = Vector2.new(-700, 700),			--座標
	EnemyType = EnemyMiniMouseStraight21_30,		--敵の種類
	Interval  = 2,								--間隔
	Value     = 5,								--出現総数
}
SpawnWave025_004 = {
	Position  = Vector2.new(0, -1000),			--座標
	EnemyType = EnemyMiniMouseStraight21_30,		--敵の種類
	Interval  = 2,								--間隔
	Value     = 5,								--出現総数
}
SpawnWave025_005 = {
	Position  = Vector2.new(700, -700),			--座標
	EnemyType = EnemyMiniMouseStraight21_30,		--敵の種類
	Interval  = 2,								--間隔
	Value     = 5,								--出現総数
}
SpawnWave025_006 = {
	Position  = Vector2.new(-700, -700),			--座標
	EnemyType = EnemyMiniMouseStraight21_30,		--敵の種類
	Interval  = 2,								--間隔
	Value     = 5,								--出現総数
}

SpawnWave026_001 = {
	Position  = Vector2.new(350, 350),			--座標
	EnemyType = EnemyCircleMouse21_30,	--敵の種類
	Interval  = 1,								--間隔
	Value     = 8,								--出現総数
}
SpawnWave026_002 = {
	Position  = Vector2.new(-350, 350),			--座標
	EnemyType = EnemyCircleMouse21_30,	--敵の種類
	Interval  = 1,								--間隔
	Value     = 8,								--出現総数
}

SpawnWave027_001 = {
	Position  = Vector2.new(0, 1000),			--座標
	EnemyType = EnemyMiniMouseStraight21_30,		--敵の種類
	Interval  = 1,								--間隔
	Value     = 5,								--出現総数
}
SpawnWave027_002 = {
	Position  = Vector2.new(700, 700),			--座標
	EnemyType = EnemyMiniMouseStraight21_30,		--敵の種類
	Interval  = 1,								--間隔
	Value     = 5,								--出現総数
}
SpawnWave027_003 = {
	Position  = Vector2.new(-700, 700),			--座標
	EnemyType = EnemyMiniMouseStraight21_30,		--敵の種類
	Interval  = 1,								--間隔
	Value     = 5,								--出現総数
}
SpawnWave027_004 = {
	Position  = Vector2.new(0, -1000),			--座標
	EnemyType = EnemyMiniMouseStraight21_30,		--敵の種類
	Interval  = 1,								--間隔
	Value     = 5,								--出現総数
}
SpawnWave027_005 = {
	Position  = Vector2.new(700, -700),			--座標
	EnemyType = EnemyMiniMouseStraight21_30,		--敵の種類
	Interval  = 1,								--間隔
	Value     = 5,								--出現総数
}
SpawnWave027_006 = {
	Position  = Vector2.new(-700, -700),			--座標
	EnemyType = EnemyMiniMouseStraight21_30,		--敵の種類
	Interval  = 1,								--間隔
	Value     = 5,								--出現総数
}

SpawnWave028_001 = {
	Position  = Vector2.new(-1000, 0),			--座標
	EnemyType = EnemyMiniMouseSinCurve21_30_1,	--敵の種類
	Interval  = 1,								--間隔
	Value     = 10,								--出現総数
}
SpawnWave028_002 = {
	Position  = Vector2.new(-1000, 0),			--座標
	EnemyType = EnemyMiniMouseSinCurve21_30_2,	--敵の種類
	Interval  = 1,								--間隔
	Value     = 10,								--出現総数
}
SpawnWave028_003 = {
	Position  = Vector2.new(1000, 0),			--座標
	EnemyType = EnemyMiniMouseSinCurve21_30_1,	--敵の種類
	Interval  = 1,								--間隔
	Value     = 10,								--出現総数
}
SpawnWave028_004 = {
	Position  = Vector2.new(1000, 0),			--座標
	EnemyType = EnemyMiniMouseSinCurve21_30_2,	--敵の種類
	Interval  = 1,								--間隔
	Value     = 10,								--出現総数
}
SpawnWave028_005 = {
	Position  = Vector2.new(0, 1000),			--座標
	EnemyType = EnemyMiniMouseSinCurve21_30_1,	--敵の種類
	Interval  = 1,								--間隔
	Value     = 10,								--出現総数
}
SpawnWave028_006 = {
	Position  = Vector2.new(0, 1000),			--座標
	EnemyType = EnemyMiniMouseSinCurve21_30_2,	--敵の種類
	Interval  = 1,								--間隔
	Value     = 10,								--出現総数
}
SpawnWave028_007 = {
	Position  = Vector2.new(0, -1000),			--座標
	EnemyType = EnemyMiniMouseSinCurve21_30_1,	--敵の種類
	Interval  = 1,								--間隔
	Value     = 10,								--出現総数
}
SpawnWave028_008 = {
	Position  = Vector2.new(0, -1000),			--座標
	EnemyType = EnemyMiniMouseSinCurve21_30_2,	--敵の種類
	Interval  = 1,								--間隔
	Value     = 10,								--出現総数
}

SpawnWave029_001 = {
	Position  = Vector2.new(1000, 0),			--座標
	EnemyType = EnemyMiddleMouse21_30,	--敵の種類
	Interval  = 2,								--間隔
	Value     = 1,								--出現総数
}
SpawnWave029_002 = {
	Position  = Vector2.new(0, 1000),			--座標
	EnemyType = EnemyMiddleMouse21_30,	--敵の種類
	Interval  = 2,								--間隔
	Value     = 1,								--出現総数
}
SpawnWave029_003 = {
	Position  = Vector2.new(-1000, 0),			--座標
	EnemyType = EnemyMiddleMouse21_30,	--敵の種類
	Interval  = 2,								--間隔
	Value     = 1,								--出現総数
}
SpawnWave029_004 = {
	Position  = Vector2.new(700, 700),			--座標
	EnemyType = EnemyMiddleMouse21_30,	--敵の種類
	Interval  = 2,								--間隔
	Value     = 1,								--出現総数
}
SpawnWave029_005 = {
	Position  = Vector2.new(-700, 700),			--座標
	EnemyType = EnemyMiddleMouse21_30,	--敵の種類
	Interval  = 2,								--間隔
	Value     = 1,								--出現総数
}

SpawnWave030_001 = {
	Position  = Vector2.new(1000, 0),			--座標
	EnemyType = EnemySpeedMouse21_30,	--敵の種類
	Interval  = 3,								--間隔
	Value     = 10,								--出現総数
}
SpawnWave030_002 = {
	Position  = Vector2.new(700, 700),			--座標
	EnemyType = EnemySpeedMouse21_30,	--敵の種類
	Interval  = 3,								--間隔
	Value     = 10,								--出現総数
}
SpawnWave030_003 = {
	Position  = Vector2.new(0, 1000),			--座標
	EnemyType = EnemySpeedMouse21_30,	--敵の種類
	Interval  = 3,								--間隔
	Value     = 10,								--出現総数
}
SpawnWave030_004 = {
	Position  = Vector2.new(-700, 700),			--座標
	EnemyType = EnemySpeedMouse21_30,	--敵の種類
	Interval  = 3,								--間隔
	Value     = 10,								--出現総数
}
SpawnWave030_005 = {
	Position  = Vector2.new(-1000, 0),			--座標
	EnemyType = EnemySpeedMouse21_30,	--敵の種類
	Interval  = 3,								--間隔
	Value     = 10,								--出現総数
}
SpawnWave030_006 = {
	Position  = Vector2.new(-850, 200),			--座標
	EnemyType = EnemyMiniMouseStraight21_30,	--敵の種類
	Interval  = 2,								--間隔
	Value     = 15,								--出現総数
}
SpawnWave030_007 = {
	Position  = Vector2.new(-200, 850),			--座標
	EnemyType = EnemyMiniMouseStraight21_30,	--敵の種類
	Interval  = 2,								--間隔
	Value     = 15,								--出現総数
}
SpawnWave030_008 = {
	Position  = Vector2.new(200, 850),			--座標
	EnemyType = EnemyMiniMouseStraight21_30,	--敵の種類
	Interval  = 2,								--間隔
	Value     = 15,								--出現総数
}
SpawnWave030_009 = {
	Position  = Vector2.new(850, 200),			--座標
	EnemyType = EnemyMiniMouseStraight21_30,	--敵の種類
	Interval  = 2,								--間隔
	Value     = 15,								--出現総数
}
--!ステージ
