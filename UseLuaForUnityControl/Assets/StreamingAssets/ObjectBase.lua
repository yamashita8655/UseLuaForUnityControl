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
		DeadFlag = false,
	}

	-- メソッド定義
	-- 座標取得
	this.GetPosition = function(self)
		return self.PositionX, self.PositionY, self.PositionZ
	end
	-- 座標設定
	this.SetPosition = function(self, positionx, positiony, positionz)
		self.PositionX = positionx
		self.PositionY = positiony
		self.PositionZ = positionz
	end

	-- サイズ取得
	this.GetSize = function(self) 
		return self.Width, self.Height
	end
	-- サイズ設定
	this.SetSize = function(self, width, height) 
		self.Width = width
		self.Height = height
	end

	-- 回転率取得
	this.GetRotate = function(self) 
		return self.RotateX, self.RotateY, self.RotateZ
	end
	-- 回転率設定
	this.SetRotate = function(self, rotatex, rotatey, rotatez) 
		self.RotateX = rotatex
		self.RotateY = rotatey
		self.RotateZ = rotatez
	end

	-- 名前取得
	this.GetName = function(self) 
		return self.Name
	end
	-- 名前設定
	this.SetName = function(self, name) 
		self.Name = name
	end
	
	-- 生存状態
	this.GetDeadFlag = function(self) 
		return self.DeadFlag
	end
	this.SetDeadFlag = function(self, isDead) 
		self.DeadFlag = isDead
	end

	-- メタテーブルセット
	return setmetatable(this, {__index = ObjectBase})
end

