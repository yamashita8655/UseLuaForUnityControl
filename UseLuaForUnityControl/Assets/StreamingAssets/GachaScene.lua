--直接Unityには登録しないスクリプト。いわゆる、ライブラリ化した奴

-- クラス定義
GachaScene = {}

-- コンストラクタ
function GachaScene.new()
	local this = SceneBase.new()

	-- メソッド定義
	-- 初期化
	this.SceneBaseInitialize = this.Initialize
	this.Initialize = function(self)
		LuaChangeScene("Gacha", "MainCanvas")
		
		LuaSetActive("HeaderObject", false)
		LuaSetActive("FooterObject", false)
	
		LuaFindObject("GachaScene_MochiPointText")
		local mochiPoint = GameManager.Instance():GetMochiPointValue()
		LuaSetText("GachaScene_MochiPointText", mochiPoint)
		
		if self.IsInitialized == false then
			GachaRollDialog.Instance():Initialize()
			GachaRollDialog.Instance():SetParent("DialogRoot") 
		end
		
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
		if buttonName == "GachaBackButton" then
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

			--LuaSetText("GachaScene_MochiPointText", mochiPoint)

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
		
		if buttonName == "GachaScene_GachaWood" then
			local mochiPoint = GameManager.Instance():GetMochiPointValue()
			GachaRollDialog.Instance():OpenDialog(
				function(count)
					LuaUnityDebugLog(count)
					local list = self:RollGachaDebug(Gacha_Wood, count)
					GameManager.Instance():SetGachaItemList(list)
					SceneManager.Instance():ChangeScene(SceneNameEnum.GachaEffect)
				end,
				Gacha_Wood.Price,
				mochiPoint
			)
			--self:RollGachaDebug(Gacha_Wood, 100)
		elseif buttonName == "GachaScene_GachaBronze" then
			self:RollGachaDebug(Gacha_Bronze, 100)
		elseif buttonName == "GachaScene_GachaSilver" then
			self:RollGachaDebug(Gacha_Silver, 100)
		elseif buttonName == "GachaScene_GachaGold" then
			self:RollGachaDebug(Gacha_Gold, 100)
		end
		
		if buttonName == "GachaDebugAddMoneyButton" then
			-- とりあえず、デバッグでポイントをマイナス分減らす(つまり、増やす)
			self:UpdateMochiPoint(-1000000, GachaMoneyType.ExpPoint)
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
		local hpCount = 0
		local attackCount = 0
		local deffenseCount = 0
		for i = 1, #getItemList do
			local item = getItemList[i]
			local parameterType = item:GetParameterType()
			if parameterType == ParameterType.AddHp then
				hpCount = hpCount + 1
			elseif parameterType == ParameterType.AddAttack then
				attackCount = attackCount + 1
			elseif parameterType == ParameterType.AddDeffense then
				deffenseCount = deffenseCount + 1
			end
		end
		LuaUnityDebugLog(hpCount.."/"..attackCount.."/"..deffenseCount)

		self:UpdateMochiPoint(usePrice, moneyType)

		return getItemList
	end
	
	this.UpdateMochiPoint = function(self, usePriceValue, moneyType)
		GameManager.Instance():AddMochiPointValue(-usePriceValue)
		mochiPoint = GameManager.Instance():GetMochiPointValue()
		SaveObject.HaveMochiPointValue = GameManager.Instance():GetMochiPointValue()
		FileIOManager.Instance():Save()
		LuaSetText("GachaScene_MochiPointText", mochiPoint)
	end
	
	return this
end

