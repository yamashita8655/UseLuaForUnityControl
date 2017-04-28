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
	GachaTableData.new(GachaItemTable.ParameterUpHp1_001, 15),
	GachaTableData.new(GachaItemTable.ParameterUpAttack1_001, 15),
	GachaTableData.new(GachaItemTable.ParameterUpDeffense1_001, 15),
	GachaTableData.new(GachaItemTable.ParameterUpFriendPoint1_001, 15),
	GachaTableData.new(GachaItemTable.ParameterUpHp2_001, 1),
	GachaTableData.new(GachaItemTable.ParameterUpAttack2_001, 1),
	GachaTableData.new(GachaItemTable.ParameterUpDeffense2_001, 1),
	GachaTableData.new(GachaItemTable.ParameterUpFriendPoint2_001, 1),
}

GachaTableBronze = {
	GachaTableData.new(GachaItemTable.MochiBronzeHpNormal, 63),
	GachaTableData.new(GachaItemTable.MochiBronzeAttackNormal, 63),
	GachaTableData.new(GachaItemTable.MochiBronzeDeffenseNormal, 63),
	GachaTableData.new(GachaItemTable.MochiBronzeFriendPointNormal, 63),
	GachaTableData.new(GachaItemTable.ToraBronzeHpNormal, 63),
	GachaTableData.new(GachaItemTable.ToraBronzeAttackNormal, 63),
	GachaTableData.new(GachaItemTable.ToraBronzeDeffenseNormal, 63),
	GachaTableData.new(GachaItemTable.ToraBronzeFriendPointNormal, 63),
	GachaTableData.new(GachaItemTable.BuchiBronzeHpNormal, 63),
	GachaTableData.new(GachaItemTable.BuchiBronzeAttackNormal, 63),
	GachaTableData.new(GachaItemTable.BuchiBronzeDeffenseNormal, 63),
	GachaTableData.new(GachaItemTable.BuchiBronzeFriendPointNormal, 63),
	GachaTableData.new(GachaItemTable.SakuraBronzeHpNormal, 63),
	GachaTableData.new(GachaItemTable.SakuraBronzeAttackNormal, 63),
	GachaTableData.new(GachaItemTable.SakuraBronzeDeffenseNormal, 63),
	GachaTableData.new(GachaItemTable.SakuraBronzeFriendPointNormal, 63),
	GachaTableData.new(GachaItemTable.MochiBronzeHpRare, 1),
	GachaTableData.new(GachaItemTable.MochiBronzeAttackRare, 1),
	GachaTableData.new(GachaItemTable.MochiBronzeDeffenseRare, 1),
	GachaTableData.new(GachaItemTable.MochiBronzeFriendPointRare, 1),
	GachaTableData.new(GachaItemTable.ToraBronzeHpRare, 1),
	GachaTableData.new(GachaItemTable.ToraBronzeAttackRare, 1),
	GachaTableData.new(GachaItemTable.ToraBronzeDeffenseRare, 1),
	GachaTableData.new(GachaItemTable.ToraBronzeFriendPointRare, 1),
	GachaTableData.new(GachaItemTable.BuchiBronzeHpRare, 1),
	GachaTableData.new(GachaItemTable.BuchiBronzeAttackRare, 1),
	GachaTableData.new(GachaItemTable.BuchiBronzeDeffenseRare, 1),
	GachaTableData.new(GachaItemTable.BuchiBronzeFriendPointRare, 1),
	GachaTableData.new(GachaItemTable.SakuraBronzeHpRare, 1),
	GachaTableData.new(GachaItemTable.SakuraBronzeAttackRare, 1),
	GachaTableData.new(GachaItemTable.SakuraBronzeDeffenseRare, 1),
	GachaTableData.new(GachaItemTable.SakuraBronzeFriendPointRare, 1),
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

