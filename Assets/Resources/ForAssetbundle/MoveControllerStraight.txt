--直接Unityには登録しないスクリプト。いわゆる、ライブラリ化した奴

-- クラス定義
MoveControllerStraight = {}

-- コンストラクタ
function MoveControllerStraight.new()
	local this = BaseMoveController.new()
	
	-- メンバ変数
	this.MoveSpeed = 1

	-- メソッド定義
	-- 初期化
	this.BaseMoveControllerInitialize = this.Initialize
	this.Initialize = function(self, moveData)
		this.BaseMoveControllerInitialize()
		self.MoveSpeed = moveData:MoveSpeed()
	end

	this.Calc = function(self, deltaTime, rotateZ)
		local radian = rotateZ / 180 * 3.1415
		local addx = math.cos(radian) * self.MoveSpeed
		local addy = math.sin(radian) * self.MoveSpeed
		return addx, addy
	end
	
	return this
end

