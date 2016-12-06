--直接Unityには登録しないスクリプト。いわゆる、ライブラリ化した奴

-- クラス定義
MoveControllerSinCurve = {}

-- コンストラクタ
function MoveControllerSinCurve.new()
	local this = BaseMoveController.new()
	
	-- メンバ変数
	this.IsCountUp = true
	this.SinCurveRotateValue = 0
	this.PeriodValue = 0-- 周期
	this.MoveSpeed = 1-- こっちが、振れ幅

	-- メソッド定義
	-- 初期化
	this.BaseMoveControllerInitialize = this.Initialize
	this.Initialize = function(self, sinCurveRotateValue, periodValue, moveSpeed)
		this.BaseMoveControllerInitialize()
		self.SinCurveRotateValue = sinCurveRotateValue
		self.PeriodValue = periodValue 
		self.MoveSpeed = moveSpeed-- こっちが、振れ幅
	end


	this.Calc = function(self, rotateZ)
		if self.IsCountUp then
			self.SinCurveRotateValue = self.SinCurveRotateValue + self.PeriodValue-- 数値の部分が、往復の周期の速さ
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

