--直接Unityには登録しないスクリプト。いわゆる、ライブラリ化した奴

-- クラス定義
-- 弾クラス
BulletBase = {}

-- メソッド定義

-- コンストラクタ
function BulletBase.new(position, rotate, name, number, width, height)
	local this = ObjectBase.new(position, rotate, name, number, width, height)
	
	-- メンバ変数
	this.BulletType = 0
	this.ExistCounter = 0.0
	this.ExistTime = 0.0
	this.MoveSpeed = 0.0
	this.Attack = 0
	this.MoveController = nil
	this.BulletConfig = nil

	-- メソッド定義
	-- 初期化
	this.ObjectBaseInitialize = this.Initialize
	this.Initialize = function(self, nowHp, maxHp, attack, existTime, bulletConfig)
		this:ObjectBaseInitialize(nowHp, maxHp)
		self.Attack = attack
		self.ExistTime = existTime
		self.BulletConfig = bulletConfig
	end
	
	--移動処理クラスの設定
	this.SetMoveController = function(self, controller)
		self.MoveController = controller
	end

	-- 攻撃力の取得
	this.GetAttack = function(self)
		return self.Attack
	end
	
	-- 生存判定
	this.ObjectBaseIsAlive = this.IsAlive
	this.IsAlive = function(self)
		local isAlive = this:ObjectBaseIsAlive()
		if isAlive == false then
			return false
		end

		if self.ExistCounter > self.ExistTime then
			return false
		end

		return true
	end
	
	-- 更新判定
	this.ObjectBaseUpdate = this.Update
	this.Update = function(self, deltaTime)
		self.ExistCounter = self.ExistCounter + deltaTime
	end
	
	-- 弾種別
	this.GetBulletType = function(self)
		return self.BulletType
	end
	
	-- 弾情報
	this.GetBulletConfig = function(self)
		return self.BulletConfig
	end

	-- メタテーブルセット
	--return setmetatable(this, {__index = BulletBase})
	return this
end

