--直接Unityには登録しないスクリプト。いわゆる、ライブラリ化した奴

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

	-- メソッド定義
	-- 初期化
	this.SceneBaseInitialize = this.Initialize
	this.Initialize = function(self)
		if self.IsInitialized == false then
			SkillLevelUpDialog.Instance():Initialize()
		end
		
		this:SceneBaseInitialize()

		LuaChangeScene("Battle", "MainCanvas")
		
		PlayerManager.Instance():Initialize()
		BulletManager.Instance():Initialize()
		EffectManager.Instance():Initialize()
		EnemyManager.Instance():Initialize()

		this.IsGamePause = false
		
		selectQuestId = GameManager.Instance():GetSelectQuestId()
		enemySpawntTable = QuestConfig[selectQuestId].EnemySpawnTable

		EnemyManager:CreateSpawnController(enemySpawntTable)
		self.EndTime = enemySpawntTable.EndTime
		self.EndTimeCounter = 0
		self.EndCheckIntervalCounter = 0
		
		local posx = ScreenWidth/2
		local posy = ScreenHeight/2
	
		selectCharacter = nil
		selectCharacter = GameManager.Instance():GetSelectPlayerCharacterData()
		PlayerManager.Instance():CreatePlayer(selectCharacter, posx, posy, 0)

		LuaFindObject("BattleObjectRoot")
		LuaFindObject("ExpText")
		
		--LuaSetScale("BattleObjectRoot", 0.7, 0.7, 0.7)
		self.AlignPosition.x = -200
		self.AlignPosition.y = -200
		self.AlignPosition.z = 0
		LuaSetPosition("BattleObjectRoot", self.AlignPosition.x, self.AlignPosition.y, self.AlignPosition.z)
		
		LuaSetActive("HeaderObject", false)
		LuaSetActive("FooterObject", false)
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
						SceneManager.Instance():ChangeScene(SceneNameEnum.Home)
					end
					self.EndCheckIntervalCounter = 0
				end
			end
	
			PlayerManager.Instance():Update(GameManager:GetBattleDeltaTime())
			BulletManager.Instance():Update(GameManager:GetBattleDeltaTime())
			EnemyManager.Instance():Update(GameManager:GetBattleDeltaTime())
			self:CheckBump()

			player = PlayerManager.Instance():GetPlayer()
			exp = player:GetEXP()
			LuaSetText("ExpText", exp)
		end
	end
	
	-- 終了
	this.SceneBaseEnd = this.End
	this.End = function(self)
		this:SceneBaseEnd()
	
		EnemyManager.Instance():Release()
		BulletManager.Instance():Release()
		PlayerManager.Instance():Release()
			
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
			--SceneManager.Instance():ChangeScene(SceneNameEnum.Home)
			self.IsGamePause = true
			EffectManager.Instance():PauseEffect()
			SkillLevelUpDialog.Instance():OpenDialog(
				function()
					self.IsGamePause = false
					EffectManager.Instance():ResumeEffect()
				end
			)
		end
		SkillLevelUpDialog.Instance():OnClickButton(buttonName)
	end
	
	-- 画面タッチ判定
	this.OnMouseDown = function(self, touchx, touchy)
		if self.IsGamePause == false then
			local calcTouchX = touchx - self.AlignPosition.x
			local calcTouchY = touchy - self.AlignPosition.y
			PlayerManager.Instance():OnMouseDown(calcTouchX, calcTouchY)
		end
	end
	
	this.OnMouseDrag = function(self, touchx, touchy)
		if self.IsGamePause == false then
			local calcTouchX = touchx - self.AlignPosition.x
			local calcTouchY = touchy - self.AlignPosition.y
			PlayerManager.Instance():OnMouseDown(calcTouchX, calcTouchY)
		end
	end

	--当たり判定
	this.CheckBump = function(self)
		playerBulletList = BulletManager.Instance():GetPlayerBulletList()
		enemyBulletList = BulletManager.Instance():GetEnemyBulletList()
		enemyList = EnemyManager.Instance():GetList()
		player = PlayerManager:GetPlayer()
	
		-- 弾と敵とのあたり判定
		-- 当たったオブジェクト双方に、DeadFlagのtrueを付与する
		for bulletIndex = 1, #playerBulletList do
			for enemyIndex = 1, #enemyList do
				enemy = enemyList[enemyIndex]
				bullet = playerBulletList[bulletIndex]
	
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
						EffectManager.Instance():SpawnEffect(enemy:GetPosition())
						local bulletAttack = bullet:GetAttack()
						enemy:AddNowHp(-bulletAttack)
						if enemy:IsAlive() == false then
							local exp = enemy:GetEXP()
							player:AddEXP(exp)
						end
						bullet:AddNowHp(-1)
					end
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
		end
		
		-- 敵弾と自弾とのあたり判定
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
						EffectManager.Instance():SpawnEffect(enemyBullet:GetPosition())
						local playerBulletAttack = playerBullet:GetAttack()
						local enemyBulletAttack = enemyBullet:GetAttack()
						enemyBullet:AddNowHp(-playerBulletAttack)
						playerBullet:AddNowHp(-enemyBulletAttack)
					end
				end
			end
		end
	
		-- 死亡フラグが立っている物を削除する
		EnemyManager:RemoveDeadObject()
		BulletManager:RemoveDeadObject()
	
	end

	this.IsHit = function(self, leftPosX, leftPosY, leftWidth, leftHeight, rightPosX, rightPosY, rightWidth, rightHeight)
		x = 1
		y = 2
	
		leftTL = {leftPosX-leftWidth/2, leftPosY+leftHeight/2}
		leftTR = {leftPosX+leftWidth/2, leftPosY+leftHeight/2}
		leftBL = {leftPosX-leftWidth/2, leftPosY-leftHeight/2}
		leftBR = {leftPosX+leftWidth/2, leftPosY-leftHeight/2}
		
		rightTL = {rightPosX-rightWidth/2, rightPosY+rightHeight/2}
		rightTR = {rightPosX+rightWidth/2, rightPosY+rightHeight/2}
		rightBL = {rightPosX-rightWidth/2, rightPosY-rightHeight/2}
		rightBR = {rightPosX+rightWidth/2, rightPosY-rightHeight/2}
	
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
	
	return this
end

