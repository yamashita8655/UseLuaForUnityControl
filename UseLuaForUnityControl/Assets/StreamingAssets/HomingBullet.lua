--����Unity�ɂ͓o�^���Ȃ��X�N���v�g�B������A���C�u�����������z

-- �N���X��`
-- �e�N���X
HomingBullet = {}

-- ���\�b�h��`

-- �R���X�g���N�^
function HomingBullet.new(position, rotate, name, number, width, height)
	local this = BulletBase.new(position, rotate, name, number, width, height)

	-- �����o�ϐ�
	this.BulletType = BulletTypeEnum.UseTargetPosition
	this.Target = nil
	
	-- ���\�b�h��`

	-- �X�V
	this.BaseUpdate = this.Update
	this.Update = function(self, deltaTime)
		local addx, addy = self.MoveController:Calc(deltaTime, self.Rotate.z+90, self.Position, self.Target)
		self.Position.x = self.Position.x + addx
		self.Position.y = self.Position.y + addy
		LuaSetPosition(self.Name, self.Position.x, self.Position.y, self.Position.z)
		self.ExistCounter = self.ExistCounter + deltaTime
	end
	
	-- �^�[�Q�b�g���W�̍X�V
	this.SetTarget = function(self, target)
		self.Target = target
	end
	this.GetTarget = function(self)
		return self.Target
	end
	
	return this
end

