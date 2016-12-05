--����Unity�ɂ͓o�^���Ȃ��X�N���v�g�B������A���C�u�����������z

-- �N���X��`
GameManager = {}

-- �V���O���g���p��`
local _instance = nil
function GameManager.Instance() 
	if not _instance then
		_instance = GameManager
		_instance:Initialize()
	end

	return _instance
end

-- ���\�b�h��`
function GameManager:Initialize() 
	self.SelectPlayerCharacterData = nil
	self.BattleDeltaTime = 1.0/60.0
end

-- �I�����Ă���L�����N�^�[�f�[�^�w��
function GameManager:SetSelectPlayerCharacterData(selectCharacterData) 
	self.SelectPlayerCharacterData = selectCharacterData
end
function GameManager:GetSelectPlayerCharacterData() 
	return self.SelectPlayerCharacterData
end

-- �Ăяo����閈�ɉ��Z���鎞��
function GameManager:GetBattleDeltaTime() 
	return self.BattleDeltaTime
end

function GameManager:Update(deltaTime) 
end

function GameManager:Release()
end

