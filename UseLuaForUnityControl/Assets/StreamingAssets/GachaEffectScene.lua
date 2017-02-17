--直接Unityには登録しないスクリプト。いわゆる、ライブラリ化した奴

-- クラス定義
GachaEffectScene = {}

-- コンストラクタ
function GachaEffectScene.new()
	local this = SceneBase.new()
	
	this.SpawnItemList = {}

	-- メソッド定義
	-- 初期化
	this.SceneBaseInitialize = this.Initialize
	this.Initialize = function(self)
		LuaChangeScene("GachaEffect", "MainCanvas")
		
		LuaSetActive("HeaderObject", false)
		LuaSetActive("FooterObject", false)
		
		LuaFindObject("GachaEffectAnimationRoot")

		for i = 1, 10 do
			LuaFindObject("GachaEffectSpawnMochiRoot"..i)
		end


		--self:ResetActiveMochiImage()

		local list = GameManager.Instance():GetGachaItemList()
		
		if #list > 10 then
			local rarityList = {}
			local isFull = false
			for i = 1, #list do
				if list[i]:GetRarity() == RarityType.SuperRare then
					table.insert(rarityList, list[i])
					if #rarityList >= 10 then
						isFull = true
						break
					end
				end
			end

			if isFull == false then
				for i = 1, #list do
					if list[i]:GetRarity() == RarityType.Rare then
						table.insert(rarityList, list[i])
						if #rarityList >= 10 then
							isFull = true
							break
						end
					end
				end
			end
			
			if isFull == false then
				for i = 1, #list do
					if list[i]:GetRarity() == RarityType.Normal then
						table.insert(rarityList, list[i])
						if #rarityList >= 10 then
							isFull = true
							break
						end
					end
				end
			end
			
			for i = 1, #rarityList do
				self:SetParentMochiImage(i, rarityList[i]:GetPrefabName())
			end
			self.SpawnItemList = rarityList

		else
			for i = 1, #list do
				self:SetParentMochiImage(i, list[i]:GetPrefabName())
			end
			self.SpawnItemList = list
		end

		this:SceneBaseInitialize()
	end
	
	-- フェード後初期化
	this.SceneBaseAfterInitialize = this.AfterInitialize
	this.AfterInitialize = function(self)
		this:SceneBaseAfterInitialize()
		CallbackManager.Instance():AddCallback("GachaEffect_PlayGacahEffect", {self}, self.GachaEffectCallback)
		LuaPlayAnimator("GachaEffectAnimationRoot", "Play", false, false, "LuaCallback", "GachaEffect_PlayGacahEffect")
	end
	
	-- 更新
	this.GachaEffectCallback = function(arg, unityArg)
		local self = arg[1]
		SceneManager.Instance():ChangeScene(SceneNameEnum.GachaResult)
	end


	-- 更新
	this.SceneBaseUpdate = this.Update
	this.Update = function(self, deltaTime)
		this:SceneBaseUpdate(deltaTime)
	end
	
	-- 終了
	this.SceneBaseEnd = this.End
	this.End = function(self)
		for i = 1, #self.SpawnItemList do
			LuaDestroyObject(self.SpawnItemList[i]:GetPrefabName()..i)
		end
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
	end
	
	-- 
	this.SetParentMochiImage = function(self, index, prefabName)
		--if rarity == RarityType.Normal then
		--	LuaSetActive("GachaEffectMochiNormalImage"..index, true)
		--	LuaSetActive("GachaEffectMochiSilverImage"..index, false)
		--	LuaSetActive("GachaEffectMochiGoldImage"..index, false)
		--elseif rarity == RarityType.Rare then
		--	LuaSetActive("GachaEffectMochiNormalImage"..index, false)
		--	LuaSetActive("GachaEffectMochiSilverImage"..index, true)
		--	LuaSetActive("GachaEffectMochiGoldImage"..index, false)
		--elseif rarity == RarityType.SuperRare then
		--	LuaSetActive("GachaEffectMochiNormalImage"..index, false)
		--	LuaSetActive("GachaEffectMochiSilverImage"..index, false)
		--	LuaSetActive("GachaEffectMochiGoldImage"..index, true)
		--end
		LuaLoadPrefabAfter(prefabName, prefabName..index, "GachaEffectSpawnMochiRoot"..index)
	end
	
	this.ResetActiveMochiImage = function(self)
		for i = 1, 10 do
			LuaSetActive("GachaEffectMochiNormalImage"..i, false)
			LuaSetActive("GachaEffectMochiSilverImage"..i, false)
			LuaSetActive("GachaEffectMochiGoldImage"..i, false)
		end
	end

	return this
end

