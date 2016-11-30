--直接Unityには登録しないスクリプト。いわゆる、ライブラリ化した奴

-- クラス定義
-- 2点を表すオブジェクト
Vector2 = {}

-- コンストラクタ
function Vector2.new(x, y)
	local this = {
		x = x, 
		y = y
	}

	-- メソッド定義
	--this.Function = function()
	--end
end

-- 3点を表すオブジェクト
Vector3 = {}

-- コンストラクタ
function Vector3.new(x, y, z)
	local this = {
		x = x, 
		y = y,
		z = z
	}

	-- メソッド定義
	--this.Function = function()
	--end
end

