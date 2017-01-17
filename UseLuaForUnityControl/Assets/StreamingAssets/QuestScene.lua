--直接Unityには登録しないスクリプト。いわゆる、ライブラリ化した奴

-- クラス定義
QuestScene = {}

-- コンストラクタ
function QuestScene.new()
	local this = SceneBase.new()

	this.QuestList = {
		"ID_001",
		"ID_002",
		"ID_003",
		"ID_004",
	}

	-- メソッド定義
	-- 初期化
	this.SceneBaseInitialize = this.Initialize
	this.Initialize = function(self)
		this:SceneBaseInitialize()

		-- クエストデータ作らなきゃね
		--self.questCount = #QuestConfig
		self.questCount = #self.QuestList

		
		LuaChangeScene("Quest", "MainCanvas")
		LuaSetActive("HeaderObject", false)
		LuaSetActive("FooterObject", false)
		
		LuaFindObject("QuestClickFilter")
		LuaFindObject("QuestPanelContainer")
		LuaSetActive("QuestClickFilter", false)
		
		TimerCallbackManager:AddCallback(
			{self}, 
			self.TimerResetControlPanelPosition,
			0.1
		) 

		for i = 1, self.questCount do
			LuaDestroyObject("QuestSelectListNode"..i, "QuestScrollContent")
		end
	
		for i = 1, self.questCount do
			LuaLoadPrefabAfter("Prefabs/QuestSelectListNode", "QuestSelectListNode"..i, "QuestScrollContent")
			LuaSetActive("QuestSelectListNode"..i, true)
		end
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
	
	-- コールバック
	this.OnClickButton = function(self, buttonName)
		for i = 1, self.questCount do
			if buttonName == "QuestSelectListNode"..i then
				local questId = self.QuestList[i]
				GameManager.Instance():SetSelectQuestId(questId)
				SceneManager.Instance():ChangeScene(SceneNameEnum.Battle)
			end
		end
			
		if buttonName == "QuestFirstBackButton" then
			SceneManager.Instance():ChangeScene(SceneNameEnum.Home)
		elseif buttonName == "QuestSecondBackButton" then
			LuaSetActive("QuestClickFilter", true)
			CallbackManager.Instance():AddCallback("QuestScene_S2FCallback", {self}, self.S2FCallback)
			LuaPlayAnimator("QuestPanelContainer", "S2F", false, false, "LuaCallback", "QuestScene_S2FCallback")
		elseif buttonName == "QuestQuickBattleButton" then
			GameManager.Instance():SetSelectQuestId("ID_QUICK")
			SceneManager.Instance():ChangeScene(SceneNameEnum.Battle)
		elseif buttonName == "QuestStoryButton" then
			LuaSetActive("QuestClickFilter", true)
			CallbackManager.Instance():AddCallback("QuestScene_F2SCallback", {self}, self.F2SCallback)
			LuaPlayAnimator("QuestPanelContainer", "F2S", false, false, "LuaCallback", "QuestScene_F2SCallback")
		end
	end
	
	-- コールバック
	this.F2SCallback = function(arg, unityArg)
		local self =  arg[1]
		LuaSetActive("QuestClickFilter", false)
	end
	
	this.S2FCallback = function(arg, unityArg)
		local self =  arg[1]
		LuaSetActive("QuestClickFilter", false)
	end
	
	this.TimerResetControlPanelPosition = function(arg)
		LuaSetPosition("QuestPanelContainer", 0, 0, 0)
	end
	
	return this
end

