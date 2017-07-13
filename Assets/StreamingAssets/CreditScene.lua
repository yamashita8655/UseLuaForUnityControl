--直接Unityには登録しないスクリプト。いわゆる、ライブラリ化した奴

-- クラス定義
CreditScene = {}

-- コンストラクタ
function CreditScene.new()
	local this = SceneBase.new()

	-- メソッド定義
	-- 初期化
	this.SceneBaseInitialize = this.Initialize
	this.Initialize = function(self)
		self.GachaSelectIndex = 1

		LuaChangeScene("Credit", "MainCanvas")
		
		LuaSetActive("HeaderObject", false)
		LuaSetActive("FooterObject", false)
	
		this:SceneBaseInitialize()
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
	
	-- ボタン
	this.OnClickButton = function(self, buttonName)
		if buttonName == "CreditSceneBackButton" then
			SceneManager.Instance():ChangeScene(SceneNameEnum.Home)
		end
	end

	return this
end

