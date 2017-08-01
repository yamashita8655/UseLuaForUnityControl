--直接Unityには登録しないスクリプト。いわゆる、ライブラリ化した奴
--・コントローラに、出現データを渡す
--・Updateで、SpawnInterval分カウンターが進んだら、
--　リストの総数でRandamをして、出た配列番目のデータの内容で、敵を生成する。
--・ただ、敵は一体ではなくインターバルごとにカウンター分でるので、それは別のクラスに請け負わせる
--・


-- 敵出現テーブル。時間の経過で、どのSpawnDataが発生するのかチェックする
NewSpawnTable = {
--	SpawnInterval = 15,		-- 1ウェーブ15秒クリア目安
	SelectSpawnDataList = {	-- このまとまりから、ランダムで敵が発生する
		-- 上斜め3ウェイ
		{
			SpawnWave001_001,
			SpawnWave001_002,
			SpawnWave001_003,
		},
		-- 上斜め左右5ウェイ
		{
			SpawnWave002_001,
			SpawnWave002_002,
			SpawnWave002_003,
			SpawnWave002_004,
			SpawnWave002_005,
		},
		-- 上下中サイズ弾打ち
		{
			SpawnWave003_001,
			SpawnWave003_002,
		},
		-- 上下斜め6方向通常敵
		{
			SpawnWave004_001,
			SpawnWave004_002,
			SpawnWave004_003,
			SpawnWave004_004,
			SpawnWave004_005,
			SpawnWave004_006,
		},
		-- 斜め4方向、1蛇行
		{
			SpawnWave006_001,
			SpawnWave006_002,
			SpawnWave006_003,
			SpawnWave006_004,
		},
		-- 上下左右2蛇行
		{
			SpawnWave008_001,
			SpawnWave008_002,
			SpawnWave008_003,
			SpawnWave008_004,
			SpawnWave008_005,
			SpawnWave008_006,
			SpawnWave008_007,
			SpawnWave008_010,
		},
		-- 上下左右高速
		{
			SpawnWave009_001,
			SpawnWave009_002,
			SpawnWave009_003,
			SpawnWave009_004,
		},
		-- 上左右高速、斜め弾打ち1体ずつ
		{
			SpawnWave010_001,
			SpawnWave010_002,
			SpawnWave010_003,
			SpawnWave010_004,
			SpawnWave010_005,
		},
		-- 上斜め、弾固弾のボスっぽい出現
		{
			SpawnWave020_001,
			SpawnWave020_002,
			SpawnWave020_003,
			SpawnWave020_004,
			SpawnWave020_005,
			SpawnWave020_006,
		},
		-- 斜め回転弾打ち
		{
			SpawnWave023_001,
			SpawnWave023_002,
		},
		-- 上左右斜め5体、中型弾打ち
		{
			SpawnWave029_001,
			SpawnWave029_002,
			SpawnWave029_003,
			SpawnWave029_004,
			SpawnWave029_005,
		},
		-- 斜め4箇所雑魚、上左右斜め5箇所高速
		{
			SpawnWave030_001,
			SpawnWave030_002,
			SpawnWave030_003,
			SpawnWave030_004,
			SpawnWave030_005,
			SpawnWave030_006,
			SpawnWave030_007,
			SpawnWave030_008,
			SpawnWave030_009,
		},
	},
	
	EndTime = 300,	-- この秒数が経過してら、バトル終了チェックを周期的に開始する
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
	}
}
SpawnTableTest = {
	Table = {
		{
			Time      = 0,						--出現開始時間
			SpawnData = SpawnWave001_001,		--出現情報
		},
		{
			Time      = 0,						--出現開始時間
			SpawnData = SpawnWave001_002,		--出現情報
		},
		{
			Time      = 0,						--出現開始時間
			SpawnData = SpawnWave001_003,		--出現情報
		},
		
		{
			Time      = 10,						--出現開始時間
			SpawnData = SpawnWave002_001,		--出現情報
		},
		{
			Time      = 10,						--出現開始時間
			SpawnData = SpawnWave002_002,		--出現情報
		},
		{
			Time      = 10,						--出現開始時間
			SpawnData = SpawnWave002_003,		--出現情報
		},
		{
			Time      = 10,						--出現開始時間
			SpawnData = SpawnWave002_004,		--出現情報
		},
		{
			Time      = 10,						--出現開始時間
			SpawnData = SpawnWave002_005,		--出現情報
		},
		
		{
			Time      = 20,						--出現開始時間
			SpawnData = SpawnWave003_001,		--出現情報
		},
		{
			Time      = 20,						--出現開始時間
			SpawnData = SpawnWave003_002,		--出現情報
		},
		
		{
			Time      = 30,						--出現開始時間
			SpawnData = SpawnWave004_001,		--出現情報
		},
		{
			Time      = 31,						--出現開始時間
			SpawnData = SpawnWave004_002,		--出現情報
		},
		{
			Time      = 32,						--出現開始時間
			SpawnData = SpawnWave004_003,		--出現情報
		},
		{
			Time      = 33,						--出現開始時間
			SpawnData = SpawnWave004_004,		--出現情報
		},
		{
			Time      = 34,						--出現開始時間
			SpawnData = SpawnWave004_005,		--出現情報
		},
		{
			Time      = 35,						--出現開始時間
			SpawnData = SpawnWave004_006,		--出現情報
		},
		
		{
			Time      = 40,						--出現開始時間
			SpawnData = SpawnWave005_001,		--出現情報
		},
		{
			Time      = 41,						--出現開始時間
			SpawnData = SpawnWave005_002,		--出現情報
		},
		{
			Time      = 42,						--出現開始時間
			SpawnData = SpawnWave005_003,		--出現情報
		},
		{
			Time      = 43,						--出現開始時間
			SpawnData = SpawnWave005_004,		--出現情報
		},
		{
			Time      = 44,						--出現開始時間
			SpawnData = SpawnWave005_005,		--出現情報
		},
		{
			Time      = 45,						--出現開始時間
			SpawnData = SpawnWave005_006,		--出現情報
		},
		
		{
			Time      = 50,						--出現開始時間
			SpawnData = SpawnWave006_001,		--出現情報
		},
		{
			Time      = 50,						--出現開始時間
			SpawnData = SpawnWave006_002,		--出現情報
		},
		{
			Time      = 50,						--出現開始時間
			SpawnData = SpawnWave006_003,		--出現情報
		},
		{
			Time      = 50,						--出現開始時間
			SpawnData = SpawnWave006_004,		--出現情報
		},
		
		{
			Time      = 60,						--出現開始時間
			SpawnData = SpawnWave007_001,		--出現情報
		},
		{
			Time      = 62,						--出現開始時間
			SpawnData = SpawnWave007_002,		--出現情報
		},
		{
			Time      = 64,						--出現開始時間
			SpawnData = SpawnWave007_003,		--出現情報
		},
		{
			Time      = 66,						--出現開始時間
			SpawnData = SpawnWave007_004,		--出現情報
		},
		{
			Time      = 68,						--出現開始時間
			SpawnData = SpawnWave007_005,		--出現情報
		},
		{
			Time      = 70,						--出現開始時間
			SpawnData = SpawnWave007_006,		--出現情報
		},
		{
			Time      = 72,						--出現開始時間
			SpawnData = SpawnWave007_001,		--出現情報
		},
		{
			Time      = 72,						--出現開始時間
			SpawnData = SpawnWave007_002,		--出現情報
		},
		{
			Time      = 72,						--出現開始時間
			SpawnData = SpawnWave007_003,		--出現情報
		},
		{
			Time      = 72,						--出現開始時間
			SpawnData = SpawnWave007_004,		--出現情報
		},
		{
			Time      = 72,						--出現開始時間
			SpawnData = SpawnWave007_005,		--出現情報
		},
		{
			Time      = 72,						--出現開始時間
			SpawnData = SpawnWave007_006,		--出現情報
		},
		
		{
			Time      = 70,						--出現開始時間
			SpawnData = SpawnWave008_001,		--出現情報
		},
		{
			Time      = 70,						--出現開始時間
			SpawnData = SpawnWave008_002,		--出現情報
		},
		{
			Time      = 70,						--出現開始時間
			SpawnData = SpawnWave008_003,		--出現情報
		},
		{
			Time      = 70,						--出現開始時間
			SpawnData = SpawnWave008_004,		--出現情報
		},
		{
			Time      = 70,						--出現開始時間
			SpawnData = SpawnWave008_005,		--出現情報
		},
		{
			Time      = 70,						--出現開始時間
			SpawnData = SpawnWave008_006,		--出現情報
		},
		{
			Time      = 70,						--出現開始時間
			SpawnData = SpawnWave008_007,		--出現情報
		},
		{
			Time      = 70,						--出現開始時間
			SpawnData = SpawnWave008_008,		--出現情報
		},
		
		{
			Time      = 80,						--出現開始時間
			SpawnData = SpawnWave009_001,		--出現情報
		},
		{
			Time      = 80.5,						--出現開始時間
			SpawnData = SpawnWave009_002,		--出現情報
		},
		{
			Time      = 81,						--出現開始時間
			SpawnData = SpawnWave009_003,		--出現情報
		},
		{
			Time      = 81.5,						--出現開始時間
			SpawnData = SpawnWave009_004,		--出現情報
		},
		
		{
			Time      = 90,						--出現開始時間
			SpawnData = SpawnWave010_001,		--出現情報
		},
		{
			Time      = 90.5,					--出現開始時間
			SpawnData = SpawnWave010_002,		--出現情報
		},
		{
			Time      = 91,						--出現開始時間
			SpawnData = SpawnWave010_003,		--出現情報
		},
		{
			Time      = 90,						--出現開始時間
			SpawnData = SpawnWave010_004,		--出現情報
		},
		{
			Time      = 90,						--出現開始時間
			SpawnData = SpawnWave010_005,		--出現情報
		},
		
		
		{
			Time      = 100,						--出現開始時間
			SpawnData = SpawnWave011_001,		--出現情報
		},
		{
			Time      = 100,						--出現開始時間
			SpawnData = SpawnWave011_002,		--出現情報
		},
		{
			Time      = 100,						--出現開始時間
			SpawnData = SpawnWave011_003,		--出現情報
		},
		
		{
			Time      = 110,						--出現開始時間
			SpawnData = SpawnWave012_001,		--出現情報
		},
		{
			Time      = 110,						--出現開始時間
			SpawnData = SpawnWave012_002,		--出現情報
		},
		{
			Time      = 110,						--出現開始時間
			SpawnData = SpawnWave012_003,		--出現情報
		},
		{
			Time      = 110,						--出現開始時間
			SpawnData = SpawnWave012_004,		--出現情報
		},
		{
			Time      = 110,						--出現開始時間
			SpawnData = SpawnWave012_005,		--出現情報
		},
		
		{
			Time      = 120,						--出現開始時間
			SpawnData = SpawnWave013_001,		--出現情報
		},
		{
			Time      = 120,						--出現開始時間
			SpawnData = SpawnWave013_002,		--出現情報
		},
		
		{
			Time      = 130,						--出現開始時間
			SpawnData = SpawnWave014_001,		--出現情報
		},
		{
			Time      = 131,						--出現開始時間
			SpawnData = SpawnWave014_002,		--出現情報
		},
		{
			Time      = 132,						--出現開始時間
			SpawnData = SpawnWave014_003,		--出現情報
		},
		{
			Time      = 133,						--出現開始時間
			SpawnData = SpawnWave014_004,		--出現情報
		},
		{
			Time      = 134,						--出現開始時間
			SpawnData = SpawnWave014_005,		--出現情報
		},
		{
			Time      = 135,						--出現開始時間
			SpawnData = SpawnWave014_006,		--出現情報
		},
		
		{
			Time      = 140,						--出現開始時間
			SpawnData = SpawnWave015_001,		--出現情報
		},
		{
			Time      = 141,						--出現開始時間
			SpawnData = SpawnWave015_002,		--出現情報
		},
		{
			Time      = 142,						--出現開始時間
			SpawnData = SpawnWave015_003,		--出現情報
		},
		{
			Time      = 143,						--出現開始時間
			SpawnData = SpawnWave015_004,		--出現情報
		},
		{
			Time      = 144,						--出現開始時間
			SpawnData = SpawnWave015_005,		--出現情報
		},
		{
			Time      = 145,						--出現開始時間
			SpawnData = SpawnWave015_006,		--出現情報
		},
		
		{
			Time      = 150,						--出現開始時間
			SpawnData = SpawnWave016_001,		--出現情報
		},
		{
			Time      = 150,						--出現開始時間
			SpawnData = SpawnWave016_002,		--出現情報
		},
		{
			Time      = 150,						--出現開始時間
			SpawnData = SpawnWave016_003,		--出現情報
		},
		{
			Time      = 150,						--出現開始時間
			SpawnData = SpawnWave016_004,		--出現情報
		},
		
		{
			Time      = 160,						--出現開始時間
			SpawnData = SpawnWave017_001,		--出現情報
		},
		{
			Time      = 162,						--出現開始時間
			SpawnData = SpawnWave017_002,		--出現情報
		},
		{
			Time      = 164,						--出現開始時間
			SpawnData = SpawnWave017_003,		--出現情報
		},
		{
			Time      = 166,						--出現開始時間
			SpawnData = SpawnWave017_004,		--出現情報
		},
		{
			Time      = 168,						--出現開始時間
			SpawnData = SpawnWave017_005,		--出現情報
		},
		{
			Time      = 170,						--出現開始時間
			SpawnData = SpawnWave017_006,		--出現情報
		},
		{
			Time      = 172,						--出現開始時間
			SpawnData = SpawnWave017_001,		--出現情報
		},
		{
			Time      = 172,						--出現開始時間
			SpawnData = SpawnWave017_002,		--出現情報
		},
		{
			Time      = 172,						--出現開始時間
			SpawnData = SpawnWave017_003,		--出現情報
		},
		{
			Time      = 172,						--出現開始時間
			SpawnData = SpawnWave017_004,		--出現情報
		},
		{
			Time      = 172,						--出現開始時間
			SpawnData = SpawnWave017_005,		--出現情報
		},
		{
			Time      = 172,						--出現開始時間
			SpawnData = SpawnWave017_006,		--出現情報
		},
		
		{
			Time      = 170,						--出現開始時間
			SpawnData = SpawnWave018_001,		--出現情報
		},
		{
			Time      = 170,						--出現開始時間
			SpawnData = SpawnWave018_002,		--出現情報
		},
		{
			Time      = 170,						--出現開始時間
			SpawnData = SpawnWave018_003,		--出現情報
		},
		{
			Time      = 170,						--出現開始時間
			SpawnData = SpawnWave018_004,		--出現情報
		},
		{
			Time      = 170,						--出現開始時間
			SpawnData = SpawnWave018_005,		--出現情報
		},
		{
			Time      = 170,						--出現開始時間
			SpawnData = SpawnWave018_006,		--出現情報
		},
		{
			Time      = 170,						--出現開始時間
			SpawnData = SpawnWave018_007,		--出現情報
		},
		{
			Time      = 170,						--出現開始時間
			SpawnData = SpawnWave018_008,		--出現情報
		},
		
		{
			Time      = 180,						--出現開始時間
			SpawnData = SpawnWave019_001,		--出現情報
		},
		{
			Time      = 180.5,						--出現開始時間
			SpawnData = SpawnWave019_002,		--出現情報
		},
		{
			Time      = 181,						--出現開始時間
			SpawnData = SpawnWave019_003,		--出現情報
		},
		{
			Time      = 181.5,						--出現開始時間
			SpawnData = SpawnWave019_004,		--出現情報
		},
		
		{
			Time      = 190,						--出現開始時間
			SpawnData = SpawnWave020_001,		--出現情報
		},
		{
			Time      = 190,					--出現開始時間
			SpawnData = SpawnWave020_003,		--出現情報
		},
		{
			Time      = 190,						--出現開始時間
			SpawnData = SpawnWave020_005,		--出現情報
		},
		{
			Time      = 191,						--出現開始時間
			SpawnData = SpawnWave020_002,		--出現情報
		},
		{
			Time      = 191,						--出現開始時間
			SpawnData = SpawnWave020_004,		--出現情報
		},
		{
			Time      = 191,						--出現開始時間
			SpawnData = SpawnWave020_006,		--出現情報
		},
		
		{
			Time      = 200,						--出現開始時間
			SpawnData = SpawnWave021_001,		--出現情報
		},
		{
			Time      = 200,						--出現開始時間
			SpawnData = SpawnWave021_002,		--出現情報
		},
		{
			Time      = 200,						--出現開始時間
			SpawnData = SpawnWave021_003,		--出現情報
		},
		
		{
			Time      = 210,						--出現開始時間
			SpawnData = SpawnWave022_001,		--出現情報
		},
		{
			Time      = 210,						--出現開始時間
			SpawnData = SpawnWave022_002,		--出現情報
		},
		{
			Time      = 210,						--出現開始時間
			SpawnData = SpawnWave022_003,		--出現情報
		},
		{
			Time      = 210,						--出現開始時間
			SpawnData = SpawnWave022_004,		--出現情報
		},
		{
			Time      = 210,						--出現開始時間
			SpawnData = SpawnWave022_005,		--出現情報
		},
		
		{
			Time      = 220,						--出現開始時間
			SpawnData = SpawnWave023_001,		--出現情報
		},
		{
			Time      = 220,						--出現開始時間
			SpawnData = SpawnWave023_002,		--出現情報
		},
		
		{
			Time      = 230,						--出現開始時間
			SpawnData = SpawnWave024_001,		--出現情報
		},
		{
			Time      = 231,						--出現開始時間
			SpawnData = SpawnWave024_002,		--出現情報
		},
		{
			Time      = 232,						--出現開始時間
			SpawnData = SpawnWave024_003,		--出現情報
		},
		{
			Time      = 233,						--出現開始時間
			SpawnData = SpawnWave024_004,		--出現情報
		},
		{
			Time      = 234,						--出現開始時間
			SpawnData = SpawnWave024_005,		--出現情報
		},
		{
			Time      = 235,						--出現開始時間
			SpawnData = SpawnWave024_006,		--出現情報
		},
		
		{
			Time      = 240,						--出現開始時間
			SpawnData = SpawnWave025_001,		--出現情報
		},
		{
			Time      = 241,						--出現開始時間
			SpawnData = SpawnWave025_002,		--出現情報
		},
		{
			Time      = 242,						--出現開始時間
			SpawnData = SpawnWave025_003,		--出現情報
		},
		{
			Time      = 243,						--出現開始時間
			SpawnData = SpawnWave025_004,		--出現情報
		},
		{
			Time      = 244,						--出現開始時間
			SpawnData = SpawnWave025_005,		--出現情報
		},
		{
			Time      = 245,						--出現開始時間
			SpawnData = SpawnWave025_006,		--出現情報
		},
		
		{
			Time      = 250,						--出現開始時間
			SpawnData = SpawnWave026_001,		--出現情報
		},
		{
			Time      = 250,						--出現開始時間
			SpawnData = SpawnWave026_002,		--出現情報
		},
		
		{
			Time      = 260,						--出現開始時間
			SpawnData = SpawnWave027_001,		--出現情報
		},
		{
			Time      = 262,						--出現開始時間
			SpawnData = SpawnWave027_002,		--出現情報
		},
		{
			Time      = 264,						--出現開始時間
			SpawnData = SpawnWave027_003,		--出現情報
		},
		{
			Time      = 266,						--出現開始時間
			SpawnData = SpawnWave027_004,		--出現情報
		},
		{
			Time      = 268,						--出現開始時間
			SpawnData = SpawnWave027_005,		--出現情報
		},
		{
			Time      = 270,						--出現開始時間
			SpawnData = SpawnWave027_006,		--出現情報
		},
		{
			Time      = 272,						--出現開始時間
			SpawnData = SpawnWave027_001,		--出現情報
		},
		{
			Time      = 272,						--出現開始時間
			SpawnData = SpawnWave027_002,		--出現情報
		},
		{
			Time      = 272,						--出現開始時間
			SpawnData = SpawnWave027_003,		--出現情報
		},
		{
			Time      = 272,						--出現開始時間
			SpawnData = SpawnWave027_004,		--出現情報
		},
		{
			Time      = 272,						--出現開始時間
			SpawnData = SpawnWave027_005,		--出現情報
		},
		{
			Time      = 272,						--出現開始時間
			SpawnData = SpawnWave027_006,		--出現情報
		},
		
		{
			Time      = 270,						--出現開始時間
			SpawnData = SpawnWave028_001,		--出現情報
		},
		{
			Time      = 270,						--出現開始時間
			SpawnData = SpawnWave028_002,		--出現情報
		},
		{
			Time      = 270,						--出現開始時間
			SpawnData = SpawnWave028_003,		--出現情報
		},
		{
			Time      = 270,						--出現開始時間
			SpawnData = SpawnWave028_004,		--出現情報
		},
		{
			Time      = 270,						--出現開始時間
			SpawnData = SpawnWave028_005,		--出現情報
		},
		{
			Time      = 270,						--出現開始時間
			SpawnData = SpawnWave028_006,		--出現情報
		},
		{
			Time      = 270,						--出現開始時間
			SpawnData = SpawnWave028_007,		--出現情報
		},
		{
			Time      = 270,						--出現開始時間
			SpawnData = SpawnWave028_008,		--出現情報
		},
		
		{
			Time      = 280,						--出現開始時間
			SpawnData = SpawnWave029_001,		--出現情報
		},
		{
			Time      = 281,						--出現開始時間
			SpawnData = SpawnWave029_002,		--出現情報
		},
		{
			Time      = 282,						--出現開始時間
			SpawnData = SpawnWave029_003,		--出現情報
		},
		{
			Time      = 283,						--出現開始時間
			SpawnData = SpawnWave029_004,		--出現情報
		},
		{
			Time      = 284,						--出現開始時間
			SpawnData = SpawnWave029_005,		--出現情報
		},
		
		{
			Time      = 290,						--出現開始時間
			SpawnData = SpawnWave030_001,		--出現情報
		},
		{
			Time      = 291,					--出現開始時間
			SpawnData = SpawnWave030_002,		--出現情報
		},
		{
			Time      = 292,						--出現開始時間
			SpawnData = SpawnWave030_003,		--出現情報
		},
		{
			Time      = 293,						--出現開始時間
			SpawnData = SpawnWave030_004,		--出現情報
		},
		{
			Time      = 294,						--出現開始時間
			SpawnData = SpawnWave030_005,		--出現情報
		},
		{
			Time      = 290,						--出現開始時間
			SpawnData = SpawnWave030_006,		--出現情報
		},
		{
			Time      = 291,						--出現開始時間
			SpawnData = SpawnWave030_007,		--出現情報
		},
		{
			Time      = 292,						--出現開始時間
			SpawnData = SpawnWave030_008,		--出現情報
		},
		{
			Time      = 293,						--出現開始時間
			SpawnData = SpawnWave030_009,		--出現情報
		},
	},
	EndTime = 300,	-- この秒数が経過してら、バトル終了チェックを周期的に開始する
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

