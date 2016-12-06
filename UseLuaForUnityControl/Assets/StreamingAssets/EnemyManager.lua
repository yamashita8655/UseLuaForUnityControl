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

function EnemyManager:CreateEnemy(posx, posy, degree, enemyConfig) 
	local enemyName = enemyConfig.Name..self.EnemyCounter
	
	LuaLoadPrefabAfter(enemyConfig.PrefabName, enemyName, "EnemyCharacterRoot")
	local offsetx = (posx - (ScreenWidth/2)) / CanvasFactor
	local offsety = (posy - (ScreenHeight/2)) / CanvasFactor
	LuaFindObject(enemyName)
	LuaSetRotate(enemyName, 0, 0, degree)

	local moveController = nil
	if enemyConfig.MoveType == MoveTypeEnum.Straight then
		moveController = MoveControllerStraight.new()
		moveController:Initialize(2)--movespeed。後から設定しなおす
	elseif enemyConfig.MoveType == MoveTypeEnum.SinCurve then
		moveController = MoveControllerSinCurve.new()
		moveController:Initialize(1, 1, 1)--self, sinCurveRotateValue, periodValue, moveSpeed。後からｒｙ
	else
		moveController = MoveControllerStraight.new()
		moveController:Initialize(2)--movespeed。後から設定しなおす
	end

	local enemy = nil

	if enemyConfig.EnemyType == EnemyTypeEnum.Normal then
		enemy = NormalEnemyCharacter.new(offsetx, offsety, 0, 0, 0, degree, enemyName, self.EnemyCounter, enemyConfig.Width, enemyConfig.Height)
	elseif enemyConfig.EnemyType == EnemyTypeEnum.BulletShooter then
		--enemy = SinCurveEnemy.new(offsetx, offsety, 0, 0, 0, degree, enemyName, self.EnemyCounter, enemyConfig.Width, enemyConfig.Height)
	else
		enemy = NormalEnemyCharacter.new(offsetx, offsety, 0, 0, 0, degree, enemyName, self.EnemyCounter, enemyConfig.Width, enemyConfig.Height)
	end

	enemy:Initialize(enemyConfig.NowHp, enemyConfig.MaxHp, enemyConfig.Attack)
	enemy:SetMoveController(moveController)
		
	--emitter = BulletEmitter.new()
	--emitter:Initialize(Vector2.new(offsetx, offsety), 0.25, Vector2.new(0, 0))
	--enemy:AddBulletEmitter(emitter)

	self.EnemyCounter = self.EnemyCounter + 1
	table.insert(self.EnemyList, enemy)
	LuaSetPosition(enemy.Name, enemy.PositionX, enemy.PositionY, enemy.PositionZ)
end

function EnemyManager:Update(deltaTime) 
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
