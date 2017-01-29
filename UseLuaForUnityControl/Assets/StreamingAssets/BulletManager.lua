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
		--_instance:Initialize()
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
	
	self.PlayerBulletCanShootList = {}
	self.PlayerBulletNowShooting = {}
	
	self.EnemyBulletCanShootList = {}
	self.EnemyBulletNowShooting = {}
end

function BulletManager:GetPlayerBulletList() 
	return self.PlayerBulletList
end

function BulletManager:GetEnemyBulletList() 
	return self.EnemyBulletList
end

--function BulletManager:CreateBulletTest(skillTable, characterType)
--	local prefabNameList = {}
--	local bulletList = skillTable[SkillTypeEnum.Bullet]
--
--	for i = 1, #bulletList do
--		local bulletData = bulletList[i]
--		local bulletConfigList = bulletData.EquipBulletList
--		local bulletConfig = bulletConfigList[1]
--		local prefabName = bulletConfig.PrefabName
--		table.insert(prefabNameList, prefabName)
--	end
--	
--	local dup ={};
--	local outputList = {};  
--	for i,v in pairs(prefabNameList) do
--		if(outputList[v] ~= nil) then
--			table.insert(dup, v);
--		end
--		outputList[v] = i;
--	end
--	
--	
--	for i,v in pairs(outputList) do
--		local prefabName = i
--		LuaUnityDebugLog(prefabName)
--		self.PlayerBulletCanShootList[prefabName] = {}
--		self.PlayerBulletNowShooting[prefabName] = {}
--	end
--
--
--	for i,v in pairs(outputList) do
--		local prefabName = i
--		--for j = 1, 500 do
--		for j = 1, 10 do
--			local name = "BulletObject"..self.BulletCounter
--			LuaLoadPrefabAfter(prefabName, name, "PlayerBulletRoot")
--			LuaSetActive(name, false)
--			self.BulletCounter = self.BulletCounter + 1
--			table.insert(self.PlayerBulletCanShootList[prefabName], name);
--		end
--	end
--	
--end

function BulletManager:CreateBulletTest(prefabName, characterType)
	if characterType == CharacterType.Player then
		self.PlayerBulletCanShootList[prefabName] = {}
		self.PlayerBulletNowShooting[prefabName] = {}
	
		for j = 1, 500 do
			local name = "BulletObject"..self.BulletCounter
			LuaLoadPrefabAfter(prefabName, name, "PlayerBulletRoot")
			LuaSetActive(name, false)
			self.BulletCounter = self.BulletCounter + 1
			table.insert(self.PlayerBulletCanShootList[prefabName], name);
		end
	elseif characterType == CharacterType.Enemy then
		self.EnemyBulletCanShootList[prefabName] = {}
		self.EnemyBulletNowShooting[prefabName] = {}

		for j = 1, 100 do
			local name = "BulletObject"..self.BulletCounter
			LuaLoadPrefabAfter(prefabName, name, "PlayerBulletRoot")
			LuaSetActive(name, false)
			self.BulletCounter = self.BulletCounter + 1
			table.insert(self.EnemyBulletCanShootList[prefabName], name);
		end
	end

end

--・おｋ、定義をはっきりさせる
--・Unity上のオブジェクトと関連しているのを、実体オブジェクト
--・Lua側で、処理に使っている弾情報を、弾オブジェクト
--としよう
--
--・実態オブジェクトは、マガジンリストと発射済みリストを行き来させる
--・弾オブジェクトは、その都度必要になる情報が事なるので、発射する時に新規で作っては削除する
--	⇒まぁこれも、処理のネックになりそうだったら、プールしておく方向に切り替える
--
--・弾を撃つ時に
--	・オブジェクトを
--	・オブジェクトが有効な物を取得
--		⇒有効無効の判断はどうする？
--	・取得した物を発射
--		⇒座標と角度と弾の属性とキャラタイプ等
--	・オブジェクトを

function BulletManager:ShootBulletTest(posx, posy, degree, bulletConfig, characterType)
	local canList = nil
	local nowList = nil
	if characterType == CharacterType.Player then
		canList = self.PlayerBulletCanShootList
		nowList = self.PlayerBulletNowShooting
	elseif characterType == CharacterType.Enemy then
		canList = self.EnemyBulletCanShootList
		nowList = self.EnemyBulletNowShooting
	end
		
	self:LocalShootBulletTest(posx, posy, degree, bulletConfig, characterType, canList, nowList)
end

function BulletManager:LocalShootBulletTest(posx, posy, degree, bulletConfig, characterType, canShootingList, nowShootingList)
	local prefabName = bulletConfig.PrefabName
	if #canShootingList[prefabName] == 0 then
		return
	end

	local name = table.remove(canShootingList[prefabName], 1)
	table.insert(nowShootingList[prefabName], name)

	local moveController = nil
	if bulletConfig.MoveType:MoveType() == MoveTypeEnum.Straight then
		moveController = MoveControllerStraight.new()
	elseif bulletConfig.MoveType:MoveType() == MoveTypeEnum.SinCurve then
		moveController = MoveControllerSinCurve.new()
	elseif bulletConfig.MoveType:MoveType() == MoveTypeEnum.Homing then
		moveController = MoveControllerHoming.new()
	end
	moveController:Initialize(bulletConfig.MoveType)--movespeed。後から設定しなおす
	
	local bullet = nil
	if bulletConfig.BulletType == BulletTypeEnum.Normal then
		bullet = NormalBullet.new(Vector3.new(posx, posy, 0), Vector3.new(0, 0, degree), name, self.BulletCounter, bulletConfig.Width, bulletConfig.Height)
		bullet:Initialize(bulletConfig.NowHp, bulletConfig.MaxHp, bulletConfig.Attack, bulletConfig.ExistTime, bulletConfig)
	elseif bulletConfig.BulletType == BulletTypeEnum.UseTargetPosition then
		bullet = HomingBullet.new(Vector3.new(posx, posy, 0), Vector3.new(0, 0, degree), name, self.BulletCounter, bulletConfig.Width, bulletConfig.Height)
		bullet:Initialize(bulletConfig.NowHp, bulletConfig.MaxHp, bulletConfig.Attack, bulletConfig.ExistTime, bulletConfig)
	end

	bullet:SetMoveController(moveController)
	self:AddBulletList(bullet, characterType) 

	--一瞬、前の弾が消えた所に表示されるので、座標をリセットする
	--ここでやるのが正しいのか若干疑問が残る
	LuaSetPosition(name, posx, posy, 0)
	LuaSetRotate(name, 0, 0, degree)
	LuaSetActive(name, true)
end



function BulletManager:CreateBullet(posx, posy, degree, bulletConfig, characterType)
	local name = "BulletObject"..self.BulletCounter
	LuaLoadPrefabAfter(bulletConfig.PrefabName, name, "PlayerBulletRoot")
	LuaFindObject(name)
	LuaSetPosition(name, posx, posy, 0)
	LuaSetRotate(name, 0, 0, degree)
	
	local moveController = nil
	if bulletConfig.MoveType:MoveType() == MoveTypeEnum.Straight then
		moveController = MoveControllerStraight.new()
	elseif bulletConfig.MoveType:MoveType() == MoveTypeEnum.SinCurve then
		moveController = MoveControllerSinCurve.new()
	elseif bulletConfig.MoveType:MoveType() == MoveTypeEnum.Homing then
		moveController = MoveControllerHoming.new()
	end
	moveController:Initialize(bulletConfig.MoveType)--movespeed。後から設定しなおす
	
	local bullet = nil
	if bulletConfig.BulletType == BulletTypeEnum.Normal then
		bullet = NormalBullet.new(Vector3.new(posx, posy, 0), Vector3.new(0, 0, degree), name, self.BulletCounter, bulletConfig.Width, bulletConfig.Height)
		bullet:Initialize(bulletConfig.NowHp, bulletConfig.MaxHp, bulletConfig.Attack, bulletConfig.ExistTime) --this.Initialize = function(self, nowHp, maxHp, attack, existTime)
	elseif bulletConfig.BulletType == BulletTypeEnum.UseTargetPosition then
		bullet = HomingBullet.new(Vector3.new(posx, posy, 0), Vector3.new(0, 0, degree), name, self.BulletCounter, bulletConfig.Width, bulletConfig.Height)
		bullet:Initialize(bulletConfig.NowHp, bulletConfig.MaxHp, bulletConfig.Attack, bulletConfig.ExistTime) --this.Initialize = function(self, nowHp, maxHp, attack, existTime)
	end

	bullet:SetMoveController(moveController)

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
	
	self:CheckBulletExist(self.PlayerBulletList, self.PlayerBulletNowShooting, self.PlayerBulletCanShootList)
	self:CheckBulletExist(self.EnemyBulletList, self.EnemyBulletNowShooting, self.EnemyBulletCanShootList)
	
	self:SetTargetPosition(self.PlayerBulletList) 
	self:SetTargetPosition(self.EnemyBulletList) 
end

function BulletManager:SetTargetPosition(list) 
	for i = 1, #list do
		bullet = list[i]
		if bullet:GetBulletType() == BulletTypeEnum.UseTargetPosition then
			if bullet:GetTarget() == nil or bullet:GetTarget():IsAlive() == false then
				if bullet:GetBulletType() == BulletTypeEnum.UseTargetPosition then
					bulletPosition = bullet:GetPosition()
					enemyList = EnemyManager:GetList()
					if #enemyList == 0 then
					else
						enemy = enemyList[1]
						enemyPosition = enemy:GetPosition()
						posx = enemyPosition.x - bulletPosition.x
						posy = enemyPosition.y - bulletPosition.y
						length = math.sqrt((posx*posx)+(posy*posy))
						nearLength = length
						nearEnemy = enemy
						for j = 2, #enemyList do
							enemy = enemyList[j]
							enemyPosition = enemy:GetPosition()
							posx = enemyPosition.x - bulletPosition.x
							posy = enemyPosition.y - bulletPosition.y
							length = math.sqrt((posx*posx)+(posy*posy))
							if length < nearLength then
								nearLength = length
								nearEnemy = enemy
							end
						end
						bullet:SetTarget(nearEnemy)
					end
				end
			else
			end
		end
	end
end

function BulletManager:CheckBulletExist(list, nowShootingList, canShootingList) 
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
			LuaSetActive(bullet:GetName(), false)
			local bulletConfig = bullet:GetBulletConfig()
			local name = table.remove(nowShootingList[bulletConfig.PrefabName], 1)
			table.insert(canShootingList[bulletConfig.PrefabName], name)
			table.remove(list, index)
		end
	end
end

function BulletManager:RemoveDeadObject()
	self:LocalRemoveDeadObject(self.PlayerBulletList, self.PlayerBulletNowShooting, self.PlayerBulletCanShootList)
	self:LocalRemoveDeadObject(self.EnemyBulletList, self.EnemyBulletNowShooting, self.EnemyBulletCanShootList)
end

function BulletManager:LocalRemoveDeadObject(list, nowShootingList, canShootingList)
	local index = 1
	while true do
		if index <= #list then
			local obj = list[index]
			if obj:IsAlive() == false then
				LuaSetActive(obj:GetName(), false)
				local bulletConfig = obj:GetBulletConfig()
				local name = table.remove(nowShootingList[bulletConfig.PrefabName], 1)
				table.insert(canShootingList[bulletConfig.PrefabName], name)
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

function BulletManager.LocalRelease(list)
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
