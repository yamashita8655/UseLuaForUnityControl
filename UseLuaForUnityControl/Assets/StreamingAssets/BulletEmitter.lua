--直接Unityには登録しないスクリプト。いわゆる、ライブラリ化した奴

-- クラス定義
EmitterBase = {}

-- コンストラクタ
function EmitterBase.new()
	local this = {
		Position = Vector2.new(0, 0),
		ShootCooltime = 0.0,
		ShootInterval = 0.25,
		RotateOffset = 0,
		BulletConfig = {},
		ParentPosition = {},
		CharacterType = 0
	}
	
	-- メソッド定義
	-- 初期化
	this.Initialize = function(self, position, interval, rotateOffset, bulletConfig, parentPosition, characterType)
		self.Position = Vector2.new(position.x, position.y)
		self.ShootInterval = interval
		self.RotateOffset = rotateOffset
		self.BulletConfig = bulletConfig
		self.ParentPosition = parentPosition 
		self.CharacterType = characterType 
	end
	
	-- 更新
	this.Update = function(self, deltaTime)
		self.ShootCooltime = self.ShootCooltime + deltaTime
	end
	
	-- 弾の発射
	this.ShootBullet = function(self, degree)
		local canShoot = self:CanShootBullet()
		if canShoot then
			--BulletManager.Instance():CreateNormalBullet(self.Position.x+self.ParentPosition.x, self.Position.y+self.ParentPosition.y, degree, self.BulletConfig, self.CharacterType);
			--self:ResetBulletCooltime()
			BulletManager.Instance():CreateBullet(self.Position.x+self.ParentPosition.x, self.Position.y+self.ParentPosition.y, degree+self.RotateOffset, self.BulletConfig, self.CharacterType);
			self:ResetBulletCooltime()
		end
	end
	
	-- 弾のクールタイムが終わっているかどうか
	this.CanShootBullet = function(self)
		local canShoot = false
		if self.ShootCooltime > self.ShootInterval then
			canShoot = true
		end
		return canShoot
	end
	
	-- 弾のクールタイムリセット
	this.ResetBulletCooltime = function(self)
		self.ShootCooltime = 0.0
	end

	return this
end

-- クラス定義
-- 弾を発射するオブジェクト。概念的にはオプションみたいな物
BulletEmitter = {}

-- コンストラクタ
function BulletEmitter.new()
	local this = EmitterBase.new()
	this.OffsetRotate = offsetRotate

	this.UpdatePosition = function(self, radian, degree)
	end
	
	return this
end

-- クラス定義
-- 弾を発射するオブジェクト。指定の位置から、指定の位置を中心として衛星的な動きをする
BulletEmitterSatellite = {}

-- コンストラクタ
function BulletEmitterSatellite.new()
	local this = EmitterBase.new()
	this.SpawnPosition = Vector2.new(0, 0)
	this.CenterPosition = Vector2.new(0, 0)
	
	-- メソッド定義
	-- 初期化
	this.BaseInitialize = this.Initialize
	this.Initialize = function(self, position, interval, rotateOffset, bulletConfig, parentPosition, characterType, centerPosition)
		this:BaseInitialize(position, interval, rotateOffset, bulletConfig, parentPosition, characterType)
		-- 新たに作成しないと、参照なので、Positionを書き換えると、SpawnPositionの値も変わってしまう
		self.SpawnPosition = Vector2.new(position.x, position.y)
		self.CenterPosition = centerPosition
	end
	
	-- 更新
	this.BaseUpdate = this.Update
	this.Update = function(self, deltaTime)
		self.BaseUpdate(this, deltaTime)
	end
	
	-- タッチ、ドラッグがあった時、その向きにこのオブジェクト自身も追従させる
	this.UpdatePosition = function(self, radian, degree)
		-- 基本の座標は、オフセット量として使う
		-- また、その座標位置は、基本回転値を求める事にも使う
		local spawnx = self.SpawnPosition.x
		local spawny = self.SpawnPosition.y
		local baseRadian = math.atan2(spawny, spawnx)
		local basedegree = baseRadian * 180 / 3.1415
		
		-- オフセット距離を求める
		local xvalue = (self.SpawnPosition.x - self.CenterPosition.x)
		local yvalue = (self.SpawnPosition.y - self.CenterPosition.y)
		local offsetRange = math.sqrt((xvalue*xvalue) + (yvalue*yvalue))
		
		-- -90度補正の入ったラジアンが欲しいので、計算する
		local rawradian = (degree) / 180 * 3.1415
		local addx = math.cos(rawradian+baseRadian)
		local addy = math.sin(rawradian+baseRadian)
		self.Position.x = addx*offsetRange
		self.Position.y = addy*offsetRange
	end
	return this
end

