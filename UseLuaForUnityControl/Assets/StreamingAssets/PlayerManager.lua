--直接Unityには登録しないスクリプト。いわゆる、ライブラリ化した奴

-- クラス定義
PlayerManager = {}

-- シングルトン用定義
local _instance = nil
function PlayerManager.Instance() 
	if not _instance then
		_instance = PlayerManager
		--_instance:Initialize()
		-- このメタテーブル設定をすると
		-- self.PlayerCharacterInstance = nilはいけるが
		-- obj = self.PlayerCharacterInstanceが
		-- loop in gettable
		-- とエラーになる原因をきちんと理解するようにする
		--setmetatable(_instance, { __index = PlayerManager })
	end

	return _instance
end

-- メソッド定義
--function PlayerManager.Initialize(self)と同じ 
function PlayerManager:Initialize() 
	self.PlayerCharacterInstance = nil
end

function PlayerManager:SetRotate(rotatex, rotatey, rotatez) 
	self.PlayerCharacterInstance:SetRotate(rotatex, rotatey, rotatez)
	LuaSetRotate(self.PlayerCharacterInstance.Name, rotatex, rotatey, rotatez)
end

function PlayerManager:GetPlayer() 
	return self.PlayerCharacterInstance
end

function PlayerManager:CreatePlayer(playerDataConfig, posx, posy, degree) 
	if (self.PlayerCharacterInstance) then
	else
		LuaUnityDebugLog("charaCreate")
		local prefabName = playerDataConfig.PrefabName
		local name = playerDataConfig.Name
		local width = playerDataConfig.Width
		local height = playerDataConfig.Height
		local nowHp = playerDataConfig.NowHp
		local maxHp = playerDataConfig.MaxHp
		local bulletEmitterList = playerDataConfig.BulletEmitterList
		local equipBulletList = playerDataConfig.EquipBulletList
		local skillConfig = playerDataConfig.SkillConfig
		local skillDetailText = playerDataConfig.SkillDetailText

		LuaLoadPrefabAfter(prefabName, name, "PlayerCharacterRoot")
		local offsetx = (posx - (ScreenWidth/2)) / CanvasFactor
		local offsety = (posy - (ScreenHeight/2)) / CanvasFactor
		LuaFindObject(name)
		LuaSetRotate(name, 0, 0, degree)
		local player = PlayerCharacter.new(Vector3.new(offsetx, offsety, 0), Vector3.new(0, 0, degree), name, width, height)
		player:Initialize(nowHp, maxHp)
		player:SetSkillConfig(skillConfig)
		player:SetSkillDetailText(skillDetailText)
		--player = UtilityFunction.Instance().SetEmitter(player, bulletEmitterList, equipBulletList, CharacterType.Player)
		local skillTable = skillConfig:GetSkillTable()
		player = UtilityFunction.Instance().SetEmitter(player, skillTable[SkillTypeEnum.Emitter][1].BulletEmitterList, skillTable[SkillTypeEnum.Bullet][1].EquipBulletList, CharacterType.Player)

		self.PlayerCharacterInstance = player
		LuaSetPosition(player.Name, player.Position.x, player.Position.y, player.Position.z)
	end
end

function PlayerManager:Update(deltaTime) 
	self.PlayerCharacterInstance:Update(deltaTime)
end

function PlayerManager:OnMouseDown(touchx, touchy) 
	--local offsetx = touchx - (ScreenWidth/2)
	--local offsety = touchy - (ScreenHeight/2)
	local offsetx = (touchx - (ScreenWidth/2)) / CanvasFactor
	local offsety = (touchy - (ScreenHeight/2)) / CanvasFactor
	local radian = math.atan2(offsety, offsetx)
	local degree = radian * 180 / 3.1415
	
	self.PlayerCharacterInstance:UpdateSatelliteEmitterPosition(radian, degree-90)
	PlayerManager.Instance():SetRotate(0, 0, degree-90)
	self.PlayerCharacterInstance:ShootBullet(degree-90)

	-- TODO:test
	--local skillData = self.PlayerCharacterInstance:GetSkillConfig()
	--
	--local emitterLevel = skillData:GetSkillLevel(SkillTypeEnum.Emitter)
	--local emitterMaxLevel = skillData:GetMaxSkillLevel(SkillTypeEnum.Emitter)
	--local emitterNext = skillData:GetNextExp(SkillTypeEnum.Emitter)
	--
	--local bulletLevel = skillData:GetSkillLevel(SkillTypeEnum.Bullet)
	--local bulletMaxLevel = skillData:GetMaxSkillLevel(SkillTypeEnum.Bullet)
	--local bulletNext = skillData:GetNextExp(SkillTypeEnum.Bullet)
end

function PlayerManager:OnMouseDrag(touchx, touchy) 
	--local offsetx = touchx - (ScreenWidth/2)
	--local offsety = touchy - (ScreenHeight/2)
	local offsetx = (touchx - (ScreenWidth/2)) / CanvasFactor
	local offsety = (touchy - (ScreenHeight/2)) / CanvasFactor
	--local offsetx = (touchx - (ScreenWidth/2)) / CanvasFactor
	--local offsety = (touchy - (ScreenHeight/2+200)) / CanvasFactor
	local radian = math.atan2(offsety, offsetx)
	local degree = radian * 180 / 3.1415

	
	self.PlayerCharacterInstance:UpdateSatelliteEmitterPosition(radian, degree-90)
	PlayerManager.Instance():SetRotate(0, 0, degree-90)
	self.PlayerCharacterInstance:ShootBullet(degree-90)
end

function PlayerManager:Release() 
	LuaDestroyObject(self.PlayerCharacterInstance.Name)
	self.PlayerCharacterInstance = nil
end

