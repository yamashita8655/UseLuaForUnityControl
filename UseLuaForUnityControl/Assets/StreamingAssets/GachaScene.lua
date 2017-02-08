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
	end
	
	return this
end

