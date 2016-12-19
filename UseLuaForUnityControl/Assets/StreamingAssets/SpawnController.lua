--直接Unityには登録しないスクリプト。いわゆる、ライブラリ化した奴

-- クラス定義
-- 敵出現管理クラス
SpawnController = {}

-- メソッド定義

-- コンストラクタ
function SpawnController.new()
	-- メンバ変数
	local this = {
		SpawnDataList = {},
	}

	-- メソッド定義
	-- 初期化
	this.Initialize = function(self, spawnTable)
		for i = 1, #spawnTable do
			listData = SpawnListData.new()
			listData:Initialize(spawnTable[i])
			table.insert(self.SpawnDataList, listData)
		end
	end
	
	-- 更新
	this.Update = function(self, deltaTime)
		for i = 1, #self.SpawnDataList do
			listData = self.SpawnDataList[i]
			listData:Update(deltaTime)
		end

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
SpawnListData = {}

-- メソッド定義

-- コンストラクタ
function SpawnListData.new()
	-- メンバ変数
	local this = {
		Time = 0,
		SpawnData = nil,
		SpawnedCounter = 0,
		IsEnable = true,
		Timer = 0,
		IntervalCounter = 0,
	}

	-- メソッド定義
	-- 初期化
	this.Initialize = function(self, spawnTableData)
		self.Time = spawnTableData.Time
		self.SpawnData = spawnTableData.SpawnData
		self.IsEnable = true
	end
	
	-- 有効確認
	this.SetEnable = function(self, enable)
		self.IsEnable = enable
	end
	this.GetEnable = function(self)
		return self.IsEnable
	end
	
	this.Update = function(self, deltaTime)
		self.Timer = self.Timer + deltaTime
		if self.Timer > self.Time then
			self.IntervalCounter = self.IntervalCounter + deltaTime
			if self.IntervalCounter > self.SpawnData.Interval then
				local posx = self.SpawnData.Position.x
				local posy = self.SpawnData.Position.y
				local radian = math.atan2(posy, posx)
				local degree = radian * 180 / 3.1415
				EnemyManager:CreateEnemy(posx+(ScreenWidth/2), posy+(ScreenHeight/2), degree-90-180, self.SpawnData.EnemyType)
				self.IntervalCounter = 0
				self.SpawnedCounter = self.SpawnedCounter + 1
				if self.SpawnedCounter >= self.SpawnData.Value then
					self.IsEnable = false
				end
			end
		end
	end

	return this
end
