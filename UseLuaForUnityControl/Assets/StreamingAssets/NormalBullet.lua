--直接Unityには登録しないスクリプト。いわゆる、ライブラリ化した奴

-- クラス定義
-- 弾クラス
NormalBullet = {}

-- メソッド定義

-- コンストラクタ
function NormalBullet.new(posx, posy, posz, rotx, roty, rotz, name, number, width, height)
	local this = BulletBase.new(posx, posy, posz, rotx, roty, rotz, name, number, width, height)

	-- メンバ変数
	this.ExistTime = 1.0
	this.MoveSpeed = 5.0
	
	-- メソッド定義
	-- 更新
	this.BaseUpdate = this.Update
	this.Update = function(self, deltaTime)
		local radian = (self.RotateZ+90) / 180 * 3.1415
		local addx = math.cos(radian)
		local addy = math.sin(radian)

		self.PositionX = self.PositionX + addx*self.MoveSpeed
		self.PositionY = self.PositionY + addy*self.MoveSpeed
		
		LuaSetPosition(self.Name, self.PositionX, self.PositionY, self.PositionZ)

		self.ExistCounter = self.ExistCounter + deltaTime
	end
	
	-- メタテーブルセット
	--return setmetatable(this, {__index = NormalBullet})
	return this
end

