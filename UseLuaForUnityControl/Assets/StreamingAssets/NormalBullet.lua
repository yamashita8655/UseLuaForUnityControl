--直接Unityには登録しないスクリプト。いわゆる、ライブラリ化した奴

-- クラス定義
-- 弾クラス
NormalBullet = {}

-- メソッド定義

-- コンストラクタ
function NormalBullet.new(posx, posy, posz, rotx, roty, rotz, name, number, width, height)
	local this = BulletBase.new(posx, posy, posz, rotx, roty, rotz, name, number, width, height)

	-- メンバ変数
	
	-- メソッド定義
	-- 更新
	this.BaseUpdate = this.Update
	this.Update = function(self, deltaTime)
		local addx, addy = self.MoveController:Calc(self.RotateZ+90)
		self.PositionX = self.PositionX + addx
		self.PositionY = self.PositionY + addy
		LuaSetPosition(self.Name, self.PositionX, self.PositionY, self.PositionZ)
		self.ExistCounter = self.ExistCounter + deltaTime
	end
	
	-- メタテーブルセット
	--return setmetatable(this, {__index = NormalBullet})
	return this
end

