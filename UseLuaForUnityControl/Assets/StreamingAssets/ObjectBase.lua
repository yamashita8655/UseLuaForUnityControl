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
		NowHp = 0,
		MaxHp = 0,
	}

	-- メソッド定義
	-- 初期化
	this.Initialize = function(self, nowHp, maxHp)
		self.NowHp = nowHp
		self.MaxHp = maxHp
	end
	
	-- 現在HPの加減算
	this.AddNowHp = function(self, addValue)
		self.NowHp = self.NowHp + addValue
		if self.NowHp < 0 then
			self.NowHp = 0
		end
		if self.NowHp > self.MaxHp then
			self.NowHp = self.MaxHp
		end
	end
	
	-- 現在HPの直接値指定
	this.SetNowHp = function(self, value)
		self.NowHp = value
		if self.NowHp < 0 then
			self.NowHp = 0
		end
		if self.NowHp > self.MaxHp then
			self.NowHp = self.MaxHp
		end
	end
	
	-- 最大HPの加減算
	this.AddMaxHp = function(self, addValue)
		if addValue > 0 then
			self.NowHp = self.NowHp + addValue
		end
		self.MaxHp = self.MaxHp + addValue
		if self.MaxHp <= 0 then
			self.MaxHp = 1
		end
		if self.NowHp > self.MaxHp then
			self.NowHp = self.MaxHp
		end
	end
	
	-- 最大HPの直接値指定
	this.SetMaxHp = function(self, value)
		if value > self.MaxHp then
			diffValue = value - self.MaxHp
			self.NowHp = self.NowHp + diffValue
		end
		self.MaxHp = value
		if self.MaxHp <= 0 then
			self.MaxHp = 1
		end
		if self.NowHp > self.MaxHp then
			self.NowHp = self.MaxHp
		end
	end

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
	this.IsAlive = function(self) 
		local isAlive = true
		-- HPが0以下だったら、いる
		if self.NowHp <= 0 then
			isAlive = false
		end
		return isAlive
	end

	-- メタテーブルセット
	--return setmetatable(this, {__index = ObjectBase})
	return this
end

