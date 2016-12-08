--直接Unityには登録しないスクリプト。いわゆる、ライブラリ化した奴

-- クラス定義
-- 弾クラス
HomingBullet = {}

-- メソッド定義

-- コンストラクタ
function HomingBullet.new(position, rotate, name, number, width, height)
	local this = BulletBase.new(position, rotate, name, number, width, height)

	-- メンバ変数
	this.BulletType = BulletTypeEnum.UseTargetPosition
	this.Target = nil
	
	-- メソッド定義

	-- 更新
	this.BaseUpdate = this.Update
	this.Update = function(self, deltaTime)
		local addx, addy = self.MoveController:Calc(deltaTime, self.Rotate.z+90, self.Position, self.Target)
		self.Position.x = self.Position.x + addx
		self.Position.y = self.Position.y + addy
		LuaSetPosition(self.Name, self.Position.x, self.Position.y, self.Position.z)
		self.ExistCounter = self.ExistCounter + deltaTime
	end
	
	-- ターゲット座標の更新
	this.SetTarget = function(self, target)
		self.Target = target
	end
	this.GetTarget = function(self)
		return self.Target
	end
	
	return this
end

