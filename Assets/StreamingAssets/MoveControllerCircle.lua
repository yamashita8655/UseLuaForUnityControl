--直接Unityには登録しないスクリプト。いわゆる、ライブラリ化した奴

-- クラス定義
MoveControllerCircle = {}

-- コンストラクタ
function MoveControllerCircle.new()
	local this = BaseMoveController.new()
	
	-- メンバ変数
	this.SinCurveRotateValue = 0
	this.PeriodValue = 0-- 周期
	this.MoveSpeed = 1-- こっちが、振れ幅

	-- メソッド定義
	-- 初期化
	this.BaseMoveControllerInitialize = this.Initialize
	this.Initialize = function(self, moveData)
		this.BaseMoveControllerInitialize()
		self.SinCurveRotateValue = moveData:RotateValue()
		self.PeriodValue = moveData:PeriodValue() 
		self.MoveSpeed = moveData:MoveSpeed()-- こっちが、振れ幅
	end

	this.Calc = function(self, deltaTime, rotateZ)
		self.SinCurveRotateValue = self.SinCurveRotateValue + self.PeriodValue-- 数値の部分が、往復の周期の速さ

		local radian = (rotateZ-90+self.SinCurveRotateValue) / 180 * 3.1415
		local addx = math.cos(radian) * self.MoveSpeed
		local addy = math.sin(radian) * self.MoveSpeed
		return addx, addy
	end
	
	return this
end

