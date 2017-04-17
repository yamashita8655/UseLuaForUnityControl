--直接Unityには登録しないスクリプト。いわゆる、ライブラリ化した奴
--BulletTypeEnum = {
--	Normal = 0,--ノーマルって書いてあるけど、弾の情報だけで処理できる弾
--	UseTargetPosition = 1,--他の何かの座標値が影響する弾の情報
--}


--〇メインウェポン
--・真っ直ぐ飛ばないが連射力の高いサブマシンガン
--・連射力は低いが、攻撃力が高く範囲も広い鉄球貫通弾
--・攻撃範囲が広い、サークルガン
--・射程は短いが、連射力と威力が高いインサイドサブマシンガン
--
--〇サブウェポン
--・自機の周りを周回するサークルバリア弾
--・敵を追尾するホーミングミサイル
--・敵を追尾してかつ、複数破壊するまで生存するホーミング弾

-- 弾の定義
Character1_Bullet0001 = {
	PrefabName = "BulletObjectNormal",
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
	PrefabName = "BulletObjectNormal",
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
	PrefabName = "BulletObjectEnemyTooth1",
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

-- トラ用弾
-- 威力は高いが、弾サイズと継続時間が短い
Bullet_Tora_Bullet_1 = {
	PrefabName = "BulletObjectTooth16",
	Name = "ToraBullet1",
	Width = 16,
	Height = 16,
	NowHp = 1,
	MaxHp = 1,
	Attack = 2,
	ExistTime = 0.25,
	--ExistTime = 5,
	MoveType = MoveStraight.new(15),
	--MoveType = MoveStraight.new(5),
	BulletType = BulletTypeEnum.Normal,
}
Bullet_Tora_Bullet_2 = {
	PrefabName = "BulletObjectTooth16",
	Name = "ToraBullet2",
	Width = 16,
	Height = 16,
	NowHp = 1,
	MaxHp = 1,
	Attack = 2,
	ExistTime = 0.35,
	MoveType = MoveStraight.new(15),
	BulletType = BulletTypeEnum.Normal,
}
Bullet_Tora_Bullet_3 = {
	PrefabName = "BulletObjectTooth16",
	Name = "ToraBullet3",
	Width = 16,
	Height = 16,
	NowHp = 1,
	MaxHp = 1,
	Attack = 3,
	ExistTime = 0.5,
	MoveType = MoveStraight.new(15),
	BulletType = BulletTypeEnum.Normal,
}

Bullet0001 = {
	PrefabName = "EnemyCharacterObject",
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
	PrefabName = "EnemyCharacterObject",
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
	PrefabName = "EnemyCharacterObject",
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
	PrefabName = "EnemyCharacterObject",
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
	PrefabName = "EnemyCharacterObject",
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
	PrefabName = "BulletObjectEnemyTooth1",
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
	PrefabName = "EnemyCharacterObject",
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
	PrefabName = "BulletObjectNormal",
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
	PrefabName = "BulletObjectEnemyTooth1",
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
