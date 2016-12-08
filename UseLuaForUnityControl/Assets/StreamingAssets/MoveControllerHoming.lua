--直接Unityには登録しないスクリプト。いわゆる、ライブラリ化した奴

-- クラス定義
MoveControllerHoming = {}

-- コンストラクタ
function MoveControllerHoming.new()
	local this = BaseMoveController.new()
	
	-- メンバ変数
	this.HomingStartTime = 0
	this.MoveDegreeLimit = 1
	this.MoveSpeed = 1-- こっちが、振れ幅
	
	this.HomingStartCounter = 0
	this.Radian = 0

	-- メソッド定義
	-- 初期化
	this.BaseMoveControllerInitialize = this.Initialize
	this.Initialize = function(self, moveData)
		this:BaseMoveControllerInitialize()
		self.HomingStartTime = moveData:HomingStartTime()
		self.MoveDegreeLimit = moveData:MoveDegreeLimit() 
		self.MoveSpeed = moveData:MoveSpeed()-- こっちが、振れ幅
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

