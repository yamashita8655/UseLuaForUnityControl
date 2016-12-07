--����Unity�ɂ͓o�^���Ȃ��X�N���v�g�B������A���C�u�����������z

-- �N���X��`
-- �ʏ�G���I�N���X
SinCurveEnemy = {}

-- ���\�b�h��`

-- �R���X�g���N�^
function SinCurveEnemy.new(position, rotate, name, number, width, height)
	local this = EnemyBase.new(position, rotate, name, number, width, height)
	
	-- �����o�ϐ�

	-- ���\�b�h��`
	-- ������
	this.EnemyBaseInitialize = this.Initialize
	
	-- �X�V
	this.BaseUpdate = this.Update
	this.Update = function(self, deltaTime)
		local addx, addy = self.MoveController.Calc(self.Rotate.z+90)
		self.Position.x = self.Position.x + addx
		self.Position.y = self.Position.y + addy
		LuaSetPosition(self.Name, self.Position.x, self.Position.y, self.Position.z)
		self.ExistCounter = self.ExistCounter + deltaTime
	end

	return this
end

