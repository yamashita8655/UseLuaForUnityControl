--直接Unityには登録しないスクリプト。いわゆる、ライブラリ化した奴

-- クラス定義
QuestScene = {}

-- コンストラクタ
function QuestScene.new()
	local this = SceneBase.new()

	--this.Test = 0

	-- メソッド定義
	-- 初期化
	this.SceneBaseInitialize = this.Initialize
	this.Initialize = function(self)
		this:SceneBaseInitialize()

		-- クエストデータ作らなきゃね
		self.questCount = 5
		
		LuaChangeScene("Quest", "MainCanvas")
		LuaSetActive("HeaderObject", true)
		LuaSetActive("FooterObject", true)

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
				GameManager.Instance():SetSelectQuestId(i)
				SceneManager.Instance():ChangeScene(SceneNameEnum.Battle)
			end
		end
	end
	
	return this
end

