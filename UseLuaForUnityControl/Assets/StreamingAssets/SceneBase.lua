--直接Unityには登録しないスクリプト。いわゆる、ライブラリ化した奴

-- クラス定義
SceneBase = {}

-- コンストラクタ
function SceneBase.new()
	local this = {
		IsActive = false,
		IsInitialized = false,
	}

	-- メソッド定義
	-- 初期化
	this.Initialize = function(self)
		self.IsInitialized = true;
	end
	
	-- 更新
	this.Update = function(self, deltaTime)
	end
	
	-- 終了
	this.End = function(self)
		self.IsActive = false
	end
	
	-- 有効かどうか
	this.IsActive = function(self)
		return self.IsActive
	end
	
	return this
end

