--直接Unityには登録しないスクリプト。いわゆる、ライブラリ化した奴

-- クラス定義
BulletManager = {}

-- メソッド定義
function BulletManager.Initialize(self) 
	self.ShootCooltime = 0.0
	self.ShootInterval = 0.25
	self.BulletCounter = 0
	self.PlayerBulletList = {}
end

function BulletManager.CreateBullet(touchx, touchy, degree, self) 
	if (ShootCooltime) >= ShootInterval then
		LuaLoadPrefabAfter("Prefabs/BulletObject", "BulletObject"..BulletCounter, "PlayerBulletRoot")
		LuaFindObject("BulletObject"..BulletCounter)
		LuaSetRotate("BulletObject"..BulletCounter, 0, 0, degree)
		--local bullet = BulletObject.new((touchx-ScreenWidth/2)/CanvasFactor, (touchy-ScreenHeight/2)/CanvasFactor, 0, 0, 0, degree, "BulletObject"..BulletCounter, BulletCounter, 1.0)
		local bullet = BulletObject.new(0, 0, 0, 0, 0, degree, "BulletObject"..BulletCounter, BulletCounter, 1.0)

		BulletCounter = BulletCounter + 1
		table.insert(PlayerBulletList, bullet)
		ShootCooltime = 0.0
	end
end

function BulletManager.Update(deltaTime, self) 
	ShootCooltime = ShootCooltime + deltaTime
	local playerBulletCount = #PlayerBulletList
	for i = 1 , playerBulletCount do
		PlayerBulletList[i].Update(PlayerBulletList[i], deltaTime)
	end
end

function BulletManager.CheckBulletExist(self) 
	--弾の生存期間をチェックして、削除する時間があったら、Unity側のオブジェクトを消してリストから消去
	index = 1
	while true do
		if index > #PlayerBulletList then
			break
		end

		bullet = PlayerBulletList[index]
		isExist = bullet.IsExist(bullet)
		if isExist then
			index = index + 1
		else
			LuaDestroyObject(bullet.GetName(bullet))
			table.remove(PlayerBulletList, index)
		end
	end
end

-- コンストラクタ
function BulletManager.new()
	local obj = {
		ShootCooltime = 0.0,
		ShootInterval = 0.25,
		BulletCounter = 0,
		PlayerBulletList = {},
	}
  -- メタテーブルセット
  return setmetatable(obj, {__index = BulletManager})
end

-- クラス定義
-- 弾クラス
BulletObject = {}

-- メソッド定義
-- 弾の座標取得
function BulletObject.GetPosition(self) 
	return self.PositionX, self.PositionY, self.PositionZ
end
-- 弾の回転率種痘
function BulletObject.GetRotate(self) 
	return self.RotateX, self.RotateY, self.RotateZ
end
-- 弾の名前取得
function BulletObject.GetName(self) 
	return self.Name
end
-- 弾の状態更新
function BulletObject.Update(self, deltaTime)
	local radian = (self.RotateZ+90) / 180 * 3.1415
	local addx = math.cos(radian)
	local addy = math.sin(radian)

	self.PositionX = self.PositionX + addx*5
	self.PositionY = self.PositionY + addy*5
	
	local name = self.Name
	LuaSetPosition(Name, self.PositionX, self.PositionY, self.PositionZ)

	self.ExistCounter = self.ExistCounter + deltaTime
end
-- 弾の生存確認
function BulletObject.IsExist(self)
	local isExist = true
	if self.ExistCounter > self.ExistTime then
		isExist = false
	end

	return isExist
end

-- コンストラクタ
function BulletObject.new(posx, posy, posz, rotx, roty, rotz, name, number, existTime)
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
		ExistCounter = 0.0
	}
  -- メタテーブルセット
  return setmetatable(obj, {__index = BulletObject})
end

