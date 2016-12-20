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
