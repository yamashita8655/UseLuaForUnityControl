--直接Unityには登録しないスクリプト。いわゆる、ライブラリ化した奴

-- クラス定義
-- プレイヤークラス
PlayerCharacter = {}

-- メソッド定義

-- コンストラクタ
function PlayerCharacter.new(position, rotate, name, width, height)
	local this = CharacterBase.new(position, rotate, name, 0, width, height)
	
	-- メンバ変数
	this.ExistCounter = 0.0
	this.ExistTime = 0.0
	this.MoveSpeed = 1.0
	this.BulletEmitterList = {}
	this.EXP = 0
	this.SkillConfig = {}
	this.SkillDetailText = {}
	this.SkillLevel = 1
	this.HaveSkillPoint = 0 -- 一度、自動でレベルアップしてポイントを

	-- メソッド定義
	-- 初期化
	this.CharacterBaseInitialize = this.Initialize
	this.Initialize = function(self, nowHp, maxHp)
		this:CharacterBaseInitialize(nowHp, maxHp)
		LuaFindObject("PlayerHPGaugeBar")
		self.SkillLevel = 1
		self.HaveSkillPoint = 0
		self:UpdateHpGauge()
	end
	
	-- HPゲージの更新
	this.UpdateHpGauge = function(self)
		barRate = self.NowHp / self.MaxHp
		--LuaSetScale("PlayerHPGaugeBar", 1.0, barRate, 1.0)
		LuaSetScale("PlayerHPGaugeBar", barRate, 1.0, 1.0)
	end
	
	-- 現在HPの加減算
	this.CharacterBaseAddNowHp = this.AddNowHp
	this.AddNowHp = function(self, addValue)
		self:CharacterBaseAddNowHp(addValue)
		self:UpdateHpGauge()
	end
	
	-- 現在HPの直接値指定
	this.CharacterBaseSetNowHp = this.SetNowHp
	this.SetNowHp = function(self, value)
		self:CharacterBaseSetNowHp(value)
		self:UpdateHpGauge()
	end
	
	-- 最大HPの加減算
	this.CharacterBaseAddMaxHp = this.AddMaxHp
	this.AddMaxHp = function(self, addValue)
		self:CharacterBaseAddMaxHp(addValue)
		self:UpdateHpGauge()
	end
	
	-- 最大HPの直接値指定
	this.CharacterBaseSetMaxHp = this.SetMaxHp
	this.SetMaxHp = function(self, value)
		self:CharacterBaseSetMaxHp(value)
		self:UpdateHpGauge()
	end

	-- 更新
	this.BaseUpdate = this.Update
	this.Update = function(self, deltaTime)
		for i = 1, #self.BulletEmitterList do
			emitter = self.BulletEmitterList[i]
			emitter:Update(deltaTime)
		end
	end
	
	-- 弾が発射されるポイントの追加
	this.AddBulletEmitter = function(self, emitter)
		table.insert(self.BulletEmitterList, emitter)
	end
	
	-- 弾発射ポイントの初期化
	this.ClearBulletEmitter = function(self, emitter)
		self.BulletEmitterList = {}
	end
	
	-- 弾のクールタイムが終わっているかどうか
	this.ShootBullet = function(self, degree)
		for i = 1, #self.BulletEmitterList do
			emitter = self.BulletEmitterList[i]
			emitter:ShootBullet(degree)
		end
	end
	
	-- BulletEmitterSatellite
	this.UpdateSatelliteEmitterPosition = function(self, radian, degree)
		for i = 1, #self.BulletEmitterList do
			emitter = self.BulletEmitterList[i]
			emitter:UpdatePosition(radian, degree)
		end
	end
	
	-- 経験値増減
	this.AddEXP = function(self, value)
		self.EXP = self.EXP + value

		local skillConfig = self.SkillConfig
		local skillTable = skillConfig:GetSkillTable()
		local skillExp = skillTable[SkillTypeEnum.ExpTable][self.SkillLevel]

		if skillExp == -1 then
			--カンスト
		else
			if self.EXP >= skillExp then
				self.SkillLevel = self.SkillLevel + 1
				self.HaveSkillPoint = self.HaveSkillPoint + 1
			end
		end
	end
	
	-- 経験値取得
	this.GetEXP = function(self)
		return self.EXP
	end

	this.SetSkillLevel = function(self, value)
		self.SkillLevel = value
	end
	-- 
	this.GetSkillLevel = function(self)
		return self.SkillLevel
	end

	this.GetHaveSkillPoint = function(self)
		return self.HaveSkillPoint
	end
	
	this.AddHaveSkillPoint = function(self, value)
		self.HaveSkillPoint = self.HaveSkillPoint + value
	end

	-- スキルレベルデータ操作
	this.SetSkillConfig = function(self, skillConfig)
		self.SkillConfig = skillConfig
	end
	this.GetSkillConfig = function(self)
		return self.SkillConfig
	end
	
	-- スキルテキスト
	this.SetSkillDetailText = function(self, skillDetailText)
		self.SkillDetailText = skillDetailText
	end
	this.GetSkillDetailText = function(self)
		return self.SkillDetailText
	end
	
	-- メタテーブルセット
	--return setmetatable(this, {__index = PlayerCharacter})
	return this
end

