--直接Unityには登録しないスクリプト。いわゆる、ライブラリ化した奴

--SkillTypeEnum = {
--	Emitter = 1,
--	Bullet = 2,
--	ExpTable = 3,
--}

-- 弾の発射台の設定
SkillData = {}

function SkillData.new(skillTable)
	local this = {
		SkillLevelList = {},
		SkillMaxLevelList = {},
		SkillNextExpList = {},
		SkillTable = {},
	}

	for i = 1, #skillTable do
		table.insert(this.SkillLevelList, 1)
	end
	
	for i = 1, #skillTable do
		local skillTableData = skillTable[i]
		local val = #skillTableData
		table.insert(this.SkillMaxLevelList, val)
	end
	
	for i = 1, #skillTable do
		table.insert(this.SkillNextExpList, skillTable[i])
	end
	
	this.SkillTable = skillTable
	
	this.GetSkillLevel = function(self, skillType)
		return self.SkillLevelList[skillType]
	end
	this.SetSkillLevel = function(self, skillType, value)
		self.SkillLevelList[skillType] = value
	end
	this.AddSkillLevel = function(self, skillType)
		self.SkillLevelList[skillType] = self.SkillLevelList[skillType] + 1
	end
	
	this.GetMaxSkillLevel = function(self, skillType)
		return self.SkillMaxLevelList[skillType]
	end
	
	this.GetNextExp = function(self, skillLevel)
		--local nowLevel = self.SkillLevelList[skillType]
		--local maxLevel = self.SkillMaxLevelList[skillType]
		--local exp = ""
		--if nowLevel == maxLevel then
		--	exp = "MAX"
		--else
		--	local needExpTable = self.SkillTable[skillType]
		--	local needExp = needExpTable[nowLevel]
		--	exp = needExp
		--end
		
		local exp = ""
		if self.SkillTable[skillLevel] == -1 then
			exp = "MAX"
		else
			local needExpTable = self.SkillTable[SkillTypeEnum.ExpTable]
			local needExp = needExpTable[skillLevel]
			exp = needExp
		end

		return exp
	end
	
	this.GetSkillTable = function(self)
		return self.SkillTable
	end
	
	return this
end



-- スキル定義
--SkillEmitter001 = {
--	Emitter001.new(1.0, Vector2.new(0, 0), EmitterTypeEnum.Normal),
--}
--
--SkillEmitter002 = {
--	Emitter001.new(1.0, Vector2.new(0, 0), EmitterTypeEnum.Normal),
--	Emitter001.new(0.25, Vector2.new(100, 0), EmitterTypeEnum.Satellite),
--	Emitter001.new(0.25, Vector2.new(-100, 0), EmitterTypeEnum.Satellite),
--}

-- モチ用スキルテーブル
SkillTable_001 = {
	-- Emitter
	{
		{
			0,-- 次のレベルに必要な値？ちょっと設計見直してコメント書く 
			BulletEmitterList = {
				Emitter001.new(0.125, Vector2.new(0, 50), 0, EmitterTypeEnum.Satellite),
			},
		},
		
		{
			100,
			BulletEmitterList = {
				Emitter001.new(0.125, Vector2.new(0, 50), 0, EmitterTypeEnum.Satellite),
				Emitter001.new(0.125, Vector2.new(-100, 0), 0, EmitterTypeEnum.Satellite),
				Emitter001.new(0.125, Vector2.new(100, 0), 0, EmitterTypeEnum.Satellite),
			}
		},
		
		{
			200,
			BulletEmitterList = {
				Emitter001.new(0.125, Vector2.new(0, 50), 0, EmitterTypeEnum.Satellite),
				Emitter001.new(0.125, Vector2.new(-100, 0), 0, EmitterTypeEnum.Satellite),
				Emitter001.new(0.125, Vector2.new(100, 0), 0, EmitterTypeEnum.Satellite),
				Emitter001.new(0.125, Vector2.new(0, 50), 20, EmitterTypeEnum.Satellite),
				Emitter001.new(0.125, Vector2.new(0, 50), -20, EmitterTypeEnum.Satellite),
			}
		},
		
		{
			300,
			BulletEmitterList = {
				Emitter001.new(0.125, Vector2.new(0, 50), 0, EmitterTypeEnum.Satellite),
				Emitter001.new(0.125, Vector2.new(-100, 0), 0, EmitterTypeEnum.Satellite),
				Emitter001.new(0.125, Vector2.new(100, 0), 0, EmitterTypeEnum.Satellite),
				Emitter001.new(0.125, Vector2.new(0, 50), 20, EmitterTypeEnum.Satellite),
				Emitter001.new(0.125, Vector2.new(0, 50), -20, EmitterTypeEnum.Satellite),
				Emitter001.new(0.125, Vector2.new(0, -50), 180, EmitterTypeEnum.Satellite),
				Emitter001.new(0.125, Vector2.new(0, -50), 200, EmitterTypeEnum.Satellite),
				Emitter001.new(0.125, Vector2.new(0, -50), 160, EmitterTypeEnum.Satellite),
			}
		},
		
		{
			500,
			BulletEmitterList = {
				Emitter001.new(0.125, Vector2.new(0, 50), 0, EmitterTypeEnum.Satellite),
				Emitter001.new(0.125, Vector2.new(-100, 0), 0, EmitterTypeEnum.Satellite),
				Emitter001.new(0.125, Vector2.new(100, 0), 0, EmitterTypeEnum.Satellite),
				Emitter001.new(0.125, Vector2.new(0, 50), 20, EmitterTypeEnum.Satellite),
				Emitter001.new(0.125, Vector2.new(0, 50), -20, EmitterTypeEnum.Satellite),
				Emitter001.new(0.125, Vector2.new(0, -50), 180, EmitterTypeEnum.Satellite),
				Emitter001.new(0.125, Vector2.new(0, -50), 200, EmitterTypeEnum.Satellite),
				Emitter001.new(0.125, Vector2.new(0, -50), 160, EmitterTypeEnum.Satellite),
				Emitter001.new(0.125, Vector2.new(-50, 0), 90, EmitterTypeEnum.Satellite),
				Emitter001.new(0.125, Vector2.new(-50, 0), 70, EmitterTypeEnum.Satellite),
				Emitter001.new(0.125, Vector2.new(-50, 0), 110, EmitterTypeEnum.Satellite),
				Emitter001.new(0.125, Vector2.new(50, 0), 270, EmitterTypeEnum.Satellite),
				Emitter001.new(0.125, Vector2.new(50, 0), 290, EmitterTypeEnum.Satellite),
				Emitter001.new(0.125, Vector2.new(50, 0), 250, EmitterTypeEnum.Satellite),
			}
		},
	},
	
	-- Bullet
	{
		{
			0,	
			EquipBulletList = {
				Character1_Bullet0001,
			},
		},
		
		{
			1000,
			EquipBulletList = {
				Character1_Bullet0002,
			},
		},
		
		{	
			5000,
			EquipBulletList = {
				Character1_Bullet0003,
			},
		},
	},
	
	-- ExpTable
	{
		30,
		250,
		1000,
		2500,
		5000,
		10000,
		-1,
	},
}

SkillDetailText001 = {
	-- EmitterDetail
	"レベルが上がると、弾の発射口が増える\n1⇒3⇒5⇒？⇒？\n",
	-- BulletDetail
	"レベルが上がると、弾の攻撃力が上がる\n地味だけど重要\n体感はしづらいかもしれない",
	-- Test
	--"多分パッシブ\nHPとか。\nそのへん。",
}

-- トラ用スキルテーブル
SkillTable_Tora = {
	-- Emitter
	{
		{
			0,-- 次のレベルに必要な値？ちょっと設計見直してコメント書く 
			BulletEmitterList = {
				Emitter001.new(0.10, Vector2.new(35, 50), 3, EmitterTypeEnum.Satellite),
				Emitter001.new(0.10, Vector2.new(-35, 50), -3, EmitterTypeEnum.Satellite),
				Emitter001.new(0.33, Vector2.new(0, -110), 180, EmitterTypeEnum.Satellite),
			},
		},
		
		{
			100,
			BulletEmitterList = {
				Emitter001.new(0.075, Vector2.new(35, 50), 3, EmitterTypeEnum.Satellite),
				Emitter001.new(0.075, Vector2.new(-35, 50), -3, EmitterTypeEnum.Satellite),
				Emitter001.new(0.33, Vector2.new(0, -110), 180, EmitterTypeEnum.Satellite),
			}
		},
		
		{
			100,
			BulletEmitterList = {
				Emitter001.new(0.05, Vector2.new(35, 50), 3, EmitterTypeEnum.Satellite),
				Emitter001.new(0.05, Vector2.new(-35, 50), -3, EmitterTypeEnum.Satellite),
				
				Emitter001.new(0.33, Vector2.new(0, -110), 180, EmitterTypeEnum.Satellite),
				
				Emitter001.new(0.75, Vector2.new(-50, 0), 90, EmitterTypeEnum.Satellite),
				Emitter001.new(0.75, Vector2.new(50, 0), -90, EmitterTypeEnum.Satellite),
			}
		},
	},
	
	-- Bullet
	{
		{
			0,	
			EquipBulletList = {
				Bullet_Tora_Bullet_1,
				Bullet_Tora_Bullet_1,
				Bullet_Tora_Bullet_Circle1,
				Bullet_Tora_Bullet_Homing1,
				Bullet_Tora_Bullet_Homing1,
			},
		},
		
		{
			1000,
			EquipBulletList = {
				Bullet_Tora_Bullet_2,
				Bullet_Tora_Bullet_2,
				Bullet_Tora_Bullet_Circle1,
				Bullet_Tora_Bullet_Homing1,
				Bullet_Tora_Bullet_Homing1,
			},
		},

		{
			1000,
			EquipBulletList = {
				Bullet_Tora_Bullet_3,
				Bullet_Tora_Bullet_3,
				Bullet_Tora_Bullet_Circle1,
				Bullet_Tora_Bullet_Homing1,
				Bullet_Tora_Bullet_Homing1,
			},
		},
	},
	
	-- ExpTable
	{
		30,
		250,
		1000,
		2500,
		5000,
		10000,
		-1,
	},
}

SkillDetailTextTora = {
	-- EmitterDetail
	"レベルが上がると、射撃速度が速くなる。\nあるレベル以上から、追尾弾が追加される。",
	-- BulletDetail
	"レベルが上がると、弾の攻撃力と射程が上がる。\n",
}

-- ブチ用スキルテーブル
SkillTable_Buchi = {
	-- Emitter
	{
		{
			0,-- 次のレベルに必要な値？ちょっと設計見直してコメント書く 
			BulletEmitterList = {
				Emitter001.new(2.0, Vector2.new(0, 50), 0, EmitterTypeEnum.Satellite),

				Emitter001.new(0.16, Vector2.new(0, 50), 0, EmitterTypeEnum.Satellite),
				Emitter001.new(0.16, Vector2.new(0, 50), 0, EmitterTypeEnum.Satellite),
			},
		},
		
		{
			100,
			BulletEmitterList = {
				Emitter001.new(1.75, Vector2.new(0, 50), 0, EmitterTypeEnum.Satellite),

				Emitter001.new(0.16, Vector2.new(0, 50), 0, EmitterTypeEnum.Satellite),
				Emitter001.new(0.16, Vector2.new(0, 50), 0, EmitterTypeEnum.Satellite),
			}
		},
		
		{
			100,
			BulletEmitterList = {
				Emitter001.new(1.5, Vector2.new(0, 50), 0, EmitterTypeEnum.Satellite),

				Emitter001.new(0.16, Vector2.new(0, 50), 0, EmitterTypeEnum.Satellite),
				Emitter001.new(0.16, Vector2.new(0, 50), 0, EmitterTypeEnum.Satellite),
			}
		},
	},
	
	-- Bullet
	{
		{
			0,	
			EquipBulletList = {
				Bullet_Buchi_Bullet_Cannon1,
				Bullet_Buchi_Bullet_CinCurve1_1,
				Bullet_Buchi_Bullet_CinCurve1_2,
			},
		},
		
		{
			1000,
			EquipBulletList = {
				Bullet_Buchi_Bullet_Cannon2,
				Bullet_Buchi_Bullet_CinCurve2_1,
				Bullet_Buchi_Bullet_CinCurve2_2,
			},
		},

		{
			1000,
			EquipBulletList = {
				Bullet_Buchi_Bullet_Cannon3,
				Bullet_Buchi_Bullet_CinCurve3_1,
				Bullet_Buchi_Bullet_CinCurve3_2,
			},
		},
	},
	
	-- ExpTable
	{
		30,
		250,
		1000,
		2500,
		5000,
		10000,
		-1,
	},
}

SkillDetailTextBuchi = {
	-- EmitterDetail
	"レベルが上がると、発射間隔が短く。\n",
	-- BulletDetail
	"レベルが上がると、弾の攻撃力と範囲と大きさが強化される。\n",
	-- Test
	--"多分パッシブ\nHPとか。\nそのへん。",
}

-- サクラ用スキルテーブル
SkillTable_Sakura = {
	-- Emitter
	{
		{
			0,-- 次のレベルに必要な値？ちょっと設計見直してコメント書く 
			BulletEmitterList = {
				Emitter001.new(0.16, Vector2.new(0, 50), 0, EmitterTypeEnum.Satellite),
				Emitter001.new(1.0, Vector2.new(25, 50), 0, EmitterTypeEnum.Satellite),
				Emitter001.new(1.0, Vector2.new(-25, 50), 0, EmitterTypeEnum.Satellite),
				Emitter001.new(6.0, Vector2.new(0, -100), 180, EmitterTypeEnum.Satellite),
				Emitter001.new(6.0, Vector2.new(100, 0), -90, EmitterTypeEnum.Satellite),
				Emitter001.new(6.0, Vector2.new(-100, 0), 90, EmitterTypeEnum.Satellite),
			},
		},
		
		{
			100,
			BulletEmitterList = {
				Emitter001.new(0.16, Vector2.new(0, 50), 0, EmitterTypeEnum.Satellite),
				Emitter001.new(0.75, Vector2.new(25, 50), 0, EmitterTypeEnum.Satellite),
				Emitter001.new(0.75, Vector2.new(-25, 50), 0, EmitterTypeEnum.Satellite),
				Emitter001.new(5.9, Vector2.new(0, -100), 180, EmitterTypeEnum.Satellite),
				Emitter001.new(5.9, Vector2.new(100, 0), -90, EmitterTypeEnum.Satellite),
				Emitter001.new(5.9, Vector2.new(-100, 0), 90, EmitterTypeEnum.Satellite),
			}
		},
		
		{
			100,
			BulletEmitterList = {
				Emitter001.new(0.16, Vector2.new(0, 50), 0, EmitterTypeEnum.Satellite),
				Emitter001.new(0.5, Vector2.new(25, 50), 0, EmitterTypeEnum.Satellite),
				Emitter001.new(0.5, Vector2.new(-25, 50), 0, EmitterTypeEnum.Satellite),
				Emitter001.new(5.8, Vector2.new(0, -100), 180, EmitterTypeEnum.Satellite),
				Emitter001.new(5.8, Vector2.new(100, 0), -90, EmitterTypeEnum.Satellite),
				Emitter001.new(5.8, Vector2.new(-100, 0), 90, EmitterTypeEnum.Satellite),
			}
		},
	},
	
	-- Bullet
	{
		{
			0,	
			EquipBulletList = {
				Bullet_Sakura_Bullet1,
				Bullet_Sakura_HomingBullet1,
				Bullet_Sakura_HomingBullet1,
				Bullet_Sakura_WallBullet1,
				Bullet_Sakura_WallBullet1,
				Bullet_Sakura_WallBullet1,
			},
		},
		
		{
			1000,
			EquipBulletList = {
				Bullet_Sakura_Bullet1,
				Bullet_Sakura_HomingBullet1,
				Bullet_Sakura_HomingBullet1,
				Bullet_Sakura_WallBullet2,
				Bullet_Sakura_WallBullet2,
				Bullet_Sakura_WallBullet2,
			},
		},

		{
			1000,
			EquipBulletList = {
				Bullet_Sakura_Bullet1,
				Bullet_Sakura_HomingBullet1,
				Bullet_Sakura_HomingBullet1,
				Bullet_Sakura_WallBullet3,
				Bullet_Sakura_WallBullet3,
				Bullet_Sakura_WallBullet3,
			},
		},
	},
	
	-- ExpTable
	{
		30,
		250,
		1000,
		2500,
		5000,
		10000,
		-1,
	},
}

SkillDetailTextSakura = {
	-- EmitterDetail
	"レベルが上がると、発射間隔が短くなる\n",
	-- BulletDetail
	"レベルが上がると、防御弾の大きさが広がる\n",
	-- Test
	--"多分パッシブ\nHPとか。\nそのへん。",
}
