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
	this.BuffMoveSpeed = 0 -- どこかで計算後の実数値
	this.BuffAttack = 0 -- どこかで計算後の実数値
	this.BuffMaxHp = 0 -- どこかで計算後の実数値

	-- メソッド定義
	-- 初期化
	this.CharacterBaseInitialize = this.Initialize
	this.Initialize = function(self, nowHp, maxHp, attack)
		this:CharacterBaseInitialize(nowHp, maxHp)
		self.Attack = attack
	end
	
	-- バフ補正値の設定
	this.SetBuffMoveSpeed = function(self, moveSpeed)
		self.BuffMoveSpeed = moveSpeed 
	end
	this.SetBuffAttack = function(self, attack)
		self.BuffAttack = attack 
	end
	this.SetBuffMaxHp = function(self, hp)
		self.BuffMaxHp = hp
	end
	
	-- パラメータの更新(というよりは、HPも全回復させるので、初期化に近い)
	-- バフの適用もここで行う
	this.InitializeParameter = function(self)
		self.Attack = self.Attack + self.BuffAttack
		self.MoveSpeed = self.MoveSpeed + self.BuffMoveSpeed
		self.NowHp = self.MaxHp + self.BuffMaxHp
		self.MaxHp = self.MaxHp + self.BuffMaxHp
	end
	
	--移動処理クラスの設定
	this.SetMoveController = function(self, controller)
		self.MoveController = controller
	end
	
	-- 速度の取得
	this.GetMoveSpeed = function(self)
		return self.MoveSpeed
	end
	
	-- 攻撃力の取得
	this.GetAttack = function(self)
		return self.Attack
	end
	
	-- 最大HPの取得
	this.GetMaxHp = function(self)
		return self.MaxHp
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

