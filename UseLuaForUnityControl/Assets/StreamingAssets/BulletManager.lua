--直接Unityには登録しないスクリプト。いわゆる、ライブラリ化した奴

-- クラス定義
BulletManager = {}

-- シングルトン用定義
local _instance = nil
function BulletManager.Instance() 
	if not _instance then
		_instance = BulletManager
		_instance:Initialize()
		--setmetatable(_instance, { __index = BulletManager })
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

function BulletManager:CreateNormalBullet(touchx, touchy, degree) 
	if (self.ShootCooltime) >= self.ShootInterval then
		LuaLoadPrefabAfter("Prefabs/BulletObject", "BulletObject"..self.BulletCounter, "PlayerBulletRoot")
		LuaFindObject("BulletObject"..self.BulletCounter)
		LuaSetRotate("BulletObject"..self.BulletCounter, 0, 0, degree)
		
		--local bullet = BulletObject.new(0, 0, 0, 0, 0, degree, "BulletObject"..self.BulletCounter, self.BulletCounter, 2.0, 32, 32)
		local bullet = NormalBullet.new(0, 0, 0, 0, 0, degree, "BulletObject"..self.BulletCounter, self.BulletCounter, 32, 32)

		self.BulletCounter = self.BulletCounter + 1
		table.insert(self.PlayerBulletList, bullet)
		self.ShootCooltime = 0.0
	end
end

function BulletManager:CreateSpeedBullet(touchx, touchy, degree) 
	if (self.ShootCooltime) >= self.ShootInterval then
		LuaLoadPrefabAfter("Prefabs/BulletObject", "BulletObject"..self.BulletCounter, "PlayerBulletRoot")
		LuaFindObject("BulletObject"..self.BulletCounter)
		LuaSetRotate("BulletObject"..self.BulletCounter, 0, 0, degree)
		
		--local bullet = BulletObject.new(0, 0, 0, 0, 0, degree, "BulletObject"..self.BulletCounter, self.BulletCounter, 2.0, 32, 32)
		local bullet = SpeedBullet.new(0, 0, 0, 0, 0, degree, "BulletObject"..self.BulletCounter, self.BulletCounter, 32, 32)

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
	local index = 1
	while true do
		if index > #self.PlayerBulletList then
			break
		end

		local bullet = self.PlayerBulletList[index]
		local isExist = bullet:IsExist()
		if isExist then
			index = index + 1
		else
			LuaDestroyObject(bullet:GetName())
			table.remove(self.PlayerBulletList, index)
		end
	end
end

function BulletManager:RemoveDeadObject()
	local index = 1
	while true do
		if index <= #self.PlayerBulletList then
			local obj = self.PlayerBulletList[index]
			if obj:GetDeadFlag() == true then
				LuaDestroyObject(obj:GetName())
				table.remove(self.PlayerBulletList, index)
			else
				index = index + 1
			end
		else
			break
		end
	end
end

