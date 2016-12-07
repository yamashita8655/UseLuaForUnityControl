--����Unity�ɂ͓o�^���Ȃ��X�N���v�g�B������A���C�u�����������z

-- �N���X��`
MoveControllerStraight = {}

-- �R���X�g���N�^
function MoveControllerStraight.new()
	local this = BaseMoveController.new()
	
	-- �����o�ϐ�
	this.MoveSpeed = 1

	-- ���\�b�h��`
	-- ������
	this.BaseMoveControllerInitialize = this.Initialize
	this.Initialize = function(self, moveData)
		this.BaseMoveControllerInitialize()
		self.MoveSpeed = moveData:MoveSpeed()
	end

	this.Calc = function(self, rotateZ)
		local radian = rotateZ / 180 * 3.1415
		local addx = math.cos(radian) * self.MoveSpeed
		local addy = math.sin(radian) * self.MoveSpeed
		return addx, addy
	end
	
	return this
end

