--����Unity�ɂ͓o�^���Ȃ��X�N���v�g�B������A���C�u�����������z

-- �N���X��`
-- �ʏ�G���I�N���X
EnemyBase = {}

-- ���\�b�h��`

-- �R���X�g���N�^
function EnemyBase.new(position, rotate, name, number, width, height)
	local this = CharacterBase.new(position, rotate, name, number, width, height)
	
	-- �����o�ϐ�
	this.ExistCounter = 0.0
	this.ExistTime = 0.0
	this.MoveSpeed = 1.0
	this.Attack = 0
	this.MoveController = nil
	this.BulletEmitterList = {}

	-- ���\�b�h��`
	-- ������
	this.CharacterBaseInitialize = this.Initialize
	this.Initialize = function(self, nowHp, maxHp, attack)
		this:CharacterBaseInitialize(nowHp, maxHp)
		self.Attack = attack
	end
	
	--�ړ������N���X�̐ݒ�
	this.SetMoveController = function(self, controller)
		self.MoveController = controller
	end
	
	-- �U���͂̎擾
	this.GetAttack = function(self)
		return self.Attack
	end
	
	-- �X�V
	this.Update = function(self, deltaTime)
		local addx, addy = self.MoveController:Calc(deltaTime, self.Rotate.z+90)
		self.Position.x = self.Position.x + addx
		self.Position.y = self.Position.y + addy
		LuaSetPosition(self.Name, self.Position.x, self.Position.y, self.Position.z)
		self.ExistCounter = self.ExistCounter + deltaTime
	end

	return this
end

