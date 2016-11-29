--����Unity�ɂ͓o�^���Ȃ��X�N���v�g�B������A���C�u�����������z

-- �N���X��`
BulletManager = {}

-- �V���O���g���p��`
local _instance = nil
function BulletManager.Instance() 
	if not _instance then
		_instance = BulletManager
		_instance:Initialize()
		--setmetatable(_instance, { __index = BulletManager })
	end

	return _instance
end

-- ���\�b�h��`
--function BulletManager.Initialize(self)�Ɠ��� 
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
	--�e�̐������Ԃ��`�F�b�N���āA�폜���鎞�Ԃ���������AUnity���̃I�u�W�F�N�g�������ă��X�g�������
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

