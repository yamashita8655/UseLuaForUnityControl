--直接Unityには登録しないスクリプト。いわゆる、ライブラリ化した奴

-- クラス定義
BaseMoveController = {}

-- コンストラクタ
function BaseMoveController.new()
	local this = {
		--MaxHp = 0,
	}

	-- メソッド定義
	-- 初期化
	this.Initialize = function(self)
	end
	
	-- 計算
	-- と書いてあるけど、毎フレーム呼び出される前提なので、deltaTimeも渡す
	this.Initialize = function(self, deltaTime)
	end
	
	return this
end

