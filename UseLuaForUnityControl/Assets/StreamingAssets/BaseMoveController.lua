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
	
	return this
end

