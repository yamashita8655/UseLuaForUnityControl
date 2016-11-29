--����Unity�ɂ͓o�^���Ȃ��X�N���v�g�B������A���C�u�����������z

-- �N���X��`
PlayerManager = {}

-- �V���O���g���p��`
local _instance = nil
function PlayerManager.Instance() 
	if not _instance then
		_instance = PlayerManager
		_instance:Initialize()
		-- ���̃��^�e�[�u���ݒ�������
		-- self.PlayerCharacterInstance = nil�͂����邪
		-- obj = self.PlayerCharacterInstance��
		-- loop in gettable
		-- �ƃG���[�ɂȂ錴����������Ɨ�������悤�ɂ���
		--setmetatable(_instance, { __index = PlayerManager })
	end

	return _instance
end

-- ���\�b�h��`
--function PlayerManager.Initialize(self)�Ɠ��� 
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

