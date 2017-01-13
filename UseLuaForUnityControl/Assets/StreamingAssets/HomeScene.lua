--直接Unityには登録しないスクリプト。いわゆる、ライブラリ化した奴

-- クラス定義
HomeScene = {}

-- コンストラクタ
function HomeScene.new()
	local this = SceneBase.new()

	--this.Test = 0

	-- メソッド定義
	-- 初期化
	this.SceneBaseInitialize = this.Initialize
	this.Initialize = function(self)
		this:SceneBaseInitialize()
		
		LuaChangeScene("Home", "MainCanvas")
		LuaSetActive("HeaderObject", false)
		LuaSetActive("FooterObject", false)
		LuaFindObject("HomeButtonHint")
		LuaSetButtonInteractable("HomeButtonHint", false)
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
		if buttonName == "HomeButtonPlay" then
			SceneManager.Instance():ChangeScene(SceneNameEnum.Quest)
		elseif buttonName == "HomeButtonFriend" then
			SceneManager.Instance():ChangeScene(SceneNameEnum.Custom)
		elseif buttonName == "HomeButtonOption" then
			SceneManager.Instance():ChangeScene(SceneNameEnum.Option)
		elseif buttonName == "HomeButtonHint" then
		end
	end
	
	return this
end

