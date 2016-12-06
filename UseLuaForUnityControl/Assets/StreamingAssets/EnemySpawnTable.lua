--直接Unityには登録しないスクリプト。いわゆる、ライブラリ化した奴

-- 敵出現テーブル。時間の経過で、どのSpawnDataが発生するのかチェックする
SpawnTable = {
	{
		Time      = 5,						--出現開始時間
		SpawnData = Spawn001_001_001,		--出現情報
	},
	{
		Time      = 5,						--出現開始時間
		SpawnData = Spawn001_001_002,		--出現情報
	},
	{
		Time      = 10,						--出現開始時間
		SpawnData = Spawn001_002_001,		--出現情報
	},
	{
		Time      = 15,						--出現開始時間
		SpawnData = Spawn001_003_001,		--出現情報
	},
	{
		Time      = 20,						--出現開始時間
		SpawnData = Spawn001_004_001,		--出現情報
	},
	{
		Time      = 25,						--出現開始時間
		SpawnData = Spawn001_005_001,		--出現情報
	},
}

