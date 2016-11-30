--����Unity�ɂ͓o�^���Ȃ��X�N���v�g�B������A���C�u�����������z

-- �N���X��`
-- �e�N���X
NormalBullet = {}

-- ���\�b�h��`

-- �R���X�g���N�^
function NormalBullet.new(posx, posy, posz, rotx, roty, rotz, name, number, width, height)
	local this = BulletBase.new(posx, posy, posz, rotx, roty, rotz, name, number, width, height)

	-- �����o�ϐ�
	this.ExistTime = 1.0
	this.MoveSpeed = 5.0
	
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
	
	-- ���^�e�[�u���Z�b�g
	--return setmetatable(this, {__index = NormalBullet})
	return this
end

