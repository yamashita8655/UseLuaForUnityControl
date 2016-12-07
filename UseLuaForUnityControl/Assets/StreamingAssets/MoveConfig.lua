--直接Unityには登録しないスクリプト。いわゆる、ライブラリ化した奴
MoveTypeEnum = {
	None = -1,
	Straight = 0,
	SinCurve = 1,
}

-- 移動方法の設定に使うオブジェクト群
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

