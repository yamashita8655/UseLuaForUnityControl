--����Unity�ɂ͓o�^���Ȃ��X�N���v�g�B������A���C�u�����������z

-- �N���X��`
MoveControllerHoming = {}

-- �R���X�g���N�^
function MoveControllerHoming.new()
	local this = BaseMoveController.new()
	
	-- �����o�ϐ�
	this.HomingStartTime = 0
	this.MoveDegreeLimit = 1
	this.MoveSpeed = 1-- ���������A�U�ꕝ
	
	this.HomingStartCounter = 0
	this.Radian = 0

	-- ���\�b�h��`
	-- ������
	this.BaseMoveControllerInitialize = this.Initialize
	this.Initialize = function(self, moveData)
		this:BaseMoveControllerInitialize()
		self.HomingStartTime = moveData:HomingStartTime()
		self.MoveDegreeLimit = moveData:MoveDegreeLimit() 
		self.MoveSpeed = moveData:MoveSpeed()-- ���������A�U�ꕝ
	end

	this.Calc = function(self, deltaTime, rotateZ, basePosition, target)
		
		self.HomingStartCounter = self.HomingStartCounter + deltaTime
		local addx = 0
		local addy = 0
		if self.HomingStartCounter > this.HomingStartTime then
			if target == nil or target:IsAlive() == false then
				LuaUnityDebugLog("targetNil")
				addx = math.cos(self.Radian) * self.MoveSpeed
				addy = math.sin(self.Radian) * self.MoveSpeed
			else
				local targetPosition = target:GetPosition()
				local posx = targetPosition.x - basePosition.x
				local posy = targetPosition.y - basePosition.y
				local baseRadian = math.atan2(posy, posx)
				self.Radian = baseRadian
				
				addx = math.cos(self.Radian) * self.MoveSpeed
				addy = math.sin(self.Radian) * self.MoveSpeed
			end
		else
			local wradian = (rotateZ) / 180 * 3.1415
			self.Radian = wradian
			addx = math.cos(self.Radian) * self.MoveSpeed
			addy = math.sin(self.Radian) * self.MoveSpeed
		end
	

		--local radian = (degree-90) / 180 * 3.1415
		--local addx = math.cos(radian) * self.MoveSpeed
		--local addy = math.sin(radian) * self.MoveSpeed
		return addx, addy
	end
	
	return this
end

