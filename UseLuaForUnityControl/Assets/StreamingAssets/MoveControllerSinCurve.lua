--����Unity�ɂ͓o�^���Ȃ��X�N���v�g�B������A���C�u�����������z

-- �N���X��`
MoveControllerSinCurve = {}

-- �R���X�g���N�^
function MoveControllerSinCurve.new()
	local this = BaseMoveController.new()
	
	-- �����o�ϐ�
	this.IsCountUp = true
	this.SinCurveRotateValue = 0
	this.PeriodValue = 0-- ����
	this.MoveSpeed = 1-- ���������A�U�ꕝ

	-- ���\�b�h��`
	-- ������
	this.BaseMoveControllerInitialize = this.Initialize
	this.Initialize = function(self, sinCurveRotateValue, periodValue, moveSpeed)
		this.BaseMoveControllerInitialize()
		self.SinCurveRotateValue = sinCurveRotateValue
		self.PeriodValue = periodValue 
		self.MoveSpeed = moveSpeed-- ���������A�U�ꕝ
	end


	this.Calc = function(self, rotateZ)
		if self.IsCountUp then
			self.SinCurveRotateValue = self.SinCurveRotateValue + self.PeriodValue-- ���l�̕������A�����̎����̑���
			if self.SinCurveRotateValue >= 180 then
				self.SinCurveRotateValue = 180
				self.IsCountUp = false
			end
		else
			self.SinCurveRotateValue = self.SinCurveRotateValue - self.PeriodValue
			if self.SinCurveRotateValue <= 0 then
				self.SinCurveRotateValue = 0
				self.IsCountUp = true
			end
		end

		local radian = (rotateZ-90+self.SinCurveRotateValue) / 180 * 3.1415
		local addx = math.cos(radian) * self.MoveSpeed
		local addy = math.sin(radian) * self.MoveSpeed
		return addx, addy
	end
	
	return this
end

