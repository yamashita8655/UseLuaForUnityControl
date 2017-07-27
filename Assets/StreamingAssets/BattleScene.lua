--直接Unityには登録しないスクリプト。いわゆる、ライブラリ化した奴

-- クラス定義
BattleScene = {}

-- とりあえず、Player弾が2なのは、グリッド範囲に入っているのが2箇所という意味なので、間違ってはい無さそう
-- リストに格納されている弾が、別の弾の可能性があるので、名前とヒエラルキーを見て、正しい物が入っているか確認する
	-- セル分割の時点で、想定している弾と敵の弾のセルが異なるので、あたり判定が交わる事が無いことがわかったので、
-- GetCellNumberでの座標位置を確認して、同じ位置に来ない原因を調べる

-- コンストラクタ
function BattleScene.new()
	local this = SceneBase.new()

	this.EndTime = 0
	this.EndTimeCounter = 0
	
	this.EndCheckInterval = 5
	this.EndCheckIntervalCounter = 0
	
	this.WaveInterval = 0
	this.WaveIntervalCounter = 0
	
	this.SaveInterval = 30 -- セーブ処理を走らせる間隔秒
	--this.SaveInterval = 10000 -- セーブ処理を走らせる間隔秒
	this.SaveIntervalCounter = 0 
	
	this.AlignScale		= Vector3.new(1.0, 1.0, 1.0)-- 画面表示の拡縮調整
	this.AlignPosition	= Vector3.new(0.0, 0.0, 0.0)-- 画面表示のポジション調整
	
	this.IsGamePause = false
	this.ComboCount = 0
	this.GetKarikari = 0
	this.SelectCharacter = nil
	this.SkillLevelUpNowFlag = false
	
	this.MaxWave = 0
	this.WaveCounter = 0
	
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
		
		LuaFindObject("BattleOptionButton")
		
		LuaFindObject("BattleWaveRoot")
		LuaFindObject("BattleNowWaveText")
		LuaFindObject("BattleMaxWaveText")
		
		LuaFindObject("BattleWaveSpawnGaugeImage")
		
		this.IsGamePause = true
		this.ComboCount = 0
		this.GetKarikari = 0
	
		this.MaxWave = GameManager.Instance():GetQuestEditWaveCount()
		this.WaveCounter = 0
		
		local selectQuestId = GameManager.Instance():GetSelectQuestId()
		enemySpawnTable = QuestConfig[selectQuestId].EnemySpawnTable

		this.WaveInterval = QuestConfig[selectQuestId].SpawnInterval
		this.WaveIntervalCounter = 15-- 最初は、すぐに出現するように、カウンターをマックスの状態にしておく
		self:UpdateSpawnGaugeScale(self.WaveIntervalCounter / self.WaveInterval)

		self.EndTimeCounter = 0
		self.EndCheckIntervalCounter = 0
		
		local posx = ScreenWidth/2
		local posy = ScreenHeight/2
	
		self.SelectCharacter = GameManager.Instance():GetSelectPlayerCharacterData()
		PlayerManager.Instance():CreatePlayer(self.SelectCharacter, posx, posy, 0)
		
		--Test
		local enemyPrefabNameList = {}
		local spawnTable = enemySpawnTable.SelectSpawnDataList
		for i = 1, #spawnTable do
			for j = 1, #spawnTable[i] do
				local spawnData = spawnTable[i][j]
				local enemyData = spawnData.EnemyType
				if enemyData.EnemyType == EnemyTypeEnum.BulletShooter then
					local enemyBulletList = enemyData.EquipBulletList
					for j = 1, #enemyBulletList do
						local prefabName = enemyBulletList[j].PrefabName
						table.insert(enemyPrefabNameList, prefabName)
					end
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
		local baseHp = self.SelectCharacter.BaseParameter:MaxHp()
		local characterAddParameter = SaveObject.CharacterList[self.SelectCharacter.IdIndex]
		local addHp = characterAddParameter[CharacterParameterEnum.AddHp]
		player:SetNowHp(baseHp + addHp)
		player:SetMaxHp(baseHp + addHp)
		local skillConfig = player:GetSkillConfig()
		local skillTable = skillConfig:GetSkillTable()
		local bulletList = skillTable[SkillTypeEnum.Bullet]
		
		local prefabNameList = {}
		for i = 1, #bulletList do
			local bulletData = bulletList[i]
			local bulletConfigList = bulletData.EquipBulletList
			for j = 1, #bulletConfigList do
				local prefabName = bulletConfigList[j].PrefabName
				table.insert(prefabNameList, prefabName)
			end
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
		
		LuaSetText("BattleMaxWaveText", this.MaxWave)
		
		--LuaSetScale("BattleObjectRoot", 1.0, 1.0, 1.0)
		--LuaSetScale("BattleObjectRoot", 0.7, 0.7, 0.7)
		LuaSetScale("BattleObjectRoot", 0.5, 0.5, 0.5)
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


		-- 有効なセーブデータが存在したら
		if SaveObject.BattleSaveEnable == 1 then
			self:LoadDataFromFileIO()
		end
		
		self:UpdateWaveText()
		--EnemyManager:CreateSpawnController(enemySpawnTable)
		EnemyManager:CreateNewSpawnController(enemySpawnTable, this.MaxWave)
		self.EndTime = self.MaxWave * self.WaveIntervalCounter -- 経過時間は、とりあえずウェーブ数*ウェーブ切り替え時間が経過したら見るようにする
		
		this:SceneBaseInitialize()
		
		SoundManager.Instance():PlayBGM(SoundManager.Instance().BGMIndexList.BattleSceneBgm)
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
			self:CheckBump()

			local player = PlayerManager.Instance():GetPlayer()
			local exp = player:GetEXP()
			exp = math.floor(exp)
			LuaSetText("ExpText", exp)
			
			local karikari = math.floor(self.GetKarikari)
			LuaSetText("BattleKarikariText", karikari)
			
			if player:IsAlive() == false then
				self.IsGamePause = true
				self:LoseSequence()
			end

			-- 敵の出現
			if self.WaveCounter < self.MaxWave then
				self.WaveIntervalCounter = self.WaveIntervalCounter + deltaTime
				self:UpdateSpawnGaugeScale(self.WaveIntervalCounter / self.WaveInterval)
				if self.WaveIntervalCounter >= self.WaveInterval then
					-- 先にセーブをする
					self:SaveDataFromFileIO()
					this.WaveCounter = this.WaveCounter + 1
					EnemyManager.Instance():OrderSpawnEnemy(this.WaveCounter)
					self:UpdateWaveText()
					this.WaveIntervalCounter = 0
				end
			end

			---- タイマーを確認して、情報をセーブ
			--self.SaveIntervalCounter = self.SaveIntervalCounter + deltaTime
			--if self.SaveIntervalCounter > self.SaveInterval then
			--	self:SaveDataFromFileIO()
			--	self.SaveIntervalCounter = 0
			--end


		end
	end
	
	-- バトル開始エフェクト
	this.BattleStartSequence = function(self)
		CallbackManager.Instance():AddCallback("Battle_BattleStartSequence", {self}, self.BattleStartSequenceCallback)
		LuaPlayAnimator("BattleStartEffect", "Play", false, true, "LuaCallback", "Battle_BattleStartSequence")
	end
	
	this.BattleStartSequenceCallback = function(arg, unityArg)
		local self = arg[1]
		LuaSetActive("BattleStartEffect", false)
		self.IsGamePause = false
	end
	
	-- 勝ちエフェクト
	this.WinSequence = function(self)
		SoundManager.Instance():StopBGM(SoundManager.Instance().BGMIndexList.BattleSceneBgm)
		SoundManager.Instance():PlaySE("sound", SoundManager.Instance().SENameList.BattleWin)
		CallbackManager.Instance():AddCallback("Battle_WinSequence", {self}, self.WinSequenceCallback)
		LuaPlayAnimator("WinEffect", "Play", false, true, "LuaCallback", "Battle_WinSequence")
	end
	
	this.WinSequenceCallback = function(arg, unityArg)
		local self = arg[1]
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
		SoundManager.Instance():StopBGM(SoundManager.Instance().BGMIndexList.BattleSceneBgm)
		SoundManager.Instance():PlaySE("sound", SoundManager.Instance().SENameList.BattleLose)
		CallbackManager.Instance():AddCallback("Battle_LoseSequence", {self}, self.LoseSequenceCallback)
		LuaPlayAnimator("LoseEffect", "Play", false, true, "LuaCallback", "Battle_LoseSequence")
	end
	
	this.LoseSequenceCallback = function(arg, unityArg)
		local self = arg[1]
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

		SaveObject.BattleSaveEnable = 0 -- セーブ情報は無効にする

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
			LuaPlayAnimator("BattleOptionButton", "Stop", false, false, "LuaCallback", "")
		end
		if buttonName == "BattleExitButton" then
			self.IsGamePause = true
			DialogManager.Instance():OpenOkCancelDialog(
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


	this.CheckBump = function(self)
		AreaCellManager.Instance():Clear() 

		local playerBulletList = BulletManager.Instance():GetPlayerBulletList()
		local enemyBulletList = BulletManager.Instance():GetEnemyBulletList()
		local enemyList = EnemyManager.Instance():GetList()
		local player = PlayerManager:GetPlayer()


		for i = 1, #playerBulletList do
			local bullet = playerBulletList[i]
			local cellNumberList = AreaCellManager.Instance():GetCellNumber(bullet) 
			for j = 1, #cellNumberList do
				local cellNumber = cellNumberList[j]
				if cellNumber ~= -1 then
					AreaCellManager.Instance():AddPlayerBullet(bullet, cellNumber)
				end
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
			end
		end
			
		local cellNumberList = AreaCellManager.Instance():GetCellNumber(player) 
		for j = 1, #cellNumberList do
			local cellNumber = cellNumberList[j]
			if cellNumber ~= -1 then
				AreaCellManager.Instance():AddPlayer(player, cellNumber)
			end
		end

		--AreaCellManager:GetCellNumber(position) 
		

		local list = AreaCellManager.Instance():GetBumpList()
		for i = 1, #list do
			local data = list[i]
			self:CheckBump2(data)
		end

		-- 死亡フラグが立っている物を削除する
		EnemyManager:RemoveDeadObject()
		BulletManager:RemoveDeadObject()

	end
	
	--当たり判定
	this.CheckBump2 = function(self, checkBumpObject)
		local playerBulletList = checkBumpObject:GetPlayerBullet()
		local enemyBulletList = checkBumpObject:GetEnemyBullet()
		local enemyList = checkBumpObject:GetEnemy()
		local player = PlayerManager:GetPlayer()

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
						local enemyPosition = enemy:GetPosition()
						local enemyWidth, enemyHeight = enemy:GetSize()
	
						local bulletPosition = bullet:GetPosition()
						local bulletWidth, bulletHeight = bullet:GetSize()
	
						local isHit = self:IsHit(enemyPosition.x, enemyPosition.y, enemyWidth, enemyHeight, bulletPosition.x, bulletPosition.y, bulletWidth, bulletHeight)
	
						if isHit == true then
							EffectManager.Instance():SpawnEffect(EffectNameEnum.HitEffect, enemy:GetPosition())

							local bulletAttack = bullet:GetAttack()
							local baseAttack = self.SelectCharacter.BaseParameter:Attack()
							local characterAddParameter = SaveObject.CharacterList[self.SelectCharacter.IdIndex]
							local addAttack = characterAddParameter[CharacterParameterEnum.AddAttack]
							local playerAttack = baseAttack + addAttack
							enemy:AddNowHp(-(bulletAttack+playerAttack))
							if enemy:IsAlive() == false then
								SoundManager.Instance():PlaySE("sound", SoundManager.Instance().SENameList.EnemyDeath)
								local exp = enemy:GetEXP()
								exp = exp * (1 + (self.ComboCount/1000))
								self.SkillLevelUpNowFlag = player:AddEXP(exp)
								if self.SkillLevelUpNowFlag == true then
									SoundManager.Instance():PlaySE("sound", SoundManager.Instance().SENameList.SkillLevelUp)
									if GameManager.Instance():GetAutoSkillLevelUp() == true then

										-- 自動でスキルレベルアップをする
										local skillConfig = player:GetSkillConfig()
										
										local emitterNowLevel = skillConfig:GetSkillLevel(SkillTypeEnum.Emitter)
										local emitterMaxLevel = skillConfig:GetMaxSkillLevel(SkillTypeEnum.Emitter)
										local bulletNowLevel = skillConfig:GetSkillLevel(SkillTypeEnum.Bullet)
										local bulletMaxLevel = skillConfig:GetMaxSkillLevel(SkillTypeEnum.Bullet)
										local skillType = nil
										if bulletNowLevel < emitterNowLevel then
											if bulletNowLevel < bulletMaxLevel then
												skillType = SkillTypeEnum.Bullet
											else
												if emitterNowLevel < emitterMaxLevel then
													skillType = SkillTypeEnum.Emitter
												end
											end
										else
											if emitterNowLevel < emitterMaxLevel then
												skillType = SkillTypeEnum.Emitter
											else
												if bulletNowLevel < bulletMaxLevel then
													skillType = SkillTypeEnum.Bullet
												end
											end
										end
										
										if skillType ~= nil then
											skillConfig:AddSkillLevel(skillType)
											local skillTable = skillConfig:GetSkillTable()
											local emitterNowLevelAfterLevelUp = skillConfig:GetSkillLevel(SkillTypeEnum.Emitter)
											local bulletNowLevelAfterLevelUp = skillConfig:GetSkillLevel(SkillTypeEnum.Bullet)
											
											player:ClearBulletEmitter()
											player = UtilityFunction.Instance().SetEmitter(player, skillTable[SkillTypeEnum.Emitter][emitterNowLevelAfterLevelUp].BulletEmitterList, skillTable[SkillTypeEnum.Bullet][bulletNowLevelAfterLevelUp].EquipBulletList, CharacterType.Player)
											player:AddHaveSkillPoint(-1)
										end
									else
										LuaPlayAnimator("BattleOptionButton", "Move", false, false, "LuaCallback", "")
									end
								end
								comboAddCounter = comboAddCounter + 1
								local karikari = self:LotKarikari()
								if karikari == true then
									EffectManager.Instance():SpawnEffect(EffectNameEnum.KarikariEffect, enemy:GetPosition())
									self.GetKarikari = self.GetKarikari + 1
									SoundManager.Instance():PlaySE("sound", SoundManager.Instance().SENameList.RareDrop)
								end
							end
							bullet:AddNowHp(-1)
						end
					end
				end
			end
		end
		
		-- 敵と自キャラとのあたり判定
		-- 当たったら、敵の種別を判定して、削除する敵だったら、DeadFlagのtrueを付与する
		for enemyIndex = 1, #enemyList do
			local enemy = enemyList[enemyIndex]
	
			local enemyIsAlive = enemy:IsAlive()
	
			if (enemyIsAlive == false)then
			else
				local enemyPosition = enemy:GetPosition()
				local enemyWidth, enemyHeight = enemy:GetSize()
	
				local playerPosition = player:GetPosition()
				local playerWidth, playerHeight = player:GetSize()
	
				local isHit = self:IsHit(enemyPosition.x, enemyPosition.y, enemyWidth, enemyHeight, playerPosition.x, playerPosition.y, playerWidth, playerHeight)
	
				if isHit == true then
					local attack = enemy:GetAttack()
					local baseDeffense = self.SelectCharacter.BaseParameter:Deffense()
					local characterAddParameter = SaveObject.CharacterList[self.SelectCharacter.IdIndex]
					local addDeffense = characterAddParameter[CharacterParameterEnum.AddDeffense]
					local damage = (attack-(baseDeffense+addDeffense))
					if damage < 0 then
						damage = 0
					end
					enemy:SetNowHp(0)
					player:AddNowHp(-damage)
					takeDamage = true
					SoundManager.Instance():PlaySE("sound", SoundManager.Instance().SENameList.SelfHit)
					SoundManager.Instance():PlaySE("sound", SoundManager.Instance().SENameList.EnemyDeath)
				end
			end
		end
		
		-- 敵弾と自キャラとのあたり判定
		-- 当たったら、敵の種別を判定して、削除する敵だったら、DeadFlagのtrueを付与する
		for bulletIndex = 1, #enemyBulletList do
			local bullet = enemyBulletList[bulletIndex]
	
			local bulletIsAlive = bullet:IsAlive()
	
			if (bulletIsAlive == false)then
			else
				local bulletPosition = bullet:GetPosition()
				local bulletWidth, bulletHeight = bullet:GetSize()
	
				local playerPosition = player:GetPosition()
				local playerWidth, playerHeight = player:GetSize()
	
				local isHit = self:IsHit(bulletPosition.x, bulletPosition.y, bulletWidth, bulletHeight, playerPosition.x, playerPosition.y, playerWidth, playerHeight)
	
				if isHit == true then
					local attack = bullet:GetAttack()
					bullet:SetNowHp(0)

					local baseDeffense = self.SelectCharacter.BaseParameter:Deffense()
					local characterAddParameter = SaveObject.CharacterList[self.SelectCharacter.IdIndex]
					local addDeffense = characterAddParameter[CharacterParameterEnum.AddDeffense]
					local damage = (attack-(baseDeffense+addDeffense))
					if damage < 0 then
						damage = 0
					end
					player:AddNowHp(-damage)
					takeDamage = true
					SoundManager.Instance():PlaySE("sound", SoundManager.Instance().SENameList.SelfHit)
				end
			end
		end
		
		-- 敵弾と自弾とのあたり判定
		if #playerBulletList > 0 and #enemyBulletList > 0 then
			for playerBulletIndex = 1, #playerBulletList do
				for enemyBulletIndex = 1, #enemyBulletList do
					local enemyBullet = enemyBulletList[enemyBulletIndex]
					local playerBullet = playerBulletList[playerBulletIndex]
	
					local enemyBulletIsAlive = enemyBullet:IsAlive()
					local playerBulletIsAlive = playerBullet:IsAlive()
	
					if (enemyBulletIsAlive == false) or (playerBulletIsAlive == false) then
					else
						local enemyBulletPosition = enemyBullet:GetPosition()
						local enemyBulletWidth, enemyBulletHeight = enemyBullet:GetSize()
	
						local playerBulletPosition = playerBullet:GetPosition()
						local playerBulletWidth, playerBulletHeight = playerBullet:GetSize()
	
						local isHit = self:IsHit(enemyBulletPosition.x, enemyBulletPosition.y, enemyBulletWidth, enemyBulletHeight, playerBulletPosition.x, playerBulletPosition.y, playerBulletWidth, playerBulletHeight)

						if isHit == true then
							EffectManager.Instance():SpawnEffect(EffectNameEnum.HitEffect, enemyBullet:GetPosition())
							local playerBulletAttack = playerBullet:GetAttack()
							local enemyBulletAttack = enemyBullet:GetAttack()
							enemyBullet:AddNowHp(-playerBulletAttack)
							playerBullet:AddNowHp(-enemyBulletAttack)
						end
					end
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
	end

	--当たり判定
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
		
		--右オブジェクトの左上が、左オブジェクトの範囲内に入っているかどうか
		--x座標が範囲内か確認
		if (rightTL[x] >= leftTL[x] and rightTL[x] <= leftTR[x]) then
			--y座標が範囲内か確認
			if (rightTL[y] <= leftTL[y] and rightTL[y] >= leftBL[y]) then
				return true
			end
		end
		
		--右オブジェクトの右上が、左オブジェクトの範囲内に入っているかどうか
		--x座標が範囲内か確認
		if (rightTR[x] >= leftTL[x] and rightTR[x] <= leftTR[x]) then
			--y座標が範囲内か確認
			if (rightTR[y] <= leftTR[y] and rightTR[y] >= leftBR[y]) then
				return true
			end
		end
	
		--右オブジェクトの左下が、左オブジェクトの範囲内に入っているかどうか
		--x座標が範囲内か確認
		if (rightBL[x] >= leftBL[x] and rightBL[x] <= leftBR[x]) then
			--y座標が範囲内か確認
			if (rightBL[y] <= leftTL[y] and rightBL[y] >= leftBL[y]) then
				return true
			end
		end
		
		--右オブジェクトの右下が、左オブジェクトの範囲内に入っているかどうか
		--x座標が範囲内か確認
		if (rightBR[x] >= leftBL[x] and rightBR[x] <= leftBR[x]) then
			--y座標が範囲内か確認
			if (rightBR[y] <= leftTR[y] and rightBR[y] >= leftBR[y]) then
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
	this.LoadDataFromFileIO = function(self)

		---- こっちは、デバッグ用に仮うちの値でゲーム開始
		--self.EndTimeCounter = 45
		--EnemyManager:SetTimer(self.EndTimeCounter) 
		--
		---- プレイヤーに付随する情報
		--local player = PlayerManager:Instance():GetPlayer()
		--player:AddEXP(10000)
		--player:AddHaveSkillPoint(5)
		--player:SetNowHp(50)

		---- その中でも、スキルに関する物
		--local skillConfig = player:GetSkillConfig()
		--skillConfig:SetSkillLevel(SkillTypeEnum.Emitter, 2)
		--skillConfig:SetSkillLevel(SkillTypeEnum.Bullet, 1)
		--
		---- こいつらは、Update呼ばれたら更新されるからおｋ
		--self.ComboCount = 100
		--self.GetKarikari = 50

		-- 経過時間設定
		self.EndTimeCounter = SaveObject.BattleEndTimeCounter
		--TODO 新しいウェーブ指定方式の場合、タイマーが無いので、いったん無効
		--EnemyManager:SetTimer(self.EndTimeCounter) 
		
		-- プレイヤーに付随する情報
		local player = PlayerManager:Instance():GetPlayer()
		-- その中でも、スキルに関する物
		local skillConfig = player:GetSkillConfig()
		skillConfig:SetSkillLevel(SkillTypeEnum.Emitter, SaveObject.BattleEmitterLevel)
		skillConfig:SetSkillLevel(SkillTypeEnum.Bullet, SaveObject.BattleBulletLevel)
		player:AddHaveSkillPoint(SaveObject.BattleSkillPoint)
		player:SetSkillLevel(SaveObject.BattleEmitterLevel+SaveObject.BattleBulletLevel)
		
		player:AddEXP(SaveObject.BattleExp)
		player:SetNowHp(SaveObject.BattleHp)

		local skillTable = skillConfig:GetSkillTable()
		local emitterNowLevelAfterLevelUp = skillConfig:GetSkillLevel(SkillTypeEnum.Emitter)
		local bulletNowLevelAfterLevelUp = skillConfig:GetSkillLevel(SkillTypeEnum.Bullet)
		
		player:ClearBulletEmitter()
		player = UtilityFunction.Instance().SetEmitter(player, skillTable[SkillTypeEnum.Emitter][emitterNowLevelAfterLevelUp].BulletEmitterList, skillTable[SkillTypeEnum.Bullet][bulletNowLevelAfterLevelUp].EquipBulletList, CharacterType.Player)


		self.WaveCounter = SaveObject.BattleNowWave
		self.MaxWave = SaveObject.BattleMaxWave
		self:UpdateWaveText()
		
		-- こいつらは、Update呼ばれたら更新されるからおｋ
		self.ComboCount = SaveObject.BattleComboCount
		if self.ComboCount ~= 0 then
			LuaSetActive("BattleComboLabel", true)
			LuaSetActive("BattleComboCounterText", true)
			LuaSetText("BattleComboCounterText", self.ComboCount)
		end
		self.GetKarikari = SaveObject.BattleKarikari
	end
	
	this.SaveDataFromFileIO = function(self)
		
		local player = PlayerManager:Instance():GetPlayer()
		local skillConfig = player:GetSkillConfig()
		
		SaveObject.BattleSelectQuestId = GameManager.Instance():GetSelectQuestId()
		SaveObject.BattleEndTimeCounter = self.EndTimeCounter
		SaveObject.BattleExp = player:GetEXP()
		SaveObject.BattleSkillPoint = player:GetHaveSkillPoint()
		SaveObject.BattleHp = player:GetNowHp()
		SaveObject.BattleSkillLevel = player:GetSkillLevel()
		SaveObject.BattleEmitterLevel = skillConfig:GetSkillLevel(SkillTypeEnum.Emitter)
		SaveObject.BattleBulletLevel = skillConfig:GetSkillLevel(SkillTypeEnum.Bullet)
		SaveObject.BattleComboCount = self.ComboCount
		SaveObject.BattleKarikari = self.GetKarikari
		SaveObject.BattleNowWave = self.WaveCounter
		SaveObject.BattleMaxWave = self.MaxWave
		SaveObject.BattleSaveEnable = 1

		FileIOManager.Instance():Save()
	end
	
	this.UpdateWaveText = function(self)
		LuaSetText("BattleMaxWaveText", self.MaxWave)
		LuaSetText("BattleNowWaveText", self.WaveCounter)
	end
	
	this.UpdateSpawnGaugeScale = function(self, scale)
		LuaSetScale("BattleWaveSpawnGaugeImage", scale, 1, 1)
	end
	
	return this
end

