--直接Unityには登録しないスクリプト。いわゆる、ライブラリ化した奴

-- クラス定義
-- 弾クラス
NormalBullet = {}

-- メソッド定義

-- コンストラクタ
function NormalBullet.new(position, rotate, name, number, width, height)
	local this = BulletBase.new(position, rotate, name, number, width, height)

	-- メンバ変数
	this.BulletType = BulletTypeEnum.Normal
	
	-- メソッド定義
	-- 更新
	this.BaseUpdate = this.Update
	this.Update = function(self, deltaTime)
		local addx, addy = self.MoveController:Calc(deltaTime, self.Rotate.z+90)
		self.Position.x = self.Position.x + addx
		self.Position.y = self.Position.y + addy
		LuaSetPosition(self.Name, self.Position.x, self.Position.y, self.Position.z)
		self.ExistCounter = self.ExistCounter + deltaTime
	end
	
	-- メタテーブルセット
	--return setmetatable(this, {__index = NormalBullet})
	return this
end

