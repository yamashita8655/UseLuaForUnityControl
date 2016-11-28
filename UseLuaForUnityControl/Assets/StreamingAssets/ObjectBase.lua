--直接Unityには登録しないスクリプト。いわゆる、ライブラリ化した奴

-- クラス定義
ObjectBase = {}

-- コンストラクタ
function ObjectBase.new(posx, posy, posz, rotx, roty, rotz, name, number, width, height)
	local this = {
		PositionX = posx, 
		PositionY = posy,
		PositionZ = posz,
		RotateX = rotx, 
		RotateY = roty,
		RotateZ = rotz,
		Name = name,
		Number = number,
		Width = width,
		Height = height,
	}

	-- メソッド定義
	-- 座標取得
	this.GetPosition = function(self)
		return self.PositionX, self.PositionY, self.PositionZ
	end

	-- サイズ取得
	this.GetSize = function(self) 
		return self.Width, self.Height
	end

	-- 回転率取得
	this.GetRotate = function(self) 
		return self.RotateX, self.RotateY, self.RotateZ
	end

	-- 名前取得
	this.GetName = function(self) 
		return self.Name
	end

	-- メタテーブルセット
	return setmetatable(this, {__index = ObjectBase})
end

