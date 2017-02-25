--直接Unityには登録しないスクリプト。いわゆる、ライブラリ化した奴

-- クラス定義
-- 通常雑魚的クラス
SinCurveEnemy = {}

-- メソッド定義

-- コンストラクタ
function SinCurveEnemy.new(position, rotate, name, number, width, height)
	local this = EnemyBase.new(position, rotate, name, number, width, height)
	
	-- メンバ変数

	-- メソッド定義
	-- 初期化
	this.EnemyBaseInitialize = this.Initialize
	
	-- 更新
	this.BaseUpdate = this.Update
	this.Update = function(self, deltaTime)
		local addx, addy = self.MoveController.Calc(self.Rotate.z+90)
		self.Position.x = self.Position.x + addx
		self.Position.y = self.Position.y + addy
		LuaSetPosition(self.Name, self.Position.x, self.Position.y, self.Position.z)
		self.ExistCounter = self.ExistCounter + deltaTime
	end

	return this
end

