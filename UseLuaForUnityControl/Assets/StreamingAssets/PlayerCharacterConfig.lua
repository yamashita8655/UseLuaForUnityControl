--直接Unityには登録しないスクリプト。いわゆる、ライブラリ化した奴

-- プレイヤーキャラクター定義
PlayerCharacterConfig = {
	{
		PrefabName = "Prefabs/PlayerCharacterObject001",
		Name = "PlayerCharacterObject001",
		Width = 128,
		Height = 128,
		NowHp = 100,
		MaxHp = 100,
		BulletEmitterList = {
			Emitter001.new(1.0, Vector2.new(0, 0), EmitterTypeEnum.Normal),
			Emitter001.new(0.25, Vector2.new(100, 0), EmitterTypeEnum.Satellite),
			Emitter001.new(0.25, Vector2.new(-100, 0), EmitterTypeEnum.Satellite),
		},
		EquipBulletList = {
			BulletStrong,
			Bullet0002,
			Bullet0002,
		},-- 今は、BulletEmitterListとEquipBulletListの数は同じにしておかないとダメ
		DetailText = "名前はもち\n白くてもちもちしている。かわいい。\n\n攻撃方法は連射速度の速い直線の弾を撃つ。",
		SkillConfig = SkillData.new(SkillTable_001),
		SkillDetailText = SkillDetailText001,
		UnlockNeedValue = 0,
		HomePlayerPrefabName = "Prefabs/HomeCharacter1",
		HomePlayerName = "HomeCharacter1",
	},
	{
		PrefabName = "Prefabs/PlayerCharacterObject002",
		Name = "PlayerCharacterObject002",
		Width = 128,
		Height = 128,
		NowHp = 50,
		MaxHp = 100,
		BulletEmitterList = {
			Emitter001.new(0.25, Vector2.new(0, 0), EmitterTypeEnum.Normal),
			Emitter001.new(1.0, Vector2.new(0, 0), EmitterTypeEnum.Normal),
			Emitter001.new(0.25, Vector2.new(0, 0), EmitterTypeEnum.Normal),
		},
		EquipBulletList = {
			Bullet0002,
			Bullet0001,
			Bullet0002,
		},-- 今は、BulletEmitterListとEquipBulletListの数は同じにしておかないとダメ
		DetailText = "名前はとら\nおでこの縦しまが3本。イノシシではない。かわいい。\n\n攻撃方法は貫通力のある直線の弾を撃つ。",
		SkillConfig = SkillData.new(SkillTable_001),
		SkillDetailText = SkillDetailText001,
		UnlockNeedValue = 0,
		HomePlayerPrefabName = "Prefabs/HomeCharacter2",
		HomePlayerName = "HomeCharacter2",
	},
	{
		PrefabName = "Prefabs/PlayerCharacterObject003",
		Name = "PlayerCharacterObject003",
		Width = 128,
		Height = 128,
		NowHp = 50,
		MaxHp = 100,
		BulletEmitterList = {
			Emitter001.new(0.25, Vector2.new(0, 0), EmitterTypeEnum.Normal),
			Emitter001.new(1.0, Vector2.new(0, 0), EmitterTypeEnum.Normal),
			Emitter001.new(0.25, Vector2.new(0, 0), EmitterTypeEnum.Normal),
		},
		EquipBulletList = {
			Bullet0002,
			Bullet0001,
			Bullet0002,
		},-- 今は、BulletEmitterListとEquipBulletListの数は同じにしておかないとダメ
		DetailText = "名前はぶち\nところどころぶち。かわいい。\n\n攻撃方法は変則的に曲がる弾を撃つ。",
		SkillConfig = SkillData.new(SkillTable_001),
		SkillDetailText = SkillDetailText001,
		UnlockNeedValue = 500,
		HomePlayerPrefabName = "Prefabs/HomeCharacter3",
		HomePlayerName = "HomeCharacter3",
	},
	{
		PrefabName = "Prefabs/PlayerCharacterObject004",
		Name = "PlayerCharacterObject004",
		Width = 128,
		Height = 128,
		NowHp = 50,
		MaxHp = 100,
		BulletEmitterList = {
			Emitter001.new(0.25, Vector2.new(0, 0), EmitterTypeEnum.Normal),
			Emitter001.new(1.0, Vector2.new(0, 0), EmitterTypeEnum.Normal),
			Emitter001.new(0.25, Vector2.new(0, 0), EmitterTypeEnum.Normal),
		},
		EquipBulletList = {
			Bullet0002,
			Bullet0001,
			Bullet0002,
		},-- 今は、BulletEmitterListとEquipBulletListの数は同じにしておかないとダメ
		DetailText = "名前はさくら\nほっぺがチャームポイント。かわいい。\n\n攻撃方法は未定。",
		SkillConfig = SkillData.new(SkillTable_001),
		SkillDetailText = SkillDetailText001,
		--UnlockNeedValue = 500,
		UnlockNeedValue = 0,
		HomePlayerPrefabName = "Prefabs/HomeCharacter4",
		HomePlayerName = "HomeCharacter4",
	},
}

