--����Unity�ɂ͓o�^���Ȃ��X�N���v�g�B������A���C�u�����������z

-- �N���X��`
-- �ʏ�G���I�N���X
NormalEnemyCharacter = {}

-- ���\�b�h��`

-- �R���X�g���N�^
function NormalEnemyCharacter.new(posx, posy, posz, rotx, roty, rotz, name, number, width, height)
	local this = EnemyBase.new(posx, posy, posz, rotx, roty, rotz, name, number, width, height)
	
	-- �����o�ϐ�

	-- ���\�b�h��`
	-- ������
	this.EnemyBaseInitialize = this.Initialize
	this.Initialize = function(self, nowHp, maxHp, attack)
		this:EnemyBaseInitialize(nowHp, maxHp)
		self.Attack = attack
	end
	
	-- �X�V
	this.BaseUpdate = this.Update
	this.Update = function(self, deltaTime)
		local addx, addy = self.MoveController:Calc(self.RotateZ+90)
		self.PositionX = self.PositionX + addx
		self.PositionY = self.PositionY + addy
		LuaSetPosition(self.Name, self.PositionX, self.PositionY, self.PositionZ)
		self.ExistCounter = self.ExistCounter + deltaTime
	end

	return this
end

