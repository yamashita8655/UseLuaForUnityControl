--直接Unityには登録しないスクリプト。いわゆる、ライブラリ化した奴

-- クラス定義
-- 通常雑魚的クラス
NormalEnemyCharacter = {}

-- メソッド定義

-- コンストラクタ
function NormalEnemyCharacter.new(posx, posy, posz, rotx, roty, rotz, name, number, width, height)
	local this = EnemyBase.new(posx, posy, posz, rotx, roty, rotz, name, number, width, height)
	
	-- メンバ変数

	-- メソッド定義
	-- 初期化
	this.EnemyBaseInitialize = this.Initialize
	this.Initialize = function(self, nowHp, maxHp, attack)
		this:EnemyBaseInitialize(nowHp, maxHp)
		self.Attack = attack
	end
	
	-- 更新
	this.BaseUpdate = this.Update
	this.Update = function(self, deltaTime)
		local addx, addy = self.MoveController:Calc(self.RotateZ+90)
		self.PositionX = self.PositionX + addx
		self.PositionY = self.PositionY + addy
		LuaSetPosition(self.Name, self.PositionX, self.PositionY, self.PositionZ)
		self.ExistCounter = self.ExistCounter + deltaTime
	end

	return this
end

