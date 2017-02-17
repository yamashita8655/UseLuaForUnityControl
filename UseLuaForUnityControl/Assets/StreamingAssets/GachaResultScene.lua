--直接Unityには登録しないスクリプト。いわゆる、ライブラリ化した奴

-- クラス定義
GachaResultScene = {}

-- コンストラクタ
function GachaResultScene.new()
	local this = SceneBase.new()

	this.OpenCharacterTypeList = {}
	this.AddParameterList = {}
	this.CanNotAddParameterItemList = {}

	-- メソッド定義
	-- 初期化
	this.SceneBaseInitialize = this.Initialize
	this.Initialize = function(self)


		if self.IsInitialized == false then
			LuaChangeScene("GachaResult", "MainCanvas")
			LuaFindObject("GachaResultScrollContent")
			LuaFindObject("GachaResultLayoutRoot")
			LuaSetPosition("GachaResultLayoutRoot", 0, 0, 0)
			
			LuaFindObject("GachaResultParameterUpRoot")
			CharacterParameterUpDialog.Instance():Initialize()
			CharacterParameterUpDialog.Instance():SetParent("GachaResultParameterUpRoot") 
		else
			LuaSetPosition("GachaResultLayoutRoot", 0, 0, 0)
			LuaChangeScene("GachaResult", "MainCanvas")
		end
			
		LuaSetButtonInteractable("GachaResultSecondOkButton", false)
		
		LuaSetActive("HeaderObject", false)
		LuaSetActive("FooterObject", false)

		--self.OpenCharacterTypeList = GameManager.Instance():GetGachaItemCharacterTypeList()
		self.AddParameterList = GameManager.Instance():GetGachaItemAddParameterList()
		self.CanNotAddParameterItemList = GameManager.Instance():GetGachaItemCanNotAddParameterList()
		
		local list = GameManager.Instance():GetGachaItemList()

		for i = 1, #list do
			LuaLoadPrefabAfter(list[i]:GetPrefabName(), "GachaResultItemNode"..i, "GachaResultScrollContent")
		end  

		--Debug
		--for i = 1, #self.OpenCharacterTypeList do
		--	local count = 0
		--	for j = 1, #self.OpenCharacterTypeList[i] do
		--		count = count + 1
		--	end
		--	LuaUnityDebugLog(i.."番目".."/"..count.."個")
		--end
		--

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
		local list = GameManager.Instance():GetGachaItemList()
		for i = 1, #list do
			LuaDestroyObject("GachaResultItemNode"..i)
		end
		
		this:SceneBaseEnd()
	end
	
	-- 有効かどうか
	this.IsActive = function(self)
		return self.IsActive
	end
	
	-- ボタン
	this.OnClickButton = function(self, buttonName)
		if buttonName == "GachaResultFirstOkButton" then
			LuaSetButtonInteractable("GachaResultSecondOkButton", false)
			CallbackManager.Instance():AddCallback("GachaResultScene_F2SCallback", {self}, self.F2SCallback)
			LuaPlayAnimator("GachaResultLayoutRoot", "F2S", false, false, "LuaCallback", "GachaResultScene_F2SCallback")
		end
		
		if buttonName == "GachaResultSecondOkButton" then
			CharacterParameterUpDialog.Instance():CloseDialog()
		end
		
		CharacterParameterUpDialog.Instance():OnClickButton(buttonName)
	end

	
	
	--this.F2SCallback = function(arg, unityArg)
	--	local self =  arg[1]

	--	local characterItemList = self.OpenCharacterTypeList[1]
	--	if #characterItemList == 0 then
	--		table.remove(self.OpenCharacterTypeList, 1)
	--		if #self.OpenCharacterTypeList > 0 then
	--			LuaUnityDebugLog("length"..#self.OpenCharacterTypeList)
	--			self.F2SCallback({self})
	--		else
	--			if #self.CanNotAddParameterItemList == 0 then
	--				SceneManager.Instance():ChangeScene(SceneNameEnum.Gacha)
	--			else
	--				-- 本当は、ここでお金の加算ダイアログを表示する
	--				SceneManager.Instance():ChangeScene(SceneNameEnum.Gacha)
	--			end
	--		end
	--	else
	--		local addHp = 0
	--		local addAttack = 0
	--		local addDeffense = 0
	--		local addFriendPoint = 0
	--		for i = 1, #characterItemList do
	--			if characterItemList[i]:GetParameterType() == ParameterType.AddHp then
	--				addHp = addHp + characterItemList[i]:GetAddValue()
	--			elseif characterItemList[i]:GetParameterType() == ParameterType.AddAttack then
	--				addAttack = addAttack + characterItemList[i]:GetAddValue()
	--			elseif characterItemList[i]:GetParameterType() == ParameterType.AddDeffense then
	--				addDeffense = addDeffense + characterItemList[i]:GetAddValue()
	--			elseif characterItemList[i]:GetParameterType() == ParameterType.AddFriend then
	--				addFriendPoint = addFriendPoint + characterItemList[i]:GetAddValue()
	--			end
	--		end
	--		
	--		local characterType = characterItemList[1]:GetKindType()
	--		table.remove(self.OpenCharacterTypeList, 1)

	--		local baseHp = PlayerCharacterConfig[characterType].BaseParameter:MaxHp()
	--		local baseAttack = PlayerCharacterConfig[characterType].BaseParameter:Attack()
	--		local baseDeffense = PlayerCharacterConfig[characterType].BaseParameter:Deffense()
	--		local baseFriendPoint = PlayerCharacterConfig[characterType].BaseParameter:FriendPoint()
	--		local characterAddParameter = SaveObject.CharacterList[characterType]
	--		
	--		local saveHp = characterAddParameter[CharacterParameterEnum.AddHp]
	--		local saveAttack = characterAddParameter[CharacterParameterEnum.AddAttack]
	--		local saveDeffense = characterAddParameter[CharacterParameterEnum.AddDeffense]
	--		local saveFriendPoint = characterAddParameter[CharacterParameterEnum.FriendPoint]

	--		CharacterParameterUpDialog.Instance():OpenDialog(
	--			function()
	--				LuaSetButtonInteractable("GachaResultSecondOkButton", true)
	--			end,
	--			function()
	--				LuaSetButtonInteractable("GachaResultSecondOkButton", false)
	--				if #self.OpenCharacterTypeList > 0 then
	--					LuaUnityDebugLog("length"..#self.OpenCharacterTypeList)
	--					self.F2SCallback({self})
	--				else
	--					SceneManager.Instance():ChangeScene(SceneNameEnum.Gacha)
	--				end
	--			end,
	--			baseHp+saveHp,
	--			baseAttack+saveAttack,
	--			baseDeffense+saveDeffense,
	--			baseFriendPoint+saveFriendPoint,
	--			addHp,
	--			addAttack,
	--			addDeffense,
	--			addFriendPoint
	--		)
	--	end
	--end
	
	this.F2SCallback = function(arg, unityArg)
		local self =  arg[1]

		local data = self.AddParameterList[1]
		if self:CheckAddParameterEnable(data.Parameter) == false then
			table.remove(self.AddParameterList, 1)
			if #self.AddParameterList > 0 then
				LuaUnityDebugLog("length"..#self.AddParameterList)
				self.F2SCallback({self})
			else
				if #self.CanNotAddParameterItemList == 0 then
					SceneManager.Instance():ChangeScene(SceneNameEnum.Gacha)
				else
					-- 本当は、ここでお金の加算ダイアログを表示する
					SceneManager.Instance():ChangeScene(SceneNameEnum.Gacha)
				end
			end
		else
			local addHp = data.Parameter:MaxHp()
			local addAttack = data.Parameter:Attack()
			local addDeffense = data.Parameter:Deffense()
			local addFriendPoint = data.Parameter:FriendPoint()
			
			local characterType = data.CharacterType
			table.remove(self.AddParameterList, 1)

			local baseHp = PlayerCharacterConfig[characterType].BaseParameter:MaxHp()
			local baseAttack = PlayerCharacterConfig[characterType].BaseParameter:Attack()
			local baseDeffense = PlayerCharacterConfig[characterType].BaseParameter:Deffense()
			local baseFriendPoint = PlayerCharacterConfig[characterType].BaseParameter:FriendPoint()
			local characterAddParameter = SaveObject.CharacterList[characterType]
			
			local saveHp = characterAddParameter[CharacterParameterEnum.AddHp]
			local saveAttack = characterAddParameter[CharacterParameterEnum.AddAttack]
			local saveDeffense = characterAddParameter[CharacterParameterEnum.AddDeffense]
			local saveFriendPoint = characterAddParameter[CharacterParameterEnum.FriendPoint]

			CharacterParameterUpDialog.Instance():OpenDialog(
				function()
					LuaSetButtonInteractable("GachaResultSecondOkButton", true)
				end,
				function()
					LuaSetButtonInteractable("GachaResultSecondOkButton", false)
					if #self.AddParameterList > 0 then
						LuaUnityDebugLog("length"..#self.AddParameterList)
						self.F2SCallback({self})
					else
						SceneManager.Instance():ChangeScene(SceneNameEnum.Gacha)
					end
				end,
				baseHp+saveHp,
				baseAttack+saveAttack,
				baseDeffense+saveDeffense,
				baseFriendPoint+saveFriendPoint,
				addHp,
				addAttack,
				addDeffense,
				addFriendPoint
			)
		end
	end
	
	this.CheckAddParameterEnable = function(self, characterParameter)
		local isEnable = true
		if	characterParameter:MaxHp() == 0 and 
			characterParameter:Attack() == 0 and 
			characterParameter:Deffense() == 0 and
			characterParameter:FriendPoint() == 0 then
			isEnable = false
		end

		return isEnable
	end

	return this
end
