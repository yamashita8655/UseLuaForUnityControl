--直接Unityには登録しないスクリプト。いわゆる、ライブラリ化した奴

-- クラス定義
HomeScene = {}

-- コンストラクタ
function HomeScene.new()
	local this = SceneBase.new()

	this.CurrentCharacterObjectName = ""

	-- メソッド定義
	-- 初期化
	this.SceneBaseInitialize = this.Initialize
	this.Initialize = function(self)
		
		LuaChangeScene("Home", "MainCanvas")
		LuaSetActive("HeaderObject", false)
		LuaSetActive("FooterObject", false)
		LuaFindObject("HomeButtonGacha")
		LuaFindObject("HomeCharacterMoveRoot")
		--LuaSetButtonInteractable("HomeButtonGacha", false)
		
		if self.CurrentCharacterObjectName ~= "" then
			LuaDestroyObject(self.CurrentCharacterObjectName)
		end

		local player = GameManager.Instance():GetSelectPlayerCharacterData()
		self.CurrentCharacterObjectName = player.HomePlayerName
		LuaUnityDebugLog(player.PrefabName)
		LuaLoadPrefabAfter("common", player.PrefabName, player.HomePlayerName, "HomeCharacterMoveRoot")
		LuaSetActive(player.HomePlayerName, false)

		TimerCallbackManager:AddCallback(
			{self}, 
			self.TimerStartCharacterMove,
			0.1
		) 
		
		this:SceneBaseInitialize()
		
		SoundManager.Instance():PlayBGM(SoundManager.Instance().BGMIndexList.HomeSceneBgm)
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
		elseif buttonName == "HomeButtonGacha" then
			SceneManager.Instance():ChangeScene(SceneNameEnum.Gacha)
		elseif buttonName == "HomeButtonCredit" then
			SceneManager.Instance():ChangeScene(SceneNameEnum.Credit)
		end
	end
	
	-- 
	this.CharacterMoveAnimationCallback = function(arg, unityArg)
	end
	
	this.TimerStartCharacterMove = function(arg)
		self = arg[1]
		local number = math.random(2)
		LuaSetActive(this.CurrentCharacterObjectName, true)
		CallbackManager.Instance():AddCallback("HomeScene_CharacterMoveAnimationCallback", {self}, self.CharacterMoveAnimationCallback)
		if number == 1 then
			LuaUnityDebugLog("Gorogoro")
			LuaPlayAnimator(this.CurrentCharacterObjectName, "Gorogoro", false, false, "LuaCallback", "HomeScene_CharacterMoveAnimationCallback")
			self.Flag = 1
		elseif number == 2 then
			LuaUnityDebugLog("Dorodoro")
			LuaPlayAnimator(this.CurrentCharacterObjectName, "Dorodoro", false, false, "LuaCallback", "HomeScene_CharacterMoveAnimationCallback")
		end
	end
	
	return this
end

