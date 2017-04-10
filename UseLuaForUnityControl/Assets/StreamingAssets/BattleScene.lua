﻿--直接Unityには登録しないスクリプト。いわゆる、ライブラリ化した奴

-- クラス定義
BattleScene = {}

-- コンストラクタ
function BattleScene.new()
	local this = SceneBase.new()

	this.EndTime = 0
	this.EndTimeCounter = 0
	
	this.EndCheckInterval = 5
	this.EndCheckIntervalCounter = 0
	
	this.AlignScale		= Vector3.new(1.0, 1.0, 1.0)-- 画面表示の拡縮調整
	this.AlignPosition	= Vector3.new(0.0, 0.0, 0.0)-- 画面表示のポジション調整
	
	this.IsGamePause = false
	this.ComboCount = 0
	this.GetKarikari = 0
	
	-- メソッド定義
	-- 初期化
	this.SceneBaseInitialize = this.Initialize
	this.Initialize = function(self)
		LuaChangeScene("Battle", "MainCanvas")
		
		PlayerManager.Instance():Initialize()
		BulletManager.Instance():Initialize()
		EffectManager.Instance():Initialize()
		EnemyManager.Instance():Initialize()
		AreaCellManager.Instance():Initialize()
		
		LuaLoadPrefabAfter("battlescene", "LoseEffect", "LoseEffect", "BattleDialogRoot")
		LuaSetActive("LoseEffect", false)
		
		LuaLoadPrefabAfter("battlescene", "WinEffect", "WinEffect", "BattleDialogRoot")
		LuaSetActive("WinEffect", false)

		LuaLoadPrefabAfter("battlescene", "BattleStartEffect", "BattleStartEffect", "BattleDialogRoot")
		LuaSetActive("BattleStartEffect", false)
		
		LuaFindObject("BattleComboLabel")
		LuaFindObject("BattleComboCounterText")
		LuaSetActive("BattleComboLabel", false)
		LuaSetActive("BattleComboCounterText", false)
		
		this.IsGamePause = true
		this.ComboCount = 0
		this.GetKarikari = 0
		
		selectQuestId = GameManager.Instance():GetSelectQuestId()
		enemySpawnTable = QuestConfig[selectQuestId].EnemySpawnTable

		EnemyManager:CreateSpawnController(enemySpawnTable)
		self.EndTime = enemySpawnTable.EndTime
		self.EndTimeCounter = 0
		self.EndCheckIntervalCounter = 0
		
		local posx = ScreenWidth/2
		local posy = ScreenHeight/2
	
		selectCharacter = nil
		selectCharacter = GameManager.Instance():GetSelectPlayerCharacterData()
		PlayerManager.Instance():CreatePlayer(selectCharacter, posx, posy, 0)
		
		--Test
		local enemyPrefabNameList = {}
		local spawnTable = enemySpawnTable.Table
		for i = 1, #spawnTable do
			local spawnData = spawnTable[i].SpawnData
			local enemyData = spawnData.EnemyType
			if enemyData.EnemyType == EnemyTypeEnum.BulletShooter then
				local enemyBulletList = enemyData.EquipBulletList
				for j = 1, #enemyBulletList do
					local prefabName = enemyBulletList[j].PrefabName
					table.insert(enemyPrefabNameList, prefabName)
				end
			end
		end
		
		local outputList, dup = UtilityFunction.Instance().ListUniq(enemyPrefabNameList) 
		for i,v in pairs(outputList) do
			local prefabName = i
			BulletManager.Instance():CreateBulletTest(prefabName, CharacterType.Enemy)
		end
		
		--Test
		local player = PlayerManager:Instance():GetPlayer()
		local skillConfig = player:GetSkillConfig()
		local skillTable = skillConfig:GetSkillTable()
		local bulletList = skillTable[SkillTypeEnum.Bullet]
		
		local prefabNameList = {}
		for i = 1, #bulletList do
			local bulletData = bulletList[i]
			local bulletConfigList = bulletData.EquipBulletList
			local bulletConfig = bulletConfigList[1]
			local prefabName = bulletConfig.PrefabName
			table.insert(prefabNameList, prefabName)
		end
		
		local outputList, dup = UtilityFunction.Instance().ListUniq(prefabNameList) 
		for i,v in pairs(outputList) do
			local prefabName = i
			BulletManager.Instance():CreateBulletTest(prefabName, CharacterType.Player)
		end
		
		LuaFindObject("BattleObjectRoot")
		LuaFindObject("ExpText")
		LuaFindObject("BattleKarikariText")
		LuaFindObject("BattleDialogRoot")

		LuaSetText("ExpText", 0)
		LuaSetText("BattleKarikariText", 0)
		
		--LuaSetScale("BattleObjectRoot", 1.0, 1.0, 1.0)
		LuaSetScale("BattleObjectRoot", 0.7, 0.7, 0.7)
		--self.AlignPosition.x = -200
		--self.AlignPosition.y = -200
		--self.AlignPosition.z = 0
		LuaSetPosition("BattleObjectRoot", self.AlignPosition.x, self.AlignPosition.y, self.AlignPosition.z)
		
		LuaSetActive("HeaderObject", false)
		LuaSetActive("FooterObject", false)
		
		if self.IsInitialized == false then
			SkillLevelUpDialog.Instance():Initialize()
			SkillLevelUpDialog.Instance():SetParent("BattleDialogRoot") 
			
			ResultDialog.Instance():Initialize()
			ResultDialog.Instance():SetParent("BattleDialogRoot") 
		end

		self:LoadSaveData()
		
		this:SceneBaseInitialize()
	end


	-- フェード後初期化
	this.SceneBaseAfterInitialize = this.AfterInitialize
	this.AfterInitialize = function(self)
		this:SceneBaseAfterInitialize()
		self:BattleStartSequence()
	end
	
	-- 更新
	this.SceneBaseUpdate = this.Update
	this.Update = function(self, deltaTime)
		this:SceneBaseUpdate(deltaTime)
		
		if self.IsGamePause == false then
			self.EndTimeCounter = self.EndTimeCounter + deltaTime
			if self.EndTimeCounter > self.EndTime then
				self.EndCheckIntervalCounter = self.EndCheckIntervalCounter + deltaTime
				if self.EndCheckIntervalCounter > self.EndCheckInterval then
					isEnd = self.CheckBattleEnd()
					if isEnd == true then
						--SceneManager.Instance():ChangeScene(SceneNameEnum.Home)
						self.IsGamePause = true
						self:WinSequence()
					end
					self.EndCheckIntervalCounter = 0
				end
			end
	
			PlayerManager.Instance():Update(GameManager:GetBattleDeltaTime())
			BulletManager.Instance():Update(GameManager:GetBattleDeltaTime())
			EnemyManager.Instance():Update(GameManager:GetBattleDeltaTime())
			--self:CheckBump()
			self:CheckBumpTest()

			local player = PlayerManager.Instance():GetPlayer()
			local exp = player:GetEXP()
			exp = math.floor(exp)
			LuaSetText("ExpText", exp)
			
			LuaSetText("BattleKarikariText", self.GetKarikari)
			
			if player:IsAlive() == false then
				self.IsGamePause = true
				self:LoseSequence()
			end
		end
	end
	
	-- バトル開始エフェクト
	this.BattleStartSequence = function(self)
		CallbackManager.Instance():AddCallback("Battle_BattleStartSequence", {self}, self.BattleStartSequenceCallback)
		LuaPlayAnimator("BattleStartEffect", "Play", false, true, "LuaCallback", "Battle_BattleStartSequence")
	end
	
	this.BattleStartSequenceCallback = function(arg, unityArg)
		local self = arg[1]
		LuaUnityDebugLog("callback!!!!")
		LuaSetActive("BattleStartEffect", false)
		self.IsGamePause = false
	end
	
	-- 勝ちエフェクト
	this.WinSequence = function(self)
		CallbackManager.Instance():AddCallback("Battle_WinSequence", {self}, self.WinSequenceCallback)
		LuaPlayAnimator("WinEffect", "Play", false, true, "LuaCallback", "Battle_WinSequence")
	end
	
	this.WinSequenceCallback = function(arg, unityArg)
		local self = arg[1]
		LuaUnityDebugLog("callback!!!!")
		LuaSetActive("WinEffect", false)
		
		local player = PlayerManager.Instance():GetPlayer()
		local exp = player:GetEXP()
		
		ResultDialog.Instance():OpenDialog(
			function()
				SceneManager.Instance():ChangeScene(SceneNameEnum.Home)
			end,
			exp,
			false
		)
	end
	
	-- 負けエフェクト
	this.LoseSequence = function(self)
		CallbackManager.Instance():AddCallback("Battle_LoseSequence", {self}, self.LoseSequenceCallback)
		LuaPlayAnimator("LoseEffect", "Play", false, true, "LuaCallback", "Battle_LoseSequence")
	end
	
	this.LoseSequenceCallback = function(arg, unityArg)
		local self = arg[1]
		LuaUnityDebugLog("callback!!!!")
		LuaSetActive("LoseEffect", false)
		
		local player = PlayerManager.Instance():GetPlayer()
		local exp = player:GetEXP()
		
		ResultDialog.Instance():OpenDialog(
			function()
				SceneManager.Instance():ChangeScene(SceneNameEnum.Home)
			end,
			exp,
			true
		)
	end
	
	-- 終了
	this.SceneBaseEnd = this.End
	this.End = function(self)
		this:SceneBaseEnd()
		
		local player = PlayerManager.Instance():GetPlayer()
		local exp = player:GetEXP()
		GameManager.Instance():AddMochiPointValue(exp)
		SaveObject.HaveMochiPointValue = GameManager.Instance():GetMochiPointValue()
	
		EnemyManager.Instance():Release()
		BulletManager.Instance():Release()
		PlayerManager.Instance():Release()
		EffectManager.Instance():Release()

		GameManager.Instance():AddKarikariValue(self.GetKarikari)
		SaveObject.CustomScene_HaveKarikariValue = GameManager.Instance():GetKarikariValue()
		FileIOManager.Instance():Save()

	end
	
	-- バトルが終わったかどうか
	this.CheckBattleEnd = function(self)
		isEnd = false
		enemyCount = #EnemyManager:GetList() 
		if enemyCount == 0 then
			isEnd = true
		end
		return isEnd
	end
	
	-- 有効かどうか
	this.IsActive = function(self)
		return self.IsActive
	end
	
	-- ボタン
	this.OnClickButton = function(self, buttonName)
		if buttonName == "BattleOptionButton" then
			self.IsGamePause = true
			EffectManager.Instance():PauseEffect()
			SkillLevelUpDialog.Instance():OpenDialog(
				function()
					self.IsGamePause = false
					EffectManager.Instance():ResumeEffect()
				end
			)
		end
		if buttonName == "BattleExitButton" then
			self.IsGamePause = true
			DialogManager.Instance():OpenDialog(
				"ねずみ退治をやめますか？\n※獲得したポイント等は破棄されます",
				function()
				end,
				function()
				end,
				function()
					SceneManager.Instance():ChangeScene(SceneNameEnum.Home)
				end,
				function()
					self.IsGamePause = false
				end
			)
		end
		SkillLevelUpDialog.Instance():OnClickButton(buttonName)
		ResultDialog.Instance():OnClickButton(buttonName)
	end
	
	-- 画面タッチ判定
	this.OnMouseDown = function(self, touchx, touchy)
		if self.IsGamePause == false then
			--local calcTouchX = touchx - self.AlignPosition.x
			--local calcTouchY = touchy - self.AlignPosition.y
			local calcTouchX = touchx - (self.AlignPosition.x*CanvasFactor)
			local calcTouchY = touchy - (self.AlignPosition.y*CanvasFactor)
			PlayerManager.Instance():OnMouseDown(calcTouchX, calcTouchY)
		end
	end
	
	this.OnMouseDrag = function(self, touchx, touchy)
		if self.IsGamePause == false then
			--local calcTouchX = touchx - self.AlignPosition.x
			--local calcTouchY = touchy - self.AlignPosition.y
			local calcTouchX = touchx - (self.AlignPosition.x*CanvasFactor)
			local calcTouchY = touchy - (self.AlignPosition.y*CanvasFactor)
			PlayerManager.Instance():OnMouseDrag(calcTouchX, calcTouchY)
		end
	end
	
	this.OnMouseUp = function(self, touchx, touchy)
		if self.IsGamePause == false then
			local calcTouchX = touchx - (self.AlignPosition.x*CanvasFactor)
			local calcTouchY = touchy - (self.AlignPosition.y*CanvasFactor)
			PlayerManager.Instance():OnMouseUp(calcTouchX, calcTouchY)
		end
	end


	this.CheckBumpTest = function(self)
		AreaCellManager.Instance():Clear() 

		playerBulletList = BulletManager.Instance():GetPlayerBulletList()
		enemyBulletList = BulletManager.Instance():GetEnemyBulletList()
		enemyList = EnemyManager.Instance():GetList()
		player = PlayerManager:GetPlayer()

		local LoopCounter = 0

		for i = 1, #playerBulletList do
			local bullet = playerBulletList[i]
			local cellNumberList = AreaCellManager.Instance():GetCellNumber(bullet) 
			for j = 1, #cellNumberList do
				local cellNumber = cellNumberList[j]
				if cellNumber ~= -1 then
					AreaCellManager.Instance():AddPlayerBullet(bullet, cellNumber)
				end
				LoopCounter = LoopCounter + 1
			end
		end
		
		for i = 1, #enemyBulletList do
			local bullet = enemyBulletList[i]
			local cellNumberList = AreaCellManager.Instance():GetCellNumber(bullet) 
			for j = 1, #cellNumberList do
				local cellNumber = cellNumberList[j]
				if cellNumber ~= -1 then
					AreaCellManager.Instance():AddEnemyBullet(bullet, cellNumber)
				end
				LoopCounter = LoopCounter + 1
			end
		end
		
		for i = 1, #enemyList do
			local enemy = enemyList[i]
			local cellNumberList = AreaCellManager.Instance():GetCellNumber(enemy) 
			for j = 1, #cellNumberList do
				local cellNumber = cellNumberList[j]
				if cellNumber ~= -1 then
					AreaCellManager.Instance():AddEnemy(enemy, cellNumber)
				end
				LoopCounter = LoopCounter + 1
			end
		end
			
		local cellNumberList = AreaCellManager.Instance():GetCellNumber(player) 
		for j = 1, #cellNumberList do
			local cellNumber = cellNumberList[j]
			if cellNumber ~= -1 then
				AreaCellManager.Instance():AddPlayer(player, cellNumber)
			end
			LoopCounter = LoopCounter + 1
		end

		--AreaCellManager:GetCellNumber(position) 
		

		local list = AreaCellManager.Instance():GetBumpList()
		local bumpCounter = 0
		for i = 1, #list do
			local data = list[i]
			bumpCounter = bumpCounter + self:CheckBump2(data)
			LoopCounter = LoopCounter + 1
		end

		-- 死亡フラグが立っている物を削除する
		EnemyManager:RemoveDeadObject()
		BulletManager:RemoveDeadObject()

		--LuaUnityDebugLog("loop:"..LoopCounter)
		--LuaUnityDebugLog("bumpCounter:"..bumpCounter)
	end
	
	--当たり判定
	this.CheckBump2 = function(self, checkBumpObject)
		local LoopCounter = 0
		playerBulletList = checkBumpObject:GetPlayerBullet()
		enemyBulletList = checkBumpObject:GetEnemyBullet()
		enemyList = checkBumpObject:GetEnemy()
		player = PlayerManager:GetPlayer()

		local comboAddCounter = 0
		local takeDamage = false
	
		-- 弾と敵とのあたり判定
		-- 当たったオブジェクト双方に、DeadFlagのtrueを付与する
		if #playerBulletList > 0 and #enemyList > 0 then
			for bulletIndex = 1, #playerBulletList do
				for enemyIndex = 1, #enemyList do
					local enemy = enemyList[enemyIndex]
					local bullet = playerBulletList[bulletIndex]
	
					local enemyIsAlive = enemy:IsAlive()
					local bulletIsAlive = bullet:IsAlive()
	
					if (enemyIsAlive == false) or (bulletIsAlive == false) then
					else
						enemyPosition = enemy:GetPosition()
						enemyWidth, enemyHeight = enemy:GetSize()
	
						bulletPosition = bullet:GetPosition()
						bulletWidth, bulletHeight = bullet:GetSize()
	
						isHit = self:IsHit(enemyPosition.x, enemyPosition.y, enemyWidth, enemyHeight, bulletPosition.x, bulletPosition.y, bulletWidth, bulletHeight)
	
						if isHit == true then
							EffectManager.Instance():SpawnEffect(EffectNameEnum.HitEffect, enemy:GetPosition())
							local bulletAttack = bullet:GetAttack()
							enemy:AddNowHp(-bulletAttack)
							if enemy:IsAlive() == false then
								local exp = enemy:GetEXP()
								exp = exp * (1 + (self.ComboCount/1000))
								player:AddEXP(exp)
								comboAddCounter = comboAddCounter + 1
								local karikari = self:LotKarikari()
								if karikari == true then
									EffectManager.Instance():SpawnEffect(EffectNameEnum.KarikariEffect, enemy:GetPosition())
									self.GetKarikari = self.GetKarikari + 1
								end
							end
							bullet:AddNowHp(-1)
						end
					end
					LoopCounter = LoopCounter + 1
				end
			end
		end
		
		-- 敵と自キャラとのあたり判定
		-- 当たったら、敵の種別を判定して、削除する敵だったら、DeadFlagのtrueを付与する
		for enemyIndex = 1, #enemyList do
			enemy = enemyList[enemyIndex]
	
			enemyIsAlive = enemy:IsAlive()
	
			if (enemyIsAlive == false)then
			else
				enemyPosition = enemy:GetPosition()
				enemyWidth, enemyHeight = enemy:GetSize()
	
				playerPosition = player:GetPosition()
				playerWidth, playerHeight = player:GetSize()
	
				isHit = self:IsHit(enemyPosition.x, enemyPosition.y, enemyWidth, enemyHeight, playerPosition.x, playerPosition.y, playerWidth, playerHeight)
	
				if isHit == true then
					local attack = enemy:GetAttack()
					enemy:SetNowHp(0)
					player:AddNowHp(-attack)
					takeDamage = true
				end
			end
			LoopCounter = LoopCounter + 1
		end
		
		-- 敵弾と自キャラとのあたり判定
		-- 当たったら、敵の種別を判定して、削除する敵だったら、DeadFlagのtrueを付与する
		for bulletIndex = 1, #enemyBulletList do
			bullet = enemyBulletList[bulletIndex]
	
			bulletIsAlive = bullet:IsAlive()
	
			if (bulletIsAlive == false)then
			else
				bulletPosition = bullet:GetPosition()
				bulletWidth, bulletHeight = bullet:GetSize()
	
				playerPosition = player:GetPosition()
				playerWidth, playerHeight = player:GetSize()
	
				isHit = self:IsHit(bulletPosition.x, bulletPosition.y, bulletWidth, bulletHeight, playerPosition.x, playerPosition.y, playerWidth, playerHeight)
	
				if isHit == true then
					local attack = bullet:GetAttack()
					bullet:SetNowHp(0)
					player:AddNowHp(-attack)
					takeDamage = true
				end
			end
			LoopCounter = LoopCounter + 1
		end
		
		-- 敵弾と自弾とのあたり判定
		if #playerBulletList > 0 and #enemyBulletList > 0 then
			for playerBulletIndex = 1, #playerBulletList do
				for enemyBulletIndex = 1, #enemyBulletList do
					enemyBullet = enemyBulletList[enemyBulletIndex]
					playerBullet = playerBulletList[playerBulletIndex]
	
					local enemyBulletIsAlive = enemyBullet:IsAlive()
					local playerBulletIsAlive = playerBullet:IsAlive()
	
					if (enemyBulletIsAlive == false) or (playerBulletIsAlive == false) then
					else
						enemyBulletPosition = enemyBullet:GetPosition()
						enemyBulletWidth, enemyBulletHeight = enemyBullet:GetSize()
	
						playerBulletPosition = playerBullet:GetPosition()
						playerBulletWidth, playerBulletHeight = playerBullet:GetSize()
	
						isHit = self:IsHit(enemyBulletPosition.x, enemyBulletPosition.y, enemyBulletWidth, enemyBulletHeight, playerBulletPosition.x, playerBulletPosition.y, playerBulletWidth, playerBulletHeight)
	
						if isHit == true then
							EffectManager.Instance():SpawnEffect(EffectNameEnum.HitEffect, enemyBullet:GetPosition())
							local playerBulletAttack = playerBullet:GetAttack()
							local enemyBulletAttack = enemyBullet:GetAttack()
							enemyBullet:AddNowHp(-playerBulletAttack)
							playerBullet:AddNowHp(-enemyBulletAttack)
						end
					end
					LoopCounter = LoopCounter + 1
				end
			end
		end
		
		if takeDamage == true then
			self.ComboCount = 0
			LuaSetActive("BattleComboLabel", false)
			LuaSetActive("BattleComboCounterText", false)
		else
			if comboAddCounter > 0 then
				self.ComboCount = self.ComboCount + comboAddCounter
				if self.ComboCount > 999 then
					self.ComboCount = 999
				end
				LuaSetActive("BattleComboLabel", true)
				LuaSetActive("BattleComboCounterText", true)
				LuaSetText("BattleComboCounterText", self.ComboCount)
				--CallbackManager.Instance():AddCallback("BattleComboCounter", {self}, function() end)
				LuaPlayAnimator("BattleComboCounterText", "Play", false, true, "LuaCallback", "BattleComboCounter")
				LuaPlayAnimator("BattleComboCounterText", "Play2", false, true, "LuaCallback", "BattleComboCounter")
			end
		end


		return LoopCounter
	end

	--当たり判定
	this.CheckBump = function(self)
		playerBulletList = BulletManager.Instance():GetPlayerBulletList()
		enemyBulletList = BulletManager.Instance():GetEnemyBulletList()
		enemyList = EnemyManager.Instance():GetList()
		player = PlayerManager:GetPlayer()

		local LoopCounter = 0
		
		local comboAddCounter = 0
	
		-- 弾と敵とのあたり判定
		-- 当たったオブジェクト双方に、DeadFlagのtrueを付与する
		if #playerBulletList > 0 and #enemyList > 0 then
			for bulletIndex = 1, #playerBulletList do
				for enemyIndex = 1, #enemyList do
					local enemy = enemyList[enemyIndex]
					local bullet = playerBulletList[bulletIndex]
	
					local enemyIsAlive = enemy:IsAlive()
					local bulletIsAlive = bullet:IsAlive()
	
					if (enemyIsAlive == false) or (bulletIsAlive == false) then
					else
						enemyPosition = enemy:GetPosition()
						enemyWidth, enemyHeight = enemy:GetSize()
	
						bulletPosition = bullet:GetPosition()
						bulletWidth, bulletHeight = bullet:GetSize()
	
						isHit = self:IsHit(enemyPosition.x, enemyPosition.y, enemyWidth, enemyHeight, bulletPosition.x, bulletPosition.y, bulletWidth, bulletHeight)
	
						if isHit == true then
							EffectManager.Instance():SpawnEffect(EffectNameEnum.HitEffect, enemy:GetPosition())
							local bulletAttack = bullet:GetAttack()
							enemy:AddNowHp(-bulletAttack)
							if enemy:IsAlive() == false then
								local exp = enemy:GetEXP()
								exp = exp * (1 + (self.ComboCount/1000))
								player:AddEXP(exp)
							end
							bullet:AddNowHp(-1)
						end
					end

					LoopCounter = LoopCounter + 1
				end
			end
		end
		
		-- 敵と自キャラとのあたり判定
		-- 当たったら、敵の種別を判定して、削除する敵だったら、DeadFlagのtrueを付与する
		for enemyIndex = 1, #enemyList do
			enemy = enemyList[enemyIndex]
	
			enemyIsAlive = enemy:IsAlive()
	
			if (enemyIsAlive == false)then
			else
				enemyPosition = enemy:GetPosition()
				enemyWidth, enemyHeight = enemy:GetSize()
	
				playerPosition = player:GetPosition()
				playerWidth, playerHeight = player:GetSize()
	
				isHit = self:IsHit(enemyPosition.x, enemyPosition.y, enemyWidth, enemyHeight, playerPosition.x, playerPosition.y, playerWidth, playerHeight)
	
				if isHit == true then
					local attack = enemy:GetAttack()
					enemy:SetNowHp(0)
					player:AddNowHp(-attack)
				end
			end
			LoopCounter = LoopCounter + 1
		end
		
		-- 敵弾と自キャラとのあたり判定
		-- 当たったら、敵の種別を判定して、削除する敵だったら、DeadFlagのtrueを付与する
		for bulletIndex = 1, #enemyBulletList do
			bullet = enemyBulletList[bulletIndex]
	
			bulletIsAlive = bullet:IsAlive()
	
			if (bulletIsAlive == false)then
			else
				bulletPosition = bullet:GetPosition()
				bulletWidth, bulletHeight = bullet:GetSize()
	
				playerPosition = player:GetPosition()
				playerWidth, playerHeight = player:GetSize()
	
				isHit = self:IsHit(bulletPosition.x, bulletPosition.y, bulletWidth, bulletHeight, playerPosition.x, playerPosition.y, playerWidth, playerHeight)
	
				if isHit == true then
					local attack = bullet:GetAttack()
					bullet:SetNowHp(0)
					player:AddNowHp(-attack)
				end
			end
			LoopCounter = LoopCounter + 1
		end
		
		-- 敵弾と自弾とのあたり判定
		if #playerBulletList > 0 and #enemyBulletList > 0 then
			for playerBulletIndex = 1, #playerBulletList do
				for enemyBulletIndex = 1, #enemyBulletList do
					enemyBullet = enemyBulletList[enemyBulletIndex]
					playerBullet = playerBulletList[playerBulletIndex]
	
					local enemyBulletIsAlive = enemyBullet:IsAlive()
					local playerBulletIsAlive = playerBullet:IsAlive()
	
					if (enemyBulletIsAlive == false) or (playerBulletIsAlive == false) then
					else
						enemyBulletPosition = enemyBullet:GetPosition()
						enemyBulletWidth, enemyBulletHeight = enemyBullet:GetSize()
	
						playerBulletPosition = playerBullet:GetPosition()
						playerBulletWidth, playerBulletHeight = playerBullet:GetSize()
	
						isHit = self:IsHit(enemyBulletPosition.x, enemyBulletPosition.y, enemyBulletWidth, enemyBulletHeight, playerBulletPosition.x, playerBulletPosition.y, playerBulletWidth, playerBulletHeight)
	
						if isHit == true then
							EffectManager.Instance():SpawnEffect(EffectNameEnum.HitEffect, enemyBullet:GetPosition())
							local playerBulletAttack = playerBullet:GetAttack()
							local enemyBulletAttack = enemyBullet:GetAttack()
							enemyBullet:AddNowHp(-playerBulletAttack)
							playerBullet:AddNowHp(-enemyBulletAttack)
						end
					end
				end
				LoopCounter = LoopCounter + 1
			end
		end


		if comboAddCounter > 0 then
			self.ComboCount = self.ComboCount + comboAddCounter
		end
	
		-- 死亡フラグが立っている物を削除する
		EnemyManager:RemoveDeadObject()
		BulletManager:RemoveDeadObject()
	end

	this.IsHit = function(self, leftPosX, leftPosY, leftWidth, leftHeight, rightPosX, rightPosY, rightWidth, rightHeight)
		local x = 1
		local y = 2
	
		local leftTL = {leftPosX-leftWidth/2, leftPosY+leftHeight/2}
		local leftTR = {leftPosX+leftWidth/2, leftPosY+leftHeight/2}
		local leftBL = {leftPosX-leftWidth/2, leftPosY-leftHeight/2}
		local leftBR = {leftPosX+leftWidth/2, leftPosY-leftHeight/2}
		
		local rightTL = {rightPosX-rightWidth/2, rightPosY+rightHeight/2}
		local rightTR = {rightPosX+rightWidth/2, rightPosY+rightHeight/2}
		local rightBL = {rightPosX-rightWidth/2, rightPosY-rightHeight/2}
		local rightBR = {rightPosX+rightWidth/2, rightPosY-rightHeight/2}
	
		--左オブジェクトの左上が、右オブジェクトの範囲内に入っているかどうか
		--x座標が範囲内か確認
		if (leftTL[x] >= rightTL[x] and leftTL[x] <= rightTR[x]) then
			--y座標が範囲内か確認
			if (leftTL[y] <= rightTL[y] and leftTL[y] >= rightBL[y]) then
				return true
			end
		end
		
		--左オブジェクトの右上が、右オブジェクトの範囲内に入っているかどうか
		--x座標が範囲内か確認
		if (leftTR[x] >= rightTL[x] and leftTR[x] <= rightTR[x]) then
			--y座標が範囲内か確認
			if (leftTR[y] <= rightTR[y] and leftTR[y] >= rightBR[y]) then
				return true
			end
		end
	
		--左オブジェクトの左下が、右オブジェクトの範囲内に入っているかどうか
		--x座標が範囲内か確認
		if (leftBL[x] >= rightBL[x] and leftBL[x] <= rightBR[x]) then
			--y座標が範囲内か確認
			if (leftBL[y] <= rightTL[y] and leftBL[y] >= rightBL[y]) then
				return true
			end
		end
		
		--左オブジェクトの右下が、右オブジェクトの範囲内に入っているかどうか
		--x座標が範囲内か確認
		if (leftBR[x] >= rightBL[x] and leftBR[x] <= rightBR[x]) then
			--y座標が範囲内か確認
			if (leftBR[y] <= rightTR[y] and leftBR[y] >= rightBR[y]) then
				return true
			end
		end
	
		return false
	end
	
	this.LotKarikari = function(self)
		local bool isSpawn = false
		local rate = GameManager.Instance():GetKarikariRate()
		local number = math.random(1000)
		if number <= rate then
			isSpawn = true
		end

		return isSpawn
	end
	
	-- セーブデータをロードして、内容を設定、のテスト

--途中復帰に必要な情報
--
--・経過秒数
--・獲得経験値
--・残りスキルポイント
--・獲得カリカリ
--・スキル割り振り状態
--・現在HP
--・コンボ数
--・


	this.LoadSaveData = function(self)

		LuaUnityDebugLog("LoadSaveData")

		self.EndTimeCounter = 45
		EnemyManager:SetTimer(self.EndTimeCounter) 
		
		-- プレイヤーに付随する情報
		local player = PlayerManager:Instance():GetPlayer()
		player:AddEXP(10000)
		player:AddHaveSkillPoint(5)
		player:SetNowHp(50)

		-- その中でも、スキルに関する物
		local skillConfig = player:GetSkillConfig()
		skillConfig:SetSkillLevel(SkillTypeEnum.Emitter, 2)
		skillConfig:SetSkillLevel(SkillTypeEnum.Bullet, 1)
		
		-- こいつらは、Update呼ばれたら更新されるからおｋ
		self.ComboCount = 100
		self.GetKarikari = 50
	end
	
	return this
end

