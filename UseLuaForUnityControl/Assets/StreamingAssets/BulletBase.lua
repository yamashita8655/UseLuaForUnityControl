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
	this.Attack = 0

	-- ���\�b�h��`
	-- ������
	this.ObjectBaseInitialize = this.Initialize
	this.Initialize = function(self, nowHp, maxHp, attack)
		this:ObjectBaseInitialize(nowHp, maxHp)
		self.Attack = attack
	end

	-- �U���͂̎擾
	this.GetAttack = function(self)
		return self.Attack
	end

	-- ���^�e�[�u���Z�b�g
	--return setmetatable(this, {__index = BulletBase})
	return this
end

