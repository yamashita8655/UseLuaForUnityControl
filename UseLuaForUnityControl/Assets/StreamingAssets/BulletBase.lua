--����Unity�ɂ͓o�^���Ȃ��X�N���v�g�B������A���C�u�����������z

-- �N���X��`
-- �e�N���X
BulletBase = {}

-- ���\�b�h��`

-- �R���X�g���N�^
function BulletBase.new(position, rotate, name, number, width, height)
	local this = ObjectBase.new(position, rotate, name, number, width, height)
	
	-- �����o�ϐ�
	this.ExistCounter = 0.0
	this.ExistTime = 0.0
	this.MoveSpeed = 0.0
	this.Attack = 0
	this.MoveController = nil

	-- ���\�b�h��`
	-- ������
	this.ObjectBaseInitialize = this.Initialize
	this.Initialize = function(self, nowHp, maxHp, attack, existTime)
		this:ObjectBaseInitialize(nowHp, maxHp)
		self.Attack = attack
		self.ExistTime = existTime
	end
	
	--�ړ������N���X�̐ݒ�
	this.SetMoveController = function(self, controller)
		self.MoveController = controller
	end

	-- �U���͂̎擾
	this.GetAttack = function(self)
		return self.Attack
	end
	
	-- ��������
	this.ObjectBaseIsAlive = this.IsAlive
	this.IsAlive = function(self)
		local isAlive = this:ObjectBaseIsAlive()
		if isAlive == false then
			return false
		end

		if self.ExistCounter > self.ExistTime then
			return false
		end

		return true
	end
	
	-- �X�V����
	this.ObjectBaseUpdate = this.Update
	this.Update = function(self, deltaTime)
		self.ExistCounter = self.ExistCounter + deltaTime
	end

	-- ���^�e�[�u���Z�b�g
	--return setmetatable(this, {__index = BulletBase})
	return this
end

