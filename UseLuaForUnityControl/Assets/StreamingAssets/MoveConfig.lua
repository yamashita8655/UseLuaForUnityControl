--����Unity�ɂ͓o�^���Ȃ��X�N���v�g�B������A���C�u�����������z
MoveTypeEnum = {
	None = -1,
	Straight = 0,
	SinCurve = 1,
	Homing = 2,
}

-- �ړ����@�̐ݒ�Ɏg���I�u�W�F�N�g�Q
MoveStraight = {}

function MoveStraight.new(moveSpeed)
	local this = {
		LocalMoveType = MoveTypeEnum.Straight,
		LocalMoveSpeed = moveSpeed,
	}

	this.MoveType = function(self)
		return self.LocalMoveType
	end

	this.MoveSpeed = function(self)
		return self.LocalMoveSpeed
	end
	
	return this
end

MoveSinCurve = {}

function MoveSinCurve.new(rotateValue, periodValue, moveSpeed)
	local this = {
		LocalMoveType = MoveTypeEnum.SinCurve,
		LocalRotateValue = rotateValue,
		LocalPeriodValue = periodValue,
		LocalMoveSpeed = moveSpeed,
	}
	
	this.MoveType = function(self)
		return self.LocalMoveType
	end

	this.MoveSpeed = function(self)
		return self.LocalMoveSpeed
	end
	
	this.RotateValue = function(self)
		return self.LocalRotateValue
	end
	
	this.PeriodValue = function(self)
		return self.LocalPeriodValue
	end
	
	return this
end

MoveHoming = {}

function MoveHoming.new(homingStartTime, moveDegreeLimit, moveSpeed)
	local this = {
		LocalMoveType = MoveTypeEnum.Homing,
		LocalHomingStartTime = homingStartTime,
		LocalMoveDegreeLimit = moveDegreeLimit,
		LocalMoveSpeed = moveSpeed,
	}
	
	this.MoveType = function(self)
		return self.LocalMoveType
	end

	this.MoveSpeed = function(self)
		return self.LocalMoveSpeed
	end
	
	this.HomingStartTime = function(self)
		return self.LocalHomingStartTime
	end
	
	this.MoveDegreeLimit = function(self)
		return self.LocalMoveDegreeLimit
	end
	
	return this
end

