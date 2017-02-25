--直接Unityには登録しないスクリプト。いわゆる、ライブラリ化した奴

-- クラス定義
-- 通常雑魚的クラス
EnemyBase = {}

-- メソッド定義

-- コンストラクタ
function EnemyBase.new(position, rotate, name, number, width, height)
	local this = CharacterBase.new(position, rotate, name, number, width, height)
	
	-- メンバ変数
	this.ExistCounter = 0.0
	this.ExistTime = 0.0
	this.MoveSpeed = 1.0
	this.Attack = 0
	this.MoveController = nil
	this.BulletEmitterList = {}
	this.EXP = 0

	-- メソッド定義
	-- 初期化
	this.CharacterBaseInitialize = this.Initialize
	this.Initialize = function(self, nowHp, maxHp, attack)
		this:CharacterBaseInitialize(nowHp, maxHp)
		self.Attack = attack
	end
	
	--移動処理クラスの設定
	this.SetMoveController = function(self, controller)
		self.MoveController = controller
	end
	
	-- 攻撃力の取得
	this.GetAttack = function(self)
		return self.Attack
	end
	
	-- 経験値の操作
	this.SetEXP = function(self, exp)
		self.EXP = self.EXP + exp
	end
	this.GetEXP = function(self)
		return self.EXP
	end
	
	-- 更新
	this.Update = function(self, deltaTime)
		local addx, addy = self.MoveController:Calc(deltaTime, self.Rotate.z+90)
		self.Position.x = self.Position.x + addx
		self.Position.y = self.Position.y + addy
		LuaSetPosition(self.Name, self.Position.x, self.Position.y, self.Position.z)
		self.ExistCounter = self.ExistCounter + deltaTime
	end

	return this
end

