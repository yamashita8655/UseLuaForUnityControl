--����Unity�ɂ͓o�^���Ȃ��X�N���v�g�B������A���C�u�����������z

-- �N���X��`
BaseMoveController = {}

-- �R���X�g���N�^
function BaseMoveController.new()
	local this = {
		--MaxHp = 0,
	}

	-- ���\�b�h��`
	-- ������
	this.Initialize = function(self)
	end
	
	-- �v�Z
	-- �Ə����Ă��邯�ǁA���t���[���Ăяo�����O��Ȃ̂ŁAdeltaTime���n��
	this.Initialize = function(self, deltaTime)
	end
	
	return this
end

