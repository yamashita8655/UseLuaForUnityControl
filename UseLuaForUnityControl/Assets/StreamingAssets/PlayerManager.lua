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
	LuaSetRotate("PlayerCharacterObject", rotatex, rotatey, rotatez)
end

function PlayerManager:CreatePlayer(posx, posy, degree) 
	if (self.PlayerCharacterInstance) then
	else
		LuaLoadPrefabAfter("Prefabs/PlayerCharacterObject", "PlayerCharacterObject", "PlayerCharacterRoot")
		local offsetx = (posx - (ScreenWidth/2)) / CanvasFactor
		local offsety = (posy - (ScreenHeight/2)) / CanvasFactor
		LuaFindObject("PlayerCharacterObject")
		LuaSetRotate("PlayerCharacterObject", 0, 0, degree)
		local player = PlayerCharacter.new(offsetx, offsety, 0, 0, 0, degree, "PlayerCharacterObject", 128, 128)

		self.PlayerCharacterInstance = player
		LuaSetPosition(player.Name, player.PositionX, player.PositionY, player.PositionZ)
	end
end

function PlayerManager:Update(deltaTime) 
end

