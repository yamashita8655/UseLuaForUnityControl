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
		
		LuaChangeScene("Custom", "MainCanvas")
		LuaSetActive("HeaderObject", true)
		LuaSetActive("FooterObject", true)
	
		if self.IsInitialized == false then
			LuaFindObject("CustomPlayerSelectContent")
			LuaFindObject("DetailText")
			
			LuaLoadPrefabAfter("Prefabs/CustomPlayerSelectListNode1", "CustomPlayerSelectListNode1", "CustomPlayerSelectContent")
			LuaLoadPrefabAfter("Prefabs/CustomPlayerSelectListNode2", "CustomPlayerSelectListNode2", "CustomPlayerSelectContent")
			LuaFindObject("CustomPlayerSelectImage1")
			LuaFindObject("CustomPlayerSelectImage2")
		end

		currentPlayerCharater = GameManager.Instance():GetSelectPlayerCharacterData()
		self:ToggleSelectImage(currentPlayerCharater)
		self:ToggleSelectDetailText(currentPlayerCharater)
		
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
	
	-- 選択画像の切り替え
	this.ToggleSelectImage = function(self, playerCharacter)
		if playerCharacter == PlayerCharacter001 then
			LuaSetActive("CustomPlayerSelectImage1", true)
			LuaSetActive("CustomPlayerSelectImage2", false)
		elseif playerCharacter == PlayerCharacter002 then
			LuaSetActive("CustomPlayerSelectImage1", false)
			LuaSetActive("CustomPlayerSelectImage2", true)
		end
	end
	
	-- 選択プレイヤーの説明文切り替え
	this.ToggleSelectDetailText = function(self, playerCharacter)
		LuaSetText("DetailText", playerCharacter.DetailText)
	end
	
	-- ボタン
	this.OnClickButton = function(self, buttonName)
		if buttonName == "CustomPlayerSelectListNode1" then
			GameManager.Instance():SetSelectPlayerCharacterData(PlayerCharacter001)
		elseif buttonName == "CustomPlayerSelectListNode2" then
			GameManager.Instance():SetSelectPlayerCharacterData(PlayerCharacter002)
		end

		selectPlayerCharater = GameManager.Instance():GetSelectPlayerCharacterData()
		self:ToggleSelectImage(selectPlayerCharater)
		self:ToggleSelectDetailText(selectPlayerCharater)
	end
	
	return this
end

