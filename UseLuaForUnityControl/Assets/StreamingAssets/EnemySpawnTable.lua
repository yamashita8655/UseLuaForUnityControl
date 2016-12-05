--直接Unityには登録しないスクリプト。いわゆる、ライブラリ化した奴

-- 敵出現テーブル。時間の経過で、どのSpawnDataが発生するのかチェックする
SpawnTable = {
	[1] = {
		Time      = 5,						--出現開始時間
		SpawnData = Spawn0001,				--出現情報
	},
	[2] = {
		Time      = 10,						--出現開始時間
		SpawnData = Spawn0002,				--出現情報
	},
	[3] = {
		Time      = 15,						--出現開始時間
		SpawnData = Spawn0003,				--出現情報
	},
	[4] = {
		Time      = 20,						--出現開始時間
		SpawnData = Spawn0004,				--出現情報
	},
	[5] = {
		Time      = 25,						--出現開始時間
		SpawnData = Spawn0005,				--出現情報
	},
}

-- Timeは、Spawn0001とセットで別のテーブルに定義すべきであって、ここに含める情報じゃないな…
