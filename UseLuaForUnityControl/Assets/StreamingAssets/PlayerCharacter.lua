--直接Unityには登録しないスクリプト。いわゆる、ライブラリ化した奴

-- クラス定義
-- プレイヤークラス
PlayerCharacter = {}

-- メソッド定義

-- コンストラクタ
function PlayerCharacter.new(posx, posy, posz, rotx, roty, rotz, name, width, height)
	local this = CharacterBase.new(posx, posy, posz, rotx, roty, rotz, name, 0, width, height)
	
	-- メンバ変数
	this.ExistCounter = 0.0
	this.ExistTime = 0.0
	this.MoveSpeed = 1.0
	this.BulletEmitterList = {}

	-- メソッド定義
	-- 初期化
	this.CharacterBaseInitialize = this.Initialize
	this.Initialize = function(self, nowHp, maxHp)
		this:CharacterBaseInitialize(nowHp, maxHp)
		LuaFindObject("PlayerHPGaugeBar")
		self:UpdateHpGauge()
	end
	
	-- HPゲージの更新
	this.UpdateHpGauge = function(self)
		barRate = self.NowHp / self.MaxHp
		LuaSetScale("PlayerHPGaugeBar", 1.0, barRate, 1.0)
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
	
	-- メタテーブルセット
	--return setmetatable(this, {__index = PlayerCharacter})
	return this
end

