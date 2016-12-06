--直接Unityには登録しないスクリプト。いわゆる、ライブラリ化した奴
CharacterType = {
	Player = 0,
	Enemy = 1,
}

-- クラス定義
BulletManager = {}

-- シングルトン用定義
local _instance = nil
function BulletManager.Instance() 
	if not _instance then
		_instance = BulletManager
		_instance:Initialize()
		--setmetatable(_instance, { __index = BulletManager })
	end

	return _instance
end

-- メソッド定義
--function BulletManager.Initialize(self)と同じ 
function BulletManager:Initialize() 
	self.BulletCounter = 0
	self.PlayerBulletList = {}
	self.EnemyBulletList = {}
end

function BulletManager:GetPlayerBulletList() 
	return self.PlayerBulletList
end

function BulletManager:GetEnemyBulletList() 
	return self.EnemyBulletList
end

function BulletManager:CreateNormalBullet(posx, posy, degree, characterType)
	LuaLoadPrefabAfter("Prefabs/BulletObject", "BulletObject"..self.BulletCounter, "PlayerBulletRoot")
	LuaFindObject("BulletObject"..self.BulletCounter)
	LuaSetRotate("BulletObject"..self.BulletCounter, 0, 0, degree)
	
	--local moveController = nil
	--if bulletConfig.MoveType == MoveTypeEnum.Straight then
	--	moveController = MoveControllerStraight.new()
	--	moveController:Initialize(5)--movespeed。後から設定しなおす
	--elseif bulletConfig.MoveType == MoveTypeEnum.SinCurve then
	--	moveController = MoveControllerSinCurve.new()
	--	moveController:Initialize(1, 1, 1)--self, sinCurveRotateValue, periodValue, moveSpeed。後からｒｙ
	--else
	--	moveController = MoveControllerStraight.new()
	--	moveController:Initialize(5)--movespeed。後から設定しなおす
	--end
	local moveController = nil
	moveController = MoveControllerStraight.new()
	moveController:Initialize(5)--movespeed。後から設定しなおす
	
	--local bullet = NormalBullet.new(posx, posy, 0, 0, 0, degree, "BulletObject"..self.BulletCounter, self.BulletCounter, 2.0, 32, 32) 
	local bullet = NormalBullet.new(posx, posy, 0, 0, 0, degree, "BulletObject"..self.BulletCounter, self.BulletCounter, 32, 32)
	bullet:Initialize(1, 1, 1, 3)
	bullet:SetMoveController(moveController)

	self.BulletCounter = self.BulletCounter + 1
	self:AddBulletList(bullet, characterType) 
end

function BulletManager:CreateSpeedBullet(posx, posy, degree, characterType) 
	LuaLoadPrefabAfter("Prefabs/BulletObject", "BulletObject"..self.BulletCounter, "PlayerBulletRoot")
	LuaFindObject("BulletObject"..self.BulletCounter)
	LuaSetRotate("BulletObject"..self.BulletCounter, 0, 0, degree)
	
	local bullet = SpeedBullet.new(posx, posy, 0, 0, 0, degree, "BulletObject"..self.BulletCounter, self.BulletCounter, 32, 32)
	bullet:Initialize(1, 1, 1)

	self.BulletCounter = self.BulletCounter + 1
	self:AddBulletList(bullet, characterType) 
end

function BulletManager:AddBulletList(bullet, characterType) 
	if characterType == CharacterType.Player then
		table.insert(self.PlayerBulletList, bullet)
	elseif characterType == CharacterType.Enemy then
		table.insert(self.EnemyBulletList, bullet)
	end
end

function BulletManager:Update(deltaTime) 
	local playerBulletCount = #self.PlayerBulletList
	for i = 1 , playerBulletCount do
		self.PlayerBulletList[i]:Update(deltaTime)
	end
	
	local enemyBulletCount = #self.EnemyBulletList
	for i = 1 , enemyBulletCount do
		self.EnemyBulletList[i]:Update(deltaTime)
	end
	
	self:CheckBulletExist(self.PlayerBulletList) 
	self:CheckBulletExist(self.EnemyBulletList) 
end

function BulletManager:CheckBulletExist(list) 
	--弾の生存期間をチェックして、削除する時間があったら、Unity側のオブジェクトを消してリストから消去
	local index = 1
	while true do
		if index > #list then
			break
		end

		local bullet = list[index]
		local IsAlive = bullet:IsAlive()
		if IsAlive then
			index = index + 1
		else
			LuaDestroyObject(bullet:GetName())
			table.remove(list, index)
		end
	end
end

function BulletManager:RemoveDeadObject()
	self:LocalRemoveDeadObject(self.PlayerBulletList)
	self:LocalRemoveDeadObject(self.EnemyBulletList)
end

function BulletManager:LocalRemoveDeadObject(list)
	local index = 1
	while true do
		if index <= #list then
			local obj = list[index]
			if obj:IsAlive() == false then
				LuaDestroyObject(obj:GetName())
				table.remove(list, index)
			else
				index = index + 1
			end
		else
			break
		end
	end
end

function BulletManager:Release()
	self.LocalRelease(self.PlayerBulletList)
	self.LocalRelease(self.EnemyBulletList)
end

function BulletManager:LocalRelease(list)
	local index = 1
	while true do
		if index <= #list then
			local obj = list[index]
			LuaDestroyObject(obj:GetName())
			table.remove(list, index)
		else
			break
		end
	end
end
