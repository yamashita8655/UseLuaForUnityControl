--����Unity�ɂ͓o�^���Ȃ��X�N���v�g�B������A���C�u�����������z

-- �N���X��`
BulletManager = {}

-- ���\�b�h��`
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
	--�e�̐������Ԃ��`�F�b�N���āA�폜���鎞�Ԃ���������AUnity���̃I�u�W�F�N�g�������ă��X�g�������
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

-- �R���X�g���N�^
function BulletManager.new()
	local obj = {
		ShootCooltime = 0.0,
		ShootInterval = 0.25,
		BulletCounter = 0,
		PlayerBulletList = {},
	}
  -- ���^�e�[�u���Z�b�g
  return setmetatable(obj, {__index = BulletManager})
end

-- �N���X��`
-- �e�N���X
BulletObject = {}

-- ���\�b�h��`
-- �e�̍��W�擾
function BulletObject.GetPosition(self) 
	return self.PositionX, self.PositionY, self.PositionZ
end
-- �e�̉�]���퓗
function BulletObject.GetRotate(self) 
	return self.RotateX, self.RotateY, self.RotateZ
end
-- �e�̖��O�擾
function BulletObject.GetName(self) 
	return self.Name
end
-- �e�̏�ԍX�V
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
-- �e�̐����m�F
function BulletObject.IsExist(self)
	local isExist = true
	if self.ExistCounter > self.ExistTime then
		isExist = false
	end

	return isExist
end

-- �R���X�g���N�^
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
  -- ���^�e�[�u���Z�b�g
  return setmetatable(obj, {__index = BulletObject})
end

