--直接Unityには登録しないスクリプト。いわゆる、ライブラリ化した奴

-- クラス定義
CustomScene = {}

-- コンストラクタ
function CustomScene.new()
	local this = SceneBase.new()

	--this.Test = 0

	-- メソッド定義
	-- 初期化
	this.SceneBaseInitialize = this.Initialize
	this.Initialize = function(self)
		this:SceneBaseInitialize()
		
		LuaChangeScene("Custom", "MainCanvas")
		LuaSetActive("HeaderObject", true)
		LuaSetActive("FooterObject", true)
	end
	
	-- 更新
	this.SceneBaseUpdate = this.Update
	this.Update = function(self, deltaTime)
		this:SceneBaseUpdate(deltaTime)
	end
	
	-- 終了
	this.SceneBaseEnd = this.End
	this.End = function(self)
		this:SceneBaseEnd()
	end
	
	-- 有効かどうか
	this.IsActive = function(self)
		return self.IsActive
	end
	
	return this
end

