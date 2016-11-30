--直接Unityには登録しないスクリプト。いわゆる、ライブラリ化した奴

-- クラス定義
-- 弾クラス
BulletBase = {}

-- メソッド定義

-- コンストラクタ
function BulletBase.new(posx, posy, posz, rotx, roty, rotz, name, number, width, height)
	local this = ObjectBase.new(posx, posy, posz, rotx, roty, rotz, name, number, width, height)
	
	-- メンバ変数
	this.ExistCounter = 0.0
	this.ExistTime = 0.0
	this.MoveSpeed = 0.0

	-- メソッド定義
	-- 弾の生存確認
	this.IsExist = function(self)
		local isExist = true
		if self.ExistCounter > self.ExistTime then
			isExist = false
		end
	
		return isExist
	end

	-- メタテーブルセット
	--return setmetatable(this, {__index = BulletBase})
	return this
end

