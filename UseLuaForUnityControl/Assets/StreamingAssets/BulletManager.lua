--����Unity�ɂ͓o�^���Ȃ��X�N���v�g�B������A���C�u�����������z

-- �N���X��`
BulletManager = {}

-- �V���O���g���p��`
local _instance = nil
function BulletManager.Instance() 
	if not _instance then
		_instance = BulletManager
		_instance:Initialize()
		setmetatable(_instance, { __index = BulletManager })
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
	--�e�̐������Ԃ��`�F�b�N���āA�폜���鎞�Ԃ���������AUnity���̃I�u�W�F�N�g�������ă��X�g�������
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

---- �R���X�g���N�^
--function BulletManager.new()
--	local obj = {
--		ShootCooltime = 0.0,
--		ShootInterval = 0.25,
--		BulletCounter = 0,
--		PlayerBulletList = {},
--	}
--  -- ���^�e�[�u���Z�b�g
--  return setmetatable(obj, {__index = BulletManager})
--end

-- �N���X��`
-- �e�N���X
BulletObject = {}

-- ���\�b�h��`
-- �e�̍��W�擾
function BulletObject:GetPosition() 
	return self.PositionX, self.PositionY, self.PositionZ
end
-- �e�̃T�C�Y�擾
function BulletObject:GetSize() 
	return self.Width, self.Height
end
-- �e�̉�]���퓗
function BulletObject:GetRotate() 
	return self.RotateX, self.RotateY, self.RotateZ
end
-- �e�̖��O�擾
function BulletObject:GetName() 
	return self.Name
end
-- �e�̏�ԍX�V
function BulletObject:Update(deltaTime)
	local radian = (self.RotateZ+90) / 180 * 3.1415
	local addx = math.cos(radian)
	local addy = math.sin(radian)

	self.PositionX = self.PositionX + addx*10
	self.PositionY = self.PositionY + addy*10
	
	LuaSetPosition(self.Name, self.PositionX, self.PositionY, self.PositionZ)

	self.ExistCounter = self.ExistCounter + deltaTime
end
-- �e�̐����m�F
function BulletObject:IsExist()
	local isExist = true
	if self.ExistCounter > self.ExistTime then
		isExist = false
	end

	return isExist
end

-- �R���X�g���N�^
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
  -- ���^�e�[�u���Z�b�g
  return setmetatable(obj, {__index = BulletObject})
end

