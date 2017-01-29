--直接Unityには登録しないスクリプト。いわゆる、ライブラリ化した奴

-- 敵出現テーブル。時間の経過で、どのSpawnDataが発生するのかチェックする
SpawnTableTest = {
	Table = {
		{
			Time      = 3,						--出現開始時間
			SpawnData = SpawnTest1,				--出現情報
		},
		{
			Time      = 3,						--出現開始時間
			SpawnData = SpawnTest2,				--出現情報
		},
		{
			Time      = 3,						--出現開始時間
			SpawnData = SpawnTest3,				--出現情報
		},
	},
	EndTime = 999,	-- この秒数が経過してら、バトル終了チェックを周期的に開始する
}

SpawnTable_001 = {
	Table = {
		{
			Time      = 5,						--出現開始時間
			SpawnData = Spawn001_001_001,		--出現情報
		},
		{
			Time      = 10,						--出現開始時間
			SpawnData = Spawn001_002_001,		--出現情報
		},
		{
			Time      = 15,						--出現開始時間
			SpawnData = Spawn001_001_001,		--出現情報
		},
		{
			Time      = 20,						--出現開始時間
			SpawnData = Spawn001_002_001,		--出現情報
		},
		{
			Time      = 25,						--出現開始時間
			SpawnData = Spawn001_001_001,		--出現情報
		},
		{
			Time      = 25,						--出現開始時間
			SpawnData = Spawn001_002_001,		--出現情報
		},
		{
			Time      = 25,						--出現開始時間
			SpawnData = Spawn001_003_001,		--出現情報
		},
		{
			Time      = 26,						--出現開始時間
			SpawnData = Spawn001_004_001,		--出現情報
		},
	},
	EndTime = 30,	-- この秒数が経過してら、バトル終了チェックを周期的に開始する
}

SpawnTable_002 = {
	Table = {
		{
			Time      = 5,						--出現開始時間
			SpawnData = Spawn002_001_001,		--出現情報
		},
		{
			Time      = 5,						--出現開始時間
			SpawnData = Spawn002_001_002,		--出現情報
		},
		{
			Time      = 8,						--出現開始時間
			SpawnData = Spawn002_001_003,		--出現情報
		},
		{
			Time      = 8,						--出現開始時間
			SpawnData = Spawn002_001_004,		--出現情報
		},
		{
			Time      = 11,						--出現開始時間
			SpawnData = Spawn002_001_005,		--出現情報
		},
		{
			Time      = 11,						--出現開始時間
			SpawnData = Spawn002_001_006,		--出現情報
		},
		{
			Time      = 14,						--出現開始時間
			SpawnData = Spawn002_001_007,		--出現情報
		},
		{
			Time      = 14,						--出現開始時間
			SpawnData = Spawn002_001_008,		--出現情報
		},
	},
	EndTime = 20,	-- この秒数が経過してら、バトル終了チェックを周期的に開始する
}

SpawnTable_003 = {
	Table = {
		{
			Time      = 5,						--出現開始時間
			SpawnData = Spawn003_001_001,		--出現情報
		},
		{
			Time      = 5,						--出現開始時間
			SpawnData = Spawn003_001_002,		--出現情報
		},
		{
			Time      = 5,						--出現開始時間
			SpawnData = Spawn003_001_003,		--出現情報
		},
		{
			Time      = 5,						--出現開始時間
			SpawnData = Spawn003_001_004,		--出現情報
		},
		{
			Time      = 8,						--出現開始時間
			SpawnData = Spawn003_001_005,		--出現情報
		},
		{
			Time      = 8,						--出現開始時間
			SpawnData = Spawn003_001_006,		--出現情報
		},
		{
			Time      = 8,						--出現開始時間
			SpawnData = Spawn003_001_007,		--出現情報
		},
		{
			Time      = 8,						--出現開始時間
			SpawnData = Spawn003_001_008,		--出現情報
		},
	},
	EndTime = 15,	-- この秒数が経過してら、バトル終了チェックを周期的に開始する
}

