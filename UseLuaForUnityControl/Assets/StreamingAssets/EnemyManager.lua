--����Unity�ɂ͓o�^���Ȃ��X�N���v�g�B������A���C�u�����������z

-- �N���X��`
EnemyManager = {}

-- �V���O���g���p��`
local _instance = nil
function EnemyManager.Instance() 
	if not _instance then
		_instance = EnemyManager
		_instance:Initialize()
		--setmetatable(_instance, { __index = EnemyManager })
	end

	return _instance
end

-- ���\�b�h��`
--function EnemyManager.Initialize(self)�Ɠ��� 
function EnemyManager:Initialize() 
	self.EnemyCounter = 0
	self.EnemyList = {}
	self.EnemySpawnTimer = 1.0
	self.EnemySpawnCounter = 0.0
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
	local enemy = NormalEnemyCharacter.new(offsetx, offsety, 0, 0, 0, degree, "EnemyCharacterObject"..self.EnemyCounter, self.EnemyCounter, 32, 32)

	self.EnemyCounter = self.EnemyCounter + 1
	table.insert(self.EnemyList, enemy)
	LuaSetPosition(enemy.Name, enemy.PositionX, enemy.PositionY, enemy.PositionZ)
end

function EnemyManager:Update(deltaTime) 
	self.EnemySpawnCounter = self.EnemySpawnCounter + deltaTime
	if self.EnemySpawnCounter >= self.EnemySpawnTimer then
		spawnX = math.random(-600, 600)
		spawnY = math.random(-300, 300)
		local radian = math.atan2(spawnY, spawnX)
		local degree = radian * 180 / 3.1415
		self:CreateEnemy(spawnX+(ScreenWidth/2), spawnY+(ScreenHeight/2), degree-90-180)
		self.EnemySpawnCounter = 0.0
	end
	
	local enemyCount = #self.EnemyList
	for i = 1 , enemyCount do
		self.EnemyList[i]:Update(deltaTime)
	end
end

function EnemyManager:RemoveDeadObject()
	local index = 1
	while true do
		if index <= #self.EnemyList then
			local obj = self.EnemyList[index]
			if obj:GetDeadFlag() == true then
				LuaDestroyObject(obj:GetName())
				table.remove(self.EnemyList, index)
			else
				index = index + 1
			end
		else
			break
		end
	end
end

function EnemyManager:Release()
	local index = 1
	while true do
		if index <= #self.EnemyList then
			local obj = self.EnemyList[index]
			LuaDestroyObject(obj:GetName())
			table.remove(self.EnemyList, index)
		else
			break
		end
	end
end
