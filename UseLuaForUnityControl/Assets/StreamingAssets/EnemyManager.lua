--直接Unityには登録しないスクリプト。いわゆる、ライブラリ化した奴

-- クラス定義
EnemyManager = {}

-- シングルトン用定義
local _instance = nil
function EnemyManager.Instance() 
	if not _instance then
		_instance = EnemyManager
		_instance:Initialize()
		setmetatable(_instance, { __index = EnemyManager })
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

-- クラス定義
-- 敵クラス
EnemyObject = {}

-- メソッド定義
-- 敵の座標取得
function EnemyObject:GetPosition() 
	return self.PositionX, self.PositionY, self.PositionZ
end
-- 敵のサイズ取得
function EnemyObject:GetSize() 
	return self.Width, self.Height
end
-- 敵の回転率種痘
function EnemyObject:GetRotate() 
	return self.RotateX, self.RotateY, self.RotateZ
end
-- 敵の名前取得
function EnemyObject:GetName() 
	return self.Name
end
-- 敵の状態更新
function EnemyObject:Update(deltaTime)
	local radian = (self.RotateZ+90) / 180 * 3.1415
	local addx = math.cos(radian)
	local addy = math.sin(radian)

	self.PositionX = self.PositionX + addx*1
	self.PositionY = self.PositionY + addy*1
	
	LuaSetPosition(self.Name, self.PositionX, self.PositionY, self.PositionZ)
end

-- コンストラクタ
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
  -- メタテーブルセット
  return setmetatable(obj, {__index = EnemyObject})
end

