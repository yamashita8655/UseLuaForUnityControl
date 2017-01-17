--直接Unityには登録しないスクリプト。いわゆる、ライブラリ化した奴

-- クラス定義
HomeScene = {}

-- コンストラクタ
function HomeScene.new()
	local this = SceneBase.new()

	this.Flag = 0

	-- メソッド定義
	-- 初期化
	this.SceneBaseInitialize = this.Initialize
	this.Initialize = function(self)
		
		LuaChangeScene("Home", "MainCanvas")
		LuaSetActive("HeaderObject", false)
		LuaSetActive("FooterObject", false)
		LuaFindObject("HomeButtonHint")
		LuaFindObject("HomeCharacterMoveRoot")
		LuaSetButtonInteractable("HomeButtonHint", false)
		
		if self.IsInitialized ~= true then
			LuaLoadPrefabAfter("Prefabs/HomeCharacter1", "HomeCharacter1", "HomeCharacterMoveRoot")
		end

		
		LuaSetPosition("HomeCharacter1", 0, 0, 0)
		LuaSetRotate("HomeCharacter1", 0, 0, 0)
		
		--LuaSetActive("HomeCharacter1", false)
		--TimerCallbackManager:AddCallback(
		--	{self}, 
		--	self.TimerStartCharacterMove,
		--	0.1
		--) 
		
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
		if buttonName == "HomeButtonPlay" then
			SceneManager.Instance():ChangeScene(SceneNameEnum.Quest)
		elseif buttonName == "HomeButtonFriend" then
			SceneManager.Instance():ChangeScene(SceneNameEnum.Custom)
		elseif buttonName == "HomeButtonOption" then
			SceneManager.Instance():ChangeScene(SceneNameEnum.Option)
		elseif buttonName == "HomeButtonHint" then
		end
	end
	
	-- 
	this.CharacterMoveAnimationCallback = function(arg, unityArg)
	end
	
	this.TimerStartCharacterMove = function(arg)
		self = arg[1]
		LuaSetActive("HomeCharacter1", true)
		CallbackManager.Instance():AddCallback("HomeScene_CharacterMoveAnimationCallback", {self}, self.CharacterMoveAnimationCallback)
		if self.Flag == 0 then
			LuaUnityDebugLog("Gorogoro")
			LuaPlayAnimator("HomeCharacter1", "Gorogoro", false, false, "LuaCallback", "HomeScene_CharacterMoveAnimationCallback")
			self.Flag = 1
		else
			LuaUnityDebugLog("Dorodoro")
			LuaPlayAnimator("HomeCharacter1", "Dorodoro", false, false, "LuaCallback", "HomeScene_CharacterMoveAnimationCallback")
		end
	end
	
	return this
end

