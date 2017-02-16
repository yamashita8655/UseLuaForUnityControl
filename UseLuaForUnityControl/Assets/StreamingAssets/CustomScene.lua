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
		LuaSetActive("HeaderObject", false)
		LuaSetActive("FooterObject", false)
		
		LuaFindObject("CustomSceneDialogRoot")
	
		if self.IsInitialized == false then
			LuaFindObject("CustomPlayerSelectContent")
			LuaFindObject("DetailText")

			for i = 1, #PlayerCharacterConfig do
				LuaLoadPrefabAfter("Prefabs/CustomPlayerSelectListNode"..i, "CustomPlayerSelectListNode"..i, "CustomPlayerSelectContent")
				LuaFindObject("CustomPlayerSelectImage"..i)
				LuaFindObject("CustomPlayerLockFilterImage"..i)
				LuaFindObject("KaliKaliIconText"..i)
				LuaFindObject("CustomSelectButton"..i)
				LuaFindObject("CustomUnlockButton"..i)
				LuaFindObject("CustomDetailButton"..i)
			end
			LuaFindObject("CustomKalikaliPointText")
			
			CharacterDetailDialog.Instance():Initialize()
			CharacterDetailDialog.Instance():SetParent("CustomSceneDialogRoot") 
		end
			
		local currentPlayerCharater = GameManager.Instance():GetSelectPlayerCharacterData()
		self:ToggleSelectImage(currentPlayerCharater)
		self:ToggleSelectDetailText(currentPlayerCharater)
		self:UpdateLockState()

		LuaSetText("CustomKalikaliPointText", GameManager.Instance():GetKarikariValue())

		
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

		FileIOManager.Instance():Save()
	end
	
	-- 有効かどうか
	this.IsActive = function(self)
		return self.IsActive
	end
	
	-- 選択画像の切り替え
	this.ToggleSelectImage = function(self, playerCharacter)
		for i = 1, #PlayerCharacterConfig do
			if playerCharacter == PlayerCharacterConfig[i] then
				SaveObject.CustomScene_SelectIndex = i
				LuaSetActive("CustomPlayerSelectImage"..i, true)
			else
				LuaSetActive("CustomPlayerSelectImage"..i, false)
			end
		end
		--if playerCharacter == PlayerCharacterConfig[1] then
		--	SaveObject.CustomScene_SelectIndex = 1
		--	LuaSetActive("CustomPlayerSelectImage1", true)
		--	LuaSetActive("CustomPlayerSelectImage2", false)
		--elseif playerCharacter == PlayerCharacterConfig[2] then
		--	SaveObject.CustomScene_SelectIndex = 2
		--	LuaSetActive("CustomPlayerSelectImage1", false)
		--	LuaSetActive("CustomPlayerSelectImage2", true)
		--end
	end
	
	-- 選択プレイヤーの説明文切り替え
	this.ToggleSelectDetailText = function(self, playerCharacter)
		LuaSetText("DetailText", playerCharacter.DetailText)
	end
	
	-- ボタン
	this.OnClickButton = function(self, buttonName)
		for i = 1, #PlayerCharacterConfig do
			if buttonName == "CustomSelectButton"..i then
				GameManager.Instance():SetSelectPlayerCharacterData(PlayerCharacterConfig[i])
				self:ToggleSelectImage(PlayerCharacterConfig[i])
				self:ToggleSelectDetailText(PlayerCharacterConfig[i])
			end

			if buttonName == "CustomUnlockButton"..i then
				local unlockNeedValue = PlayerCharacterConfig[i].UnlockNeedValue
				DialogManager.Instance():OpenDialog(
					"この子とお友達になります。よろしいですか？",
					function()
						SaveObject.CustomScene_CharacterUnlockList[i] = 1
						GameManager.Instance():AddKarikariValue(-unlockNeedValue)
						LuaSetText("CustomKalikaliPointText", GameManager.Instance():GetKarikariValue())
						SaveObject.CustomScene_HaveKarikariValue = GameManager.Instance():GetKarikariValue()
						self:UpdateLockState()
					end
					,
					function()
					end
				)
			end

			if buttonName == "CustomDetailButton"..i then
				self:ToggleSelectDetailText(PlayerCharacterConfig[i])

				CharacterDetailDialog.Instance():OpenDialog(
					function()
					end,
					PlayerCharacterConfig[i]
				)
			end
		end
		
		if buttonName == "CustomBackButton" then
			SceneManager.Instance():ChangeScene(SceneNameEnum.Home)
		end

		CharacterDetailDialog.Instance():OnClickButton(buttonName)

		--selectPlayerCharater = GameManager.Instance():GetSelectPlayerCharacterData()
	end
	
	-- ロック状態の適用
	this.UpdateLockState = function(self)
		local LockList = SaveObject.CustomScene_CharacterUnlockList
		for i = 1, #PlayerCharacterConfig do
			local lock = LockList[i]
			if lock == 0 then
				LuaSetActive("CustomPlayerLockFilterImage"..i, true)
				LuaSetActive("CustomUnlockButton"..i, true)
				LuaSetActive("CustomSelectButton"..i, false)
				local unlockNeedValue = PlayerCharacterConfig[i].UnlockNeedValue
				LuaSetText("KaliKaliIconText"..i, unlockNeedValue)
				if unlockNeedValue > GameManager.Instance():GetKarikariValue() then
					LuaSetButtonInteractable("CustomUnlockButton"..i, false)
				else
					LuaSetButtonInteractable("CustomUnlockButton"..i, true)
				end
			else
				LuaSetActive("CustomPlayerLockFilterImage"..i, false)
				LuaSetActive("CustomUnlockButton"..i, false)
				LuaSetActive("CustomSelectButton"..i, true)
			end
		end
	end
	
	return this
end

