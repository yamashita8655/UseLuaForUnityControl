--����Unity�ɂ͓o�^���Ȃ��X�N���v�g�B������A���C�u�����������z

-- �N���X��`
-- �v���C���[�N���X
PlayerCharacter = {}

-- ���\�b�h��`

-- �R���X�g���N�^
function PlayerCharacter.new(posx, posy, posz, rotx, roty, rotz, name, width, height)
	local this = CharacterBase.new(posx, posy, posz, rotx, roty, rotz, name, 0, width, height)
	
	-- �����o�ϐ�
	this.ExistCounter = 0.0
	this.ExistTime = 0.0
	this.MoveSpeed = 1.0

	-- ���\�b�h��`
	-- �X�V
	this.BaseUpdate = this.Update
	this.Update = function(self, deltaTime)
	end

	-- ���^�e�[�u���Z�b�g
	return setmetatable(this, {__index = PlayerCharacter})
end

