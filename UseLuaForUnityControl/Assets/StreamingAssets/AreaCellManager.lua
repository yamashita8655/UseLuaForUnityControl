--直接Unityには登録しないスクリプト。いわゆる、ライブラリ化した奴

-- クラス定義
AreaCellManager = {}

-- シングルトン用定義
local _instance = nil
function AreaCellManager.Instance() 
	if not _instance then
		_instance = AreaCellManager
		--_instance:Initialize()
		--setmetatable(_instance, { __index = AreaCellManager })
	end

	return _instance
end

-- メソッド定義
--function .Initialize(self)と同じ 
function AreaCellManager:Initialize() 
	self.Width = 1920
	self.Height = 1920
	self.CellWidth = 128
	self.CellHeight = 128
	self.XCutNumber = self.Width/self.CellWidth
	self.YCutNumber = self.Height/self.CellHeight
	self.CheckBumpList = {}

	local counter = 0
	for i = 1, self.XCutNumber do
		for j = 1, self.YCutNumber do
			local obj = CheckBumpObject.new()
			obj:Initialize(counter)
			table.insert(self.CheckBumpList, obj)
			counter = counter + 1
		end
	end
end

function AreaCellManager:Clear() 
	LuaUnityDebugLog("BumpList"..#self.CheckBumpList)
	for i = 1, #self.CheckBumpList do
		self.CheckBumpList[i]:Clear()
	end
end

function AreaCellManager:GetBumpList() 
	return self.CheckBumpList
end

function AreaCellManager:AddPlayerBullet(bullet, cellIndex) 
	self.CheckBumpList[cellIndex]:AddPlayerBullet(bullet)
end

function AreaCellManager:AddEnemyBullet(bullet, cellIndex) 
	self.CheckBumpList[cellIndex]:AddEnemyBullet(bullet)
end

function AreaCellManager:AddEnemy(enemy, cellIndex) 
	self.CheckBumpList[cellIndex]:AddEnemy(enemy)
end

function AreaCellManager:AddPlayer(player, cellIndex) 
	self.CheckBumpList[cellIndex]:AddPlayer(player)
end

function AreaCellManager:GetCellNumber(object) 

	local position = object:GetPosition()
	local x = position.x
	local y = position.y
	local width, height = object:GetSize()
	local cellNumberList = {}

	local CalcCellNumber = function(x, y)
		local cellNumber = 0
		if x < -self.Width/2 or x > self.Width/2 then
			return -1
		end
		
		if y < -self.Height/2 or y > self.Height/2 then
			return -1
		end

		x = x + self.Width/2
		y = y + self.Height/2
		cellNumber = math.floor(x/self.CellWidth) + math.floor(y/self.CellHeight)*self.XCutNumber
		cellNumber = cellNumber + 1--配列が1から始まるので、その補正
		return cellNumber
	end

	local TL_x = x-width/2
	local TL_y = y+height/2
	local TL_cellNumber = CalcCellNumber(TL_x, TL_y)
	table.insert(cellNumberList, TL_cellNumber)
	
	local TR_x = x+width/2
	local TR_y = y+height/2
	local TR_cellNumber = CalcCellNumber(TR_x, TR_y)
	table.insert(cellNumberList, TR_cellNumber)
	
	local BL_x = x+width/2
	local BL_y = y-height/2
	local BL_cellNumber = CalcCellNumber(BL_x, BL_y)
	table.insert(cellNumberList, BL_cellNumber)
	
	local BR_x = x+width/2
	local BR_y = y-height/2
	local BR_cellNumber = CalcCellNumber(BR_x, BR_y)
	table.insert(cellNumberList, BR_cellNumber)

	return cellNumberList
end

-- クラス定義
CheckBumpObject = {}

-- コンストラクタ
function CheckBumpObject.new()
	local this = {
		AreaNumber = 0,
		PlayerBulletList = {},
		EnemyBulletList = {},
		PlayerList = {},
		EnemyList = {},
	}
	
	this.Initialize = function(self, areaNumber)
		self.AreaNumber = areaNumber
	end
	
	this.Clear = function(self)
		self.PlayerBulletList = {}
		self.EnemyBulletList = {}
		self.PlayerList = {}
		self.EnemyList = {}
	end

	this.AddPlayerBullet = function(self, bullet)
		table.insert(self.PlayerBulletList, bullet)
	end
	this.GetPlayerBullet = function(self)
		return self.PlayerBulletList
	end
	
	this.AddEnemyBullet = function(self, bullet)
		table.insert(self.EnemyBulletList, bullet)
	end
	this.GetEnemyBullet = function(self)
		return self.EnemyBulletList
	end
	
	this.AddPlayer = function(self, player)
		table.insert(self.PlayerList, player)
	end
	this.GetPlayer = function(self)
		return self.PlayerList[1]
	end
	
	this.AddEnemy = function(self, enemy)
		table.insert(self.EnemyList, enemy)
	end
	this.GetEnemy = function(self, enemy)
		return self.EnemyList
	end
	

	return this
end

