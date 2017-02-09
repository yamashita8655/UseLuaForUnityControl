--直接Unityには登録しないスクリプト。いわゆる、ライブラリ化した奴
-- コンストラクタ
GachaTableData = {}
function GachaTableData.new(itemData, weight)
	local this = {
		ItemData = itemData,
		Weight = weight,
	}
	
	this.GetItemData = function(self)
		return self.ItemData
	end
	this.GetWeight = function(self)
		return self.Weight
	end

	return this
end

-- コンストラクタ
GachaExecuteObject = {}
function GachaExecuteObject.new(gachaTable)
	local this = {
		GachaTable = gachaTable,
	}
	
	this.GetGachaTable = function(self)
		return self.GachaTable
	end
	this.RollGacha = function(self, count)
		local totalWeight = 0
		for i = 1, #self.GachaTable do
			totalWeight = totalWeight + self.GachaTable[i]:GetWeight()
		end
		
		local outputList = {}
		
		for i = 1, count do
			local rand = math.random(1, totalWeight)
			for j = 1, #self.GachaTable do
				rand = rand - self.GachaTable[j]:GetWeight()
				if rand <= 0 then
					table.insert(outputList, self.GachaTable[j]:GetItemData())
				    break;
				end
			end
		end

		return outputList
	end

	return this
end


-- ガチャから排出されるアイテムの定義
GachaTableWood = {
	GachaTableData.new(GachaItemTable.ParameterUpHp1_001, 100),
	GachaTableData.new(GachaItemTable.ParameterUpAttack1_001, 100),
	GachaTableData.new(GachaItemTable.ParameterUpDeffense1_001, 100),
}

GachaTableBronze = {
	GachaTableData.new(GachaItemTable.ParameterUpHp1_001, 1000),
	GachaTableData.new(GachaItemTable.ParameterUpAttack1_001, 100),
	GachaTableData.new(GachaItemTable.ParameterUpDeffense1_001, 100),
}

GachaTableSilver = {
	GachaTableData.new(GachaItemTable.ParameterUpHp1_001, 100),
	GachaTableData.new(GachaItemTable.ParameterUpAttack1_001, 1000),
	GachaTableData.new(GachaItemTable.ParameterUpDeffense1_001, 100),
}

GachaTableGold = {
	GachaTableData.new(GachaItemTable.ParameterUpHp1_001, 100),
	GachaTableData.new(GachaItemTable.ParameterUpAttack1_001, 100),
	GachaTableData.new(GachaItemTable.ParameterUpDeffense1_001, 1000),
}

