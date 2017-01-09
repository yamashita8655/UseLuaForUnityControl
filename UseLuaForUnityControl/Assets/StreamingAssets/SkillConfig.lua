--直接Unityには登録しないスクリプト。いわゆる、ライブラリ化した奴

SkillTypeEnum = {
	Emitter = 1,
	Bullet = 2,
}

-- 弾の発射台の設定
SkillData = {}

function SkillData.new(skillTable)
	local this = {
		SkillLevelList = {},
		SkillMaxLevelList = {},
		SkillNextExpList = {},
		SkillDetailTextList = {},
	}

	for i = 1, #skillTable do
		table.insert(this.SkillLevelList, 1)
	end
	
	for i = 1, #skillTable do
		local skillTableData = skillTable[i]
		local val = #skillTableData
		table.insert(this.SkillMaxLevelList, val)
	end
	
	for i = 1, #skillTable do
		table.insert(this.SkillNextExpList, skillTable[i])
	end
	
	--for i = 1, #skillTable do
	--	table.insert(this.SkillDetailTextList, skillTable[i])
	--end

	this.GetSkillLevel = function(self, skillType)
		return self.SkillLevelList[skillType]
	end
	this.AddSkillLevel = function(self, skillType)
		self.SkillLevelList[skillType] = self.SkillLevelList[skillType] + 1
	end
	
	this.GetMaxSkillLevel = function(self, skillType)
		return self.SkillMaxLevelList[skillType]
	end
	this.GetNextExp = function(self, skillType)
		local nowLevel = self.SkillLevelList[skillType]
		local maxLevel = self.SkillMaxLevelList[skillType]
		local exp = ""
		if nowLevel == maxLevel then
			exp = "MAX"
		else
			local typeTable = self.SkillNextExpList[skillType]
			local levelData = typeTable[nowLevel+1]
			exp = levelData[1]
		end

		return exp
	end
	
	return this
end



-- スキル定義
--SkillEmitter001 = {
--	Emitter001.new(1.0, Vector2.new(0, 0), EmitterTypeEnum.Normal),
--}
--
--SkillEmitter002 = {
--	Emitter001.new(1.0, Vector2.new(0, 0), EmitterTypeEnum.Normal),
--	Emitter001.new(0.25, Vector2.new(100, 0), EmitterTypeEnum.Satellite),
--	Emitter001.new(0.25, Vector2.new(-100, 0), EmitterTypeEnum.Satellite),
--}

SkillTable_001 = {
	-- Emitter
	{
		{0},
		{100},
	},
	
	-- Bullet
	{
		{0},
		{50},
		{1000},
	},
}

SkillDetailText001 = {
	-- EmitterDetail
	"弾の出現数が変化する\nみたいです。\nみたいだな。",
	-- BulletDetail
	"弾が強くなる\nみたいです。\nみたいだな。",
	-- Test
	"多分パッシブ\nHPとか。\nそのへん。",
}

