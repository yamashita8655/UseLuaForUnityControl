--直接Unityには登録しないスクリプト。いわゆる、ライブラリ化した奴

-- クラス定義
PlayerManager = {}

-- シングルトン用定義
local _instance = nil
function PlayerManager.Instance() 
	if not _instance then
		_instance = PlayerManager
		_instance:Initialize()
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

function PlayerManager:CreatePlayer(playerDataConfig, posx, posy, degree) 
	if (self.PlayerCharacterInstance) then
	else
		local prefabName = playerDataConfig.PrefabName
		local name = playerDataConfig.Name
		local width = playerDataConfig.Width
		local height = playerDataConfig.Height
		local shootPointList = playerDataConfig.ShootPointList

		LuaLoadPrefabAfter(prefabName, name, "PlayerCharacterRoot")
		local offsetx = (posx - (ScreenWidth/2)) / CanvasFactor
		local offsety = (posy - (ScreenHeight/2)) / CanvasFactor
		LuaFindObject(name)
		LuaSetRotate(name, 0, 0, degree)
		local player = PlayerCharacter.new(offsetx, offsety, 0, 0, 0, degree, name, width, height)

		for i = 1, #shootPointList do
			player:AddShootPoint(shootPointList[i])
		end

		self.PlayerCharacterInstance = player
		LuaSetPosition(player.Name, player.PositionX, player.PositionY, player.PositionZ)
	end
end

function PlayerManager:Update(deltaTime) 
	self.PlayerCharacterInstance:Update(deltaTime)
end

function PlayerManager:OnMouseDown(touchx, touchy) 
	local offsetx = touchx - (ScreenWidth/2)
	local offsety = touchy - (ScreenHeight/2)
	local radian = math.atan2(offsety, offsetx)
	local degree = radian * 180 / 3.1415
	
	PlayerManager.Instance():SetRotate(0, 0, degree-90)
	
	local canShoot = self.PlayerCharacterInstance:CanShootBullet()
	if canShoot then
		BulletManager.Instance():CreateSpeedBullet(touchx, touchy, degree-90);
		self.PlayerCharacterInstance:ResetBulletCooltime()
	end
end

function PlayerManager:OnMouseDrag(touchx, touchy) 
	local offsetx = touchx - (ScreenWidth/2)
	local offsety = touchy - (ScreenHeight/2)
	local radian = math.atan2(offsety, offsetx)
	local degree = radian * 180 / 3.1415
	
	PlayerManager.Instance():SetRotate(0, 0, degree-90)
	
	local canShoot = self.PlayerCharacterInstance:CanShootBullet()
	if canShoot then
		BulletManager.Instance():CreateSpeedBullet(touchx, touchy, degree-90);
		self.PlayerCharacterInstance:ResetBulletCooltime()
	end
	--BulletManager.Instance():CreateNormalBullet(touchx, touchy, degree-90);
end

function PlayerManager:Release() 
	LuaDestroyObject(self.PlayerCharacterInstance.Name)
	self.PlayerCharacterInstance = nil
end

