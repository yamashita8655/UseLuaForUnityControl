--直接Unityには登録しないスクリプト。いわゆる、ライブラリ化した奴

-- クラス定義
BulletManager = {}

-- シングルトン用定義
local _instance = nil
function BulletManager.Instance() 
	if not _instance then
		_instance = BulletManager
		_instance:Initialize()
		setmetatable(_instance, { __index = BulletManager })
	end

	return _instance
end

-- メソッド定義
--function BulletManager.Initialize(self)と同じ 
function BulletManager:Initialize() 
	self.ShootCooltime = 0.0
	self.ShootInterval = 0.25
	self.BulletCounter = 0
	self.PlayerBulletList = {}
end

function BulletManager:GetList() 
	return self.PlayerBulletList
end

function BulletManager:GetShootInterval() 
	return self.ShootInterval
end
function BulletManager:SetShootInterval(value) 
	self.ShootInterval = value
end

function BulletManager:CreateBullet(touchx, touchy, degree) 
	if (self.ShootCooltime) >= self.ShootInterval then
		LuaLoadPrefabAfter("Prefabs/BulletObject", "BulletObject"..self.BulletCounter, "PlayerBulletRoot")
		LuaFindObject("BulletObject"..self.BulletCounter)
		LuaSetRotate("BulletObject"..self.BulletCounter, 0, 0, degree)
		--local bullet = BulletObject.new((touchx-ScreenWidth/2)/CanvasFactor, (touchy-ScreenHeight/2)/CanvasFactor, 0, 0, 0, degree, "BulletObject"..BulletCounter, BulletCounter, 1.0)
		local bullet = BulletObject.new(0, 0, 0, 0, 0, degree, "BulletObject"..self.BulletCounter, self.BulletCounter, 2.0, 32, 32)

		self.BulletCounter = self.BulletCounter + 1
		table.insert(self.PlayerBulletList, bullet)
		self.ShootCooltime = 0.0
	end
end

function BulletManager:Update(deltaTime) 
	self.ShootCooltime = self.ShootCooltime + deltaTime
	local playerBulletCount = #self.PlayerBulletList
	for i = 1 , playerBulletCount do
		self.PlayerBulletList[i]:Update(deltaTime)
	end
	
	self:CheckBulletExist() 
end

function BulletManager:CheckBulletExist() 
	--弾の生存期間をチェックして、削除する時間があったら、Unity側のオブジェクトを消してリストから消去
	index = 1
	while true do
		if index > #self.PlayerBulletList then
			break
		end

		bullet = self.PlayerBulletList[index]
		isExist = bullet:IsExist()
		if isExist then
			index = index + 1
		else
			LuaDestroyObject(bullet:GetName())
			table.remove(self.PlayerBulletList, index)
		end
	end
end

--return BulletManager

---- コンストラクタ
--function BulletManager.new()
--	local obj = {
--		ShootCooltime = 0.0,
--		ShootInterval = 0.25,
--		BulletCounter = 0,
--		PlayerBulletList = {},
--	}
--  -- メタテーブルセット
--  return setmetatable(obj, {__index = BulletManager})
--end

-- クラス定義
-- 弾クラス
BulletObject = {}

-- メソッド定義
-- 弾の座標取得
function BulletObject:GetPosition() 
	return self.PositionX, self.PositionY, self.PositionZ
end
-- 弾のサイズ取得
function BulletObject:GetSize() 
	return self.Width, self.Height
end
-- 弾の回転率種痘
function BulletObject:GetRotate() 
	return self.RotateX, self.RotateY, self.RotateZ
end
-- 弾の名前取得
function BulletObject:GetName() 
	return self.Name
end
-- 弾の状態更新
function BulletObject:Update(deltaTime)
	local radian = (self.RotateZ+90) / 180 * 3.1415
	local addx = math.cos(radian)
	local addy = math.sin(radian)

	self.PositionX = self.PositionX + addx*10
	self.PositionY = self.PositionY + addy*10
	
	LuaSetPosition(self.Name, self.PositionX, self.PositionY, self.PositionZ)

	self.ExistCounter = self.ExistCounter + deltaTime
end
-- 弾の生存確認
function BulletObject:IsExist()
	local isExist = true
	if self.ExistCounter > self.ExistTime then
		isExist = false
	end

	return isExist
end

-- コンストラクタ
function BulletObject.new(posx, posy, posz, rotx, roty, rotz, name, number, existTime, width, height)
	local obj = {
		PositionX = posx, 
		PositionY = posy,
		PositionZ = posz,
		RotateX = rotx, 
		RotateY = roty,
		RotateZ = rotz,
		Name = name,
		Number = number,
		ExistTime = existTime,
		Width = width,
		Height = height,
		ExistCounter = 0.0
	}
  -- メタテーブルセット
  return setmetatable(obj, {__index = BulletObject})
end

