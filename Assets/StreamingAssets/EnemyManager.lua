--直接Unityには登録しないスクリプト。いわゆる、ライブラリ化した奴

-- クラス定義
EnemyManager = {}

-- シングルトン用定義
local _instance = nil
function EnemyManager.Instance() 
	if not _instance then
		_instance = EnemyManager
		--_instance:Initialize()
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

function EnemyManager:CreateNewSpawnController(spawnTable, maxWave)
	local inst = NewSpawnController.new()
	inst:Initialize(spawnTable, maxWave)
	self.SpawnController = inst
end

function EnemyManager:SetTimer(timer) 
	self.SpawnController:SetTimer(timer)
end

function EnemyManager:SetWaveCounter(waveCount) 
	self.SpawnController:SetWaveCounter(waveCount)
end

function EnemyManager:GetList() 
	return self.EnemyList
end

function EnemyManager:CreateEnemy(posx, posy, degree, enemyConfig) 
	local enemyName = enemyConfig.Name..self.EnemyCounter
	
	LuaLoadPrefabAfter("battlescene", enemyConfig.PrefabName, enemyName, "EnemyCharacterRoot")
	--local offsetx = (posx - (ScreenWidth/2)) / CanvasFactor
	--local offsety = (posy - (ScreenHeight/2)) / CanvasFactor
	local offsetx = (posx - (ScreenWidth/2))
	local offsety = (posy - (ScreenHeight/2))
	LuaFindObject(enemyName)
	LuaSetRotate(enemyName, 0, 0, degree)

	local moveController = nil
	if enemyConfig.MoveType:MoveType() == MoveTypeEnum.Straight then
		moveController = MoveControllerStraight.new()
	elseif enemyConfig.MoveType:MoveType() == MoveTypeEnum.SinCurve then
		moveController = MoveControllerSinCurve.new()
	elseif enemyConfig.MoveType:MoveType() == MoveTypeEnum.Circle then
		moveController = MoveControllerCircle.new()
	end
	moveController:Initialize(enemyConfig.MoveType)

	local enemy = nil

	if enemyConfig.EnemyType == EnemyTypeEnum.Normal then
		enemy = NormalEnemyCharacter.new(Vector3.new(offsetx, offsety, 0), Vector3.new(0, 0, degree), enemyName, self.EnemyCounter, enemyConfig.Width, enemyConfig.Height)
		enemy:Initialize(enemyConfig.NowHp, enemyConfig.MaxHp, enemyConfig.Attack)
		enemy:SetEXP(enemyConfig.EXP)
	elseif enemyConfig.EnemyType == EnemyTypeEnum.BulletShooter then
		enemy = EnemyShooter.new(Vector3.new(offsetx, offsety, 0), Vector3.new(0, 0, degree), enemyName, self.EnemyCounter, enemyConfig.Width, enemyConfig.Height)
		enemy:Initialize(enemyConfig.NowHp, enemyConfig.MaxHp, enemyConfig.Attack)
		enemy:SetEXP(enemyConfig.EXP)
		enemy = UtilityFunction.Instance().SetEmitter(enemy, enemyConfig.BulletEmitterList, enemyConfig.EquipBulletList, CharacterType.Enemy)
	end

	enemy:SetMoveController(moveController)
		
	self.EnemyCounter = self.EnemyCounter + 1
	table.insert(self.EnemyList, enemy)
	LuaSetPosition(enemy.Name, enemy.Position.x, enemy.Position.y, enemy.Position.z)

	return enemy
end

function EnemyManager:SetBuffAndInitializeParameter(number, buffMoveSpeed, buffAttack, buffHp)
	local enemyCount = #self.EnemyList
	for i = 1 , enemyCount do
		local enemyNumber = self.EnemyList[i]:GetNumber()
		if enemyNumber == number then
			self.EnemyList[i]:SetBuffMoveSpeed(buffMoveSpeed)
			self.EnemyList[i]:SetBuffAttack(buffAttack)
			self.EnemyList[i]:SetBuffMaxHp(buffHp)
			self.EnemyList[i]:InitializeParameter()
			break;
		end
	end
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

