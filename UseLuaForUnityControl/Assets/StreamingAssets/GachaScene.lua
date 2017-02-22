--直接Unityには登録しないスクリプト。いわゆる、ライブラリ化した奴

-- クラス定義
GachaScene = {}

-- コンストラクタ
function GachaScene.new()
	local this = SceneBase.new()
	this.GachaSelectIndex = 1

	-- メソッド定義
	-- 初期化
	this.SceneBaseInitialize = this.Initialize
	this.Initialize = function(self)
		self.GachaSelectIndex = 1

		LuaChangeScene("Gacha", "MainCanvas")
		
		LuaSetActive("HeaderObject", false)
		LuaSetActive("FooterObject", false)
	
		LuaFindObject("GachaNekoPointText")
		LuaFindObject("GachaBillingPointText")
		LuaFindObject("GachaDetailText")

		local mochiPoint = GameManager.Instance():GetMochiPointValue()
		LuaSetText("GachaNekoPointText", mochiPoint)
		
		local billingPoint = GameManager.Instance():GetBillingPointValue()
		LuaSetText("GachaBillingPointText", billingPoint)
		
		if self.IsInitialized == false then
			GachaRollDialog.Instance():Initialize()
			GachaRollDialog.Instance():SetParent("GachaDialogRoot") 
		end

		self:UpdateGachaDetailText()
		
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
		if buttonName == "GachaSceneBackButton" then
			SceneManager.Instance():ChangeScene(SceneNameEnum.Home)
		end
		if buttonName == "GachaScene_GachaButton" then
			local mochiPoint = GameManager.Instance():GetMochiPointValue()
			--if mochiPoint < 100 then
			--	return
			--end
			--
			--GameManager.Instance():AddMochiPointValue(-100)
			--mochiPoint = GameManager.Instance():GetMochiPointValue()
			--SaveObject.HaveMochiPointValue = GameManager.Instance():GetMochiPointValue()
			--FileIOManager.Instance():Save()

			--LuaSetText("GachaNekoPointText", mochiPoint)

			-- 仮でパラメータアップをして保存してみる

			-- キャラの残り回数を取得
			-- その残り回数分を上回らない程度に、引いたポイントを適用
			-- ガチャを引いて、ランダムでどれかのパラメータがプラス1
			-- セーブオブジェクトに適用し、セーブを更新
			-- 

			local currentPlayerCharater = GameManager.Instance():GetSelectPlayerCharacterData()
			local characterAddParameter = SaveObject.CharacterList[currentPlayerCharater.IdIndex]

			if characterAddParameter[CharacterParameterEnum.RemainParameterPoint] == 0 then
				LuaUnityDebugLog("Remain0!!!!")
				return
			end
				
			local idx = math.random(1, 3)
			if idx == 1 then
				LuaUnityDebugLog("HP")
				characterAddParameter[CharacterParameterEnum.AddHp] = characterAddParameter[CharacterParameterEnum.AddHp] + 1
			elseif idx == 2 then
				LuaUnityDebugLog("Attack")
				characterAddParameter[CharacterParameterEnum.AddAttack] = characterAddParameter[CharacterParameterEnum.AddAttack] + 1
			elseif idx == 3 then
				LuaUnityDebugLog("Deffense")
				characterAddParameter[CharacterParameterEnum.AddDeffense] = characterAddParameter[CharacterParameterEnum.AddDeffense] + 1
			end
			characterAddParameter[CharacterParameterEnum.RemainParameterPoint] = characterAddParameter[CharacterParameterEnum.RemainParameterPoint] - 1
			FileIOManager.Instance():Save()
		end
		
		if buttonName == "GachaSceneFirstButton" then
			self.GachaSelectIndex = 1
			self:UpdateGachaDetailText()
			--local mochiPoint = GameManager.Instance():GetMochiPointValue()
			--GachaRollDialog.Instance():OpenDialog(
			--	function(count)
			--		LuaUnityDebugLog(count)
			--		local list = self:RollGachaDebug(GachaList[1], count)
			--		GameManager.Instance():SetGachaItemList(list)
			--		SceneManager.Instance():ChangeScene(SceneNameEnum.GachaEffect)
			--	end,
			--	Gacha_Wood.Price,
			--	mochiPoint
			--)
		elseif buttonName == "GachaSceneSecondButton" then
			self.GachaSelectIndex = 2
			self:UpdateGachaDetailText()
			--self:RollGachaDebug(GachaList[2], 100)
		elseif buttonName == "GachaSceneThirdButton" then
			self.GachaSelectIndex = 3
			self:UpdateGachaDetailText()
			--self:RollGachaDebug(GachaList[3], 100)
		elseif buttonName == "GachaSceneFourthButton" then
			self.GachaSelectIndex = 4
			self:UpdateGachaDetailText()
			--self:RollGachaDebug(GachaList[4], 100)
		end
		
		if buttonName == "GachaDebugAddMoneyButton" then
			-- とりあえず、デバッグでポイントをマイナス分減らす(つまり、増やす)
			self:UpdateMochiPoint(-1000000, GachaMoneyType.ExpPoint)
			self:DebugBillingPointAdd()
		end
		
		if buttonName == "GachaSceneRollButton" then
			local mochiPoint = GameManager.Instance():GetMochiPointValue()
			GachaRollDialog.Instance():OpenDialog(
				function(count)
					LuaUnityDebugLog(count)
					local list = self:RollGachaDebug(GachaList[self.GachaSelectIndex], count)
					GameManager.Instance():SetGachaItemList(list)
					SceneManager.Instance():ChangeScene(SceneNameEnum.GachaEffect)
				end,
				GachaList[self.GachaSelectIndex].Price,
				mochiPoint
			)
		end
		
		if buttonName == "GachaSceneItemListButton" then
			if GachaList[self.GachaSelectIndex].MoneyType == GachaMoneyType.ExpPoint then
				DialogManager.Instance():OpenDialog(
					"課金ガチャじゃないので、排出内容は内緒☆",
					function()
					end,
					function()
					end,
					function()
					end,
					function()
					end
				)
			end
		end

		GachaRollDialog.Instance():OnClickButton(buttonName)
	end

	this.RollGachaDebug = function(self, gachaConfig, rollCount)
		local usePrice = gachaConfig.Price * rollCount
		local moneyType = gachaConfig.MoneyType

		-- エラーチェックしないとね！
		local point = GameManager.Instance():GetMochiPointValue()
		if point < usePrice then
			return {}
		end
		
		local getItemList = gachaConfig.GachaData:RollGacha(rollCount)
		self:UpdateCharacterParameter(getItemList)
		self:UpdateMochiPoint(usePrice, moneyType)

		return getItemList
	end
	
	this.UpdateMochiPoint = function(self, usePriceValue, moneyType)
		GameManager.Instance():AddMochiPointValue(-usePriceValue)
		local mochiPoint = GameManager.Instance():GetMochiPointValue()
		SaveObject.HaveMochiPointValue = GameManager.Instance():GetMochiPointValue()
		FileIOManager.Instance():Save()
		LuaSetText("GachaNekoPointText", mochiPoint)
	end
	
	this.UpdateGachaDetailText = function(self)
		local gachaData = GachaList[self.GachaSelectIndex]
		LuaSetText("GachaDetailText", gachaData.Detail)
	end
	
	this.DebugBillingPointAdd = function(self)
		GameManager.Instance():AddBillingPointValue(9999)
		local point = GameManager.Instance():GetBillingPointValue()
		SaveObject.HaveBillingPointValue = GameManager.Instance():GetBillingPointValue()
		FileIOManager.Instance():Save()
		LuaSetText("GachaBillingPointText", point)
	end
	
	this.UpdateCharacterParameter = function(self, itemList)
		local currentPlayerCharater = GameManager.Instance():GetSelectPlayerCharacterData()
		local characterAddParameter = SaveObject.CharacterList[currentPlayerCharater.IdIndex]

		local characterTypeList = {}
		for i = 1, CharacterTypeEnum.Max do
			table.insert(characterTypeList, {})
		end
		
		for i = 1, #itemList do
			if itemList[i]:GetItemType() == ItemType.ParameterUp then
				table.insert(characterTypeList[itemList[i]:GetKindType()], itemList[i])
			end
		end  

		local canNotAddParameterItemList = {}
		local addParameterList = {}

		for i = 1, #characterTypeList do
			local addHp = 0
			local addAttack = 0
			local addDeffense = 0
			local addFriendPoint = 0

			local playerCharacter = PlayerCharacterConfig[i]
			local characterAddParameter = SaveObject.CharacterList[playerCharacter.IdIndex]
			local remainPoint = characterAddParameter[CharacterParameterEnum.RemainParameterPoint]

			for j = 1, #characterTypeList[i] do
				local item = characterTypeList[i][j]
				if item:GetParameterType() == ParameterType.FriendPoint then
					addFriendPoint = addFriendPoint + item:GetAddValue()
				else
					if remainPoint <= 0 then
						table.insert(canNotAddParameterItemList, item)
					else
						if item:GetParameterType() == ParameterType.AddHp then
							addHp = addHp + item:GetAddValue()
						elseif item:GetParameterType() == ParameterType.AddAttack then
							addAttack = addAttack + item:GetAddValue()
						elseif item:GetParameterType() == ParameterType.AddDeffense then
							addDeffense = addDeffense + item:GetAddValue()
						end
						remainPoint = remainPoint - 1
					end
				end
			end
		
			local characterParameter = CharacterParameter.new(addHp, addAttack, addDeffense, addFriendPoint)

			local data = {
				CharacterType = 0,
				Parameter = {},
			}

			data.CharacterType = i
			data.Parameter = characterParameter
			table.insert(addParameterList, data)
			
			characterAddParameter[CharacterParameterEnum.RemainParameterPoint] = remainPoint
		
			characterAddParameter[CharacterParameterEnum.AddHp] = characterAddParameter[CharacterParameterEnum.AddHp] + addHp
			characterAddParameter[CharacterParameterEnum.AddAttack] = characterAddParameter[CharacterParameterEnum.AddAttack] + addAttack
			characterAddParameter[CharacterParameterEnum.AddDeffense] = characterAddParameter[CharacterParameterEnum.AddDeffense] + addDeffense
			characterAddParameter[CharacterParameterEnum.FriendPoint] = characterAddParameter[CharacterParameterEnum.FriendPoint] + addFriendPoint
			if characterAddParameter[CharacterParameterEnum.FriendPoint] >= 100 then
				characterAddParameter[CharacterParameterEnum.FriendPoint] = 100
			end
		end
		FileIOManager.Instance():Save()

		GameManager.Instance():SetGachaItemAddParameterList(addParameterList)
		GameManager.Instance():SetGachaItemCanNotAddParameterList(canNotAddParameterItemList)
	end
	
	return this
end

