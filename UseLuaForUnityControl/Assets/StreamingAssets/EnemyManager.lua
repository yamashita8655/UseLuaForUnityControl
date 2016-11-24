--����Unity�ɂ͓o�^���Ȃ��X�N���v�g�B������A���C�u�����������z

-- �N���X��`
EnemyManager = {}

-- �V���O���g���p��`
local _instance = nil
function EnemyManager.Instance() 
	if not _instance then
		_instance = EnemyManager
		_instance:Initialize()
		setmetatable(_instance, { __index = EnemyManager })
	end

	return _instance
end

-- ���\�b�h��`
--function EnemyManager.Initialize(self)�Ɠ��� 
function EnemyManager:Initialize() 
	self.EnemyCounter = 0
	self.EnemyList = {}
end

function EnemyManager:GetList() 
	return self.EnemyList
end

function EnemyManager:CreateEnemy(posx, posy, degree) 
	LuaLoadPrefabAfter("Prefabs/EnemyCharacterObject", "EnemyCharacterObject"..self.EnemyCounter, "EnemyCharacterRoot")
	local offsetx = (posx - (ScreenWidth/2)) / CanvasFactor
	local offsety = (posy - (ScreenHeight/2)) / CanvasFactor
	LuaFindObject("EnemyCharacterObject"..self.EnemyCounter)
	LuaSetRotate("EnemyCharacterObject"..self.EnemyCounter, 0, 0, degree)
	local enemy = EnemyObject.new(offsetx, offsety, 0, 0, 0, degree, "EnemyCharacterObject"..self.EnemyCounter, self.EnemyCounter, 32, 32)

	self.EnemyCounter = self.EnemyCounter + 1
	table.insert(self.EnemyList, enemy)
	LuaSetPosition(enemy.Name, enemy.PositionX, enemy.PositionY, enemy.PositionZ)
end

function EnemyManager:Update(deltaTime) 
	local enemyCount = #self.EnemyList
	for i = 1 , enemyCount do
		self.EnemyList[i].Update(self.EnemyList[i], deltaTime)
	end
end

-- �N���X��`
-- �G�N���X
EnemyObject = {}

-- ���\�b�h��`
-- �G�̍��W�擾
function EnemyObject.GetPosition(self) 
	return self.PositionX, self.PositionY, self.PositionZ
end
-- �G�̉�]���퓗
function EnemyObject.GetRotate(self) 
	return self.RotateX, self.RotateY, self.RotateZ
end
-- �G�̖��O�擾
function EnemyObject.GetName(self) 
	return self.Name
end
-- �G�̏�ԍX�V
function EnemyObject.Update(self, deltaTime)
	local radian = (self.RotateZ+90) / 180 * 3.1415
	local addx = math.cos(radian)
	local addy = math.sin(radian)

	self.PositionX = self.PositionX + addx*5
	self.PositionY = self.PositionY + addy*5
	
	--LuaSetPosition(self.Name, self.PositionX, self.PositionY, self.PositionZ)
end

-- �R���X�g���N�^
function EnemyObject.new(posx, posy, posz, rotx, roty, rotz, name, number, width, height)
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
	}
  -- ���^�e�[�u���Z�b�g
  return setmetatable(obj, {__index = EnemyObject})
end

