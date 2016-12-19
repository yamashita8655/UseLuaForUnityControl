﻿--直接Unityには登録しないスクリプト。いわゆる、ライブラリ化した奴

-- クラス定義
BattleScene = {}

-- コンストラクタ
function BattleScene.new()
	local this = SceneBase.new()

	--this.Test = 0

	-- メソッド定義
	-- 初期化
	this.SceneBaseInitialize = this.Initialize
	this.Initialize = function(self)
		this:SceneBaseInitialize()

		LuaChangeScene("Battle", "MainCanvas")
		
		PlayerManager.Instance():Initialize()
		BulletManager.Instance():Initialize()
		EffectManager.Instance():Initialize()
		EnemyManager.Instance():Initialize()
		EnemyManager:CreateSpawnController(SpawnTable) 
		
		local posx = ScreenWidth/2
		local posy = ScreenHeight/2
	
		-- キャラ切り替えテスト
		selectCharacter = nil
		selectCharacter = GameManager.Instance():GetSelectPlayerCharacterData()
		PlayerManager.Instance():CreatePlayer(selectCharacter, posx, posy, 0)
		
		LuaSetActive("HeaderObject", false)
		LuaSetActive("FooterObject", false)
	end
	
	-- 更新
	this.SceneBaseUpdate = this.Update
	this.Update = function(self, deltaTime)
		this:SceneBaseUpdate(deltaTime)
	
		PlayerManager.Instance():Update(GameManager:GetBattleDeltaTime())
		BulletManager.Instance():Update(GameManager:GetBattleDeltaTime())
		EnemyManager.Instance():Update(GameManager:GetBattleDeltaTime())
		self:CheckBump()
	end
	
	-- 終了
	this.SceneBaseEnd = this.End
	this.End = function(self)
		this:SceneBaseEnd()
	
		EnemyManager.Instance():Release()
		BulletManager.Instance():Release()
		PlayerManager.Instance():Release()
	end
	
	-- 有効かどうか
	this.IsActive = function(self)
		return self.IsActive
	end
	
	-- ボタン
	this.OnClickButton = function(self, buttonName)
		if buttonName == "BattleOptionButton" then
			SceneManager.Instance():ChangeScene(SceneNameEnum.Home)
		end
	end
	
	-- 画面タッチ判定
	this.OnMouseDown = function(self, touchx, touchy)
		PlayerManager.Instance():OnMouseDown(touchx, touchy)
	end
	
	this.OnMouseDrag = function(self, touchx, touchy)
		PlayerManager.Instance():OnMouseDrag(touchx, touchy)
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
						EffectManager:SpawnEffect(enemy:GetPosition())
						local bulletAttack = bullet:GetAttack()
						enemy:AddNowHp(-bulletAttack)
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

