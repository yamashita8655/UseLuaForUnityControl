--直接Unityには登録しないスクリプト。いわゆる、ライブラリ化した奴

-- クラス定義
-- 敵出現管理クラス
NewSpawnController = {}

-- メソッド定義

-- コンストラクタ
function NewSpawnController.new()
	-- メンバ変数
	local this = {
		SelectSpawnDataList = {},
		SpawnInterval = 0,
		SpawnIntervalCounter = 0,
		MaxWave = 0,
		WaveCounter = 0,
		SpawnDataList = {},
	}

	-- メソッド定義
	-- 初期化
	this.Initialize = function(self, spawnTable, maxWave)
		self.SelectSpawnDataList = spawnTable.SelectSpawnDataList
		self.SpawnInterval = spawnTable.SpawnInterval
		self.SpawnIntervalCounter = spawnTable.SpawnInterval-- 始まってすぐに出現するようにする
		self.WaveCounter = 0
		self.MaxWave = maxWave
	end

	-- タイマーを外部からセット。途中復帰用。
	this.SetWaveCounter = function(self, count)
		self.WaveCounter = count
	end
	
	-- 更新
	this.Update = function(self, deltaTime)
		
		self.SpawnIntervalCounter = self.SpawnIntervalCounter + deltaTime
		
		-- 出現インターバルを過ぎたら、次のウェーブの敵を作成する
		if self.SpawnIntervalCounter >= self.SpawnInterval then
			if self.WaveCounter + 1 <= self.MaxWave then
				self.SpawnIntervalCounter = 0
				self.WaveCounter = self.WaveCounter + 1
				local index = math.random(1, #self.SelectSpawnDataList)

				for i = 1, #self.SelectSpawnDataList[index] do
					local listData = NewSpawnListData.new()
					listData:Initialize(self.SelectSpawnDataList[index][i], self.WaveCounter, self.MaxWave)
					table.insert(self.SpawnDataList, listData)
				end
			end
		end
		
		-- 敵出現クラスの更新
		for i = 1, #self.SpawnDataList do
			local listData = self.SpawnDataList[i]
			listData:Update(deltaTime)
		end

		self:CheckAndDeleteListData()
	end

	-- 無効なデータの削除
	this.CheckAndDeleteListData = function(self)
		local index = 1
		while true do
			if index > #self.SpawnDataList then
				break
			end

			local data = self.SpawnDataList[index]
			local IsEnable = data:GetEnable()
			if IsEnable then
				index = index + 1
			else
				table.remove(self.SpawnDataList, index)
			end
		end
	end

	return this
end

-- クラス定義
-- 敵出現管理リストデータ
NewSpawnListData = {}

-- メソッド定義

-- コンストラクタ
function NewSpawnListData.new()
	-- メンバ変数
	local this = {
		SpawnData = nil,
		SpawnedCounter = 0,
		IsEnable = true,
		Timer = 0,
		IntervalCounter = 0,
		WaveCount = 0,
		MaxWave = 0,
	}

	-- メソッド定義
	-- 初期化
	this.Initialize = function(self, spawnTableData, waveCount, maxWave)
		self.SpawnData = spawnTableData
		self.IsEnable = true
		self.WaveCount = waveCount
		self.MaxWave = maxWave
	end
	
	-- 有効確認
	this.SetEnable = function(self, enable)
		self.IsEnable = enable
	end
	this.GetEnable = function(self)
		return self.IsEnable
	end
	
	this.Update = function(self, deltaTime)
		self.IntervalCounter = self.IntervalCounter + deltaTime
		if self.IntervalCounter > self.SpawnData.Interval then
			local posx = self.SpawnData.Position.x
			local posy = self.SpawnData.Position.y
			local radian = math.atan2(posy, posx)
			local degree = radian * 180 / 3.1415
			local enemy = EnemyManager.Instance():CreateEnemy(posx+(ScreenWidth/2), posy+(ScreenHeight/2), degree-90-180, self.SpawnData.EnemyType)

			-- 基本値に加算した物に対して、割合をかけた物から、基本値を引いてバフ値とする
			local buffMoveSpeed = (enemy:GetMoveSpeed()+self.MaxWave/10)*(1+(self.WaveCount*0.05))-enemy:GetMoveSpeed()
			local buffAttack = (enemy:GetAttack()+self.MaxWave/10)*(1+(self.WaveCount*0.05))-enemy:GetAttack()
			local buffMaxHp = (enemy:GetMaxHp()+self.MaxWave/10)*(1+(self.WaveCount*0.05))-enemy:GetMaxHp()
			LuaUnityDebugLog("buff:"..buffMoveSpeed..":"..buffAttack..":"..buffMaxHp);
			-- enemyで直接行ってしまうと問題なので、Setはマネージャを通す
			EnemyManager.Instance():SetBuffAndInitializeParameter(enemy:GetNumber(), buffMoveSpeed, buffAttack, buffMaxHp)

			self.IntervalCounter = 0
			self.SpawnedCounter = self.SpawnedCounter + 1
			if self.SpawnedCounter >= self.SpawnData.Value then
				self.IsEnable = false
			end
		end
	end

	return this
end
