--����Unity�ɂ͓o�^���Ȃ��X�N���v�g�B������A���C�u�����������z

-- �N���X��`
-- �ʏ�G���I�N���X
NormalEnemyCharacter = {}

-- ���\�b�h��`

-- �R���X�g���N�^
function NormalEnemyCharacter.new(posx, posy, posz, rotx, roty, rotz, name, number, width, height)
	local this = CharacterBase.new(posx, posy, posz, rotx, roty, rotz, name, number, width, height)
	
	-- �����o�ϐ�
	this.ExistCounter = 0.0
	this.ExistTime = 0.0
	this.MoveSpeed = 1.0

	-- ���\�b�h��`
	-- �X�V
	this.BaseUpdate = this.Update
	this.Update = function(self, deltaTime)
		local radian = (self.RotateZ+90) / 180 * 3.1415
		local addx = math.cos(radian)
		local addy = math.sin(radian)

		self.PositionX = self.PositionX + addx*self.MoveSpeed
		self.PositionY = self.PositionY + addy*self.MoveSpeed
		
		LuaSetPosition(self.Name, self.PositionX, self.PositionY, self.PositionZ)

		self.ExistCounter = self.ExistCounter + deltaTime
	end

	return this
end

