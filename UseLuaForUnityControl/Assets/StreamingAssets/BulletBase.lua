--����Unity�ɂ͓o�^���Ȃ��X�N���v�g�B������A���C�u�����������z

-- �N���X��`
-- �e�N���X
BulletBase = {}

-- ���\�b�h��`

-- �R���X�g���N�^
function BulletBase.new(posx, posy, posz, rotx, roty, rotz, name, number, width, height)
	local this = ObjectBase.new(posx, posy, posz, rotx, roty, rotz, name, number, width, height)
	
	-- �����o�ϐ�
	this.ExistCounter = 0.0
	this.ExistTime = 0.0
	this.MoveSpeed = 0.0

	-- ���\�b�h��`
	-- �e�̐����m�F
	this.IsExist = function(self)
		local isExist = true
		if self.ExistCounter > self.ExistTime then
			isExist = false
		end
	
		return isExist
	end

	-- ���^�e�[�u���Z�b�g
	--return setmetatable(this, {__index = BulletBase})
	return this
end

