--直接Unityには登録しないスクリプト。いわゆる、ライブラリ化した奴

-- クエスト定義
QuestConfig = {
	ID_001 = {
		QuestName = "テスト",
		EnemySpawnTable = SpawnTableTest,
	},
	ID_002 = {
		QuestName = "初級",
		EnemySpawnTable = SpawnTable_001,
	},
	ID_003 = {
		QuestName = "中級",
		EnemySpawnTable = SpawnTable_002,
	},
	ID_004 = {
		QuestName = "上級",
		EnemySpawnTable = SpawnTable_003,
	},
	
	ID_QUICK = {
		QuestName = "クイックバトル",
		--EnemySpawnTable = SpawnTable_003,
		EnemySpawnTable = SpawnTableTest,
	},
}

