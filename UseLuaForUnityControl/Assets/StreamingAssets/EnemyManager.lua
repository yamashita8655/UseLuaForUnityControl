--直接Unityには登録しないスクリプト。いわゆる、ライブラリ化した奴

-- クラス定義
EnemyManager = {}

-- シングルトン用定義
local _instance = nil
function EnemyManager.Instance() 
	if not _instance then
		_instance = EnemyManager
		_instance:Initialize()
		--setmetatable(_instance, { __index = EnemyManager })
	end

	return _instance
end

-- メソッド定義
--function EnemyManager.Initialize(self)と同じ 
function EnemyManager:Initialize() 
	self.EnemyCounter = 0
	self.EnemyList = {}
	self.EnemySpawnTimer = 1.0
	self.EnemySpawnCounter = 0.0
	self.SpawnController = nil
end

function EnemyManager:CreateSpawnController(spawnTable) 
	local inst = SpawnController.new()
	inst:Initialize(spawnTable)
	self.SpawnController = inst
end

function EnemyManager:GetList() 
	return self.EnemyList
end

function EnemyManager:CreateEnemy(posx, posy, degree) 
	local enemyConfig = EnemyStraight
	local enemyName = enemyConfig.Name..self.EnemyCounter
	
	LuaLoadPrefabAfter(enemyConfig.PrefabName, enemyName, "EnemyCharacterRoot")
	local offsetx = (posx - (ScreenWidth/2)) / CanvasFactor
	local offsety = (posy - (ScreenHeight/2)) / CanvasFactor
	LuaFindObject(enemyName)
	LuaSetRotate(enemyName, 0, 0, degree)
	local enemy = NormalEnemyCharacter.new(offsetx, offsety, 0, 0, 0, degree, enemyName, self.EnemyCounter, enemyConfig.Width, enemyConfig.Height)
	enemy:Initialize(enemyConfig.NowHp, enemyConfig.MaxHp, enemyConfig.Attack)

	self.EnemyCounter = self.EnemyCounter + 1
	table.insert(self.EnemyList, enemy)
	LuaSetPosition(enemy.Name, enemy.PositionX, enemy.PositionY, enemy.PositionZ)
end

function EnemyManager:Update(deltaTime) 
	--self.EnemySpawnCounter = self.EnemySpawnCounter + deltaTime
	--if self.EnemySpawnCounter >= self.EnemySpawnTimer then
	--	spawnX = math.random(-600, 600)
	--	spawnY = math.random(-300, 300)
	--	local radian = math.atan2(spawnY, spawnX)
	--	local degree = radian * 180 / 3.1415
	--	self:CreateEnemy(spawnX+(ScreenWidth/2), spawnY+(ScreenHeight/2), degree-90-180)
	--	self.EnemySpawnCounter = 0.0
	--end

	self.SpawnController:Update(deltaTime)
	
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
			if obj:IsAlive() == false then
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
