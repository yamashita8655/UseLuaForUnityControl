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
end

-- �I�����Ă���L�����N�^�[�f�[�^�w��
function GameManager:SetSelectPlayerCharacterData(selectCharacterData) 
	self.SelectPlayerCharacterData = selectCharacterData
end
function GameManager:GetSelectPlayerCharacterData() 
	return self.SelectPlayerCharacterData
end

function GameManager:Update(deltaTime) 
end

function GameManager:Release()
end

