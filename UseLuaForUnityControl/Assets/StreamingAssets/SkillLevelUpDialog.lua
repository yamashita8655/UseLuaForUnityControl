--直接Unityには登録しないスクリプト。いわゆる、ライブラリ化した奴

-- クラス定義
SkillLevelUpDialog = {}

-- シングルトン用定義
local _instance = nil
function SkillLevelUpDialog.Instance() 
	if not _instance then
		_instance = SkillLevelUpDialog
		--setmetatable(_instance, { __index = SkillLevelUpDialog })
	end

	return _instance
end

-- メソッド定義
function SkillLevelUpDialog:Initialize() 
	self.IsActive = false
	self.CloseCallback = nil 

	LuaLoadPrefabAfter("Prefabs/System/SkillUpDialog", "SkillUpDialog", "SystemCanvas")
	
	LuaFindObject("SkillNowLevelText1")
	LuaFindObject("SkillNowLevelText2")
	LuaFindObject("SkillNowLevelText3")
	LuaFindObject("SkillMaxLevelText1")
	LuaFindObject("SkillMaxLevelText2")
	LuaFindObject("SkillMaxLevelText3")
	LuaFindObject("SkillSelectFilter1")
	LuaFindObject("SkillSelectFilter2")
	LuaFindObject("SkillSelectFilter3")
	LuaFindObject("SkillUpButton1")
	LuaFindObject("SkillUpButton2")
	LuaFindObject("SkillUpButton3")
	LuaFindObject("SkillNeedExpText1")
	LuaFindObject("SkillNeedExpText2")
	LuaFindObject("SkillNeedExpText3")
	LuaFindObject("SkillDetailText")
	LuaFindObject("SkillHaveExpText")

	LuaSetActive("SkillUpDialog", false)
end

function SkillLevelUpDialog:SetParent(parentName) 
	LuaSetParent("SkillUpDialog", parentName)
end

function SkillLevelUpDialog:OpenDialog(closeCallback) 
	if self.IsActive == false then

		self.CloseCallback = closeCallback
		
		LuaSetActive("SkillSelectFilter1", false)
		LuaSetActive("SkillSelectFilter2", false)
		LuaSetActive("SkillSelectFilter3", false)

		local player = PlayerManager.Instance():GetPlayer() 
		local skillData = player:GetSkillConfig()
		local skillDetailData = player:GetSkillDetailText()
		
		self:UpdateHaveExpText()
		self:UpdateSkillText(SkillTypeEnum.Emitter) 
		self:UpdateSkillText(SkillTypeEnum.Bullet) 

		
		LuaSetText("SkillNowLevelText3", "1")
		LuaSetText("SkillMaxLevelText3", "1")
		LuaSetButtonInteractable("SkillUpButton3", false)
		LuaSetText("SkillNeedExpText3", "empty")

		self.IsActive = true
		CallbackManager.Instance():AddCallback("SkillLevelUpDialogManager_OpenCallback", {self}, self.DialogOpenCallback)
		LuaPlayAnimator("SkillUpDialog", "Open", false, false, "LuaCallback", "SkillLevelUpDialogManager_OpenCallback")
	end
end

function SkillLevelUpDialog:UpdateSkillText(skillType) 
	local objectIndex = 0
	if skillType == SkillTypeEnum.Emitter then
		objectIndex = 1
	elseif skillType == SkillTypeEnum.Bullet then
		objectIndex = 2
	end
		
	local player = PlayerManager.Instance():GetPlayer() 
	local skillData = player:GetSkillConfig()
		
	local nowLevel = skillData:GetSkillLevel(skillType)
	local maxLevel = skillData:GetMaxSkillLevel(skillType)

	LuaSetText("SkillNowLevelText"..objectIndex, nowLevel)
	LuaSetText("SkillMaxLevelText"..objectIndex, maxLevel)
		
	local nextExp = skillData:GetNextExp(skillType)
	local playerExp = player:GetEXP()
	if nextExp == "MAX" then
		LuaSetButtonInteractable("SkillUpButton"..objectIndex, false)
	else
		if nextExp > playerExp then
			LuaSetButtonInteractable("SkillUpButton"..objectIndex, false)
		else
			LuaSetButtonInteractable("SkillUpButton"..objectIndex, true)
		end
	end
	LuaSetText("SkillNeedExpText"..objectIndex, nextExp)
end

function SkillLevelUpDialog:UpdateHaveExpText() 
	local player = PlayerManager.Instance():GetPlayer() 
	local playerExp = player:GetEXP()
	LuaSetText("SkillHaveExpText", playerExp)
end

function SkillLevelUpDialog:CloseDialog() 
	if self.IsActive == true then
		CallbackManager.Instance():AddCallback("SkillLevelUpDialogManager_CloseCallback", {self}, self.DialogCloseCallback)
		LuaPlayAnimator("SkillUpDialog", "Close", false, true, "LuaCallback", "SkillLevelUpDialogManager_CloseCallback")
	end
end

function SkillLevelUpDialog.DialogOpenCallback(arg, unityArg) 
end

function SkillLevelUpDialog.DialogCloseCallback(arg, unityArg) 
	local self =  arg[1]
	self.IsActive = false
	LuaSetActive("SkillUpDialog", false)
	if self.CloseCallback ~= nil then
		self.CloseCallback()
	end
end

function SkillLevelUpDialog:UpdateSkillLevel(skillType) 
	local player = PlayerManager.Instance():GetPlayer()
	local skillConfig = player:GetSkillConfig()
	local nextExp = skillConfig:GetNextExp(skillType)
	skillConfig:AddSkillLevel(skillType)
	
	local emitterNowLevel = skillConfig:GetSkillLevel(SkillTypeEnum.Emitter)
	local bulletNowLevel = skillConfig:GetSkillLevel(SkillTypeEnum.Bullet)
	local skillTable = skillConfig:GetSkillTable()
	local playerExp = player:GetEXP()
	
	player:ClearBulletEmitter()
	player = UtilityFunction.Instance().SetEmitter(player, skillTable[SkillTypeEnum.Emitter][emitterNowLevel].BulletEmitterList, skillTable[SkillTypeEnum.Bullet][bulletNowLevel].EquipBulletList, CharacterType.Player)

	player:AddEXP(-nextExp)
	
	self:UpdateHaveExpText()
	self:UpdateSkillText(skillType) 
end

function SkillLevelUpDialog:OnClickButton(buttonName) 
	if self.IsActive == false then
		return
	end

	if buttonName == "SkillUpCloseButton" then
		self:CloseDialog()
	else
		if buttonName == "SkillUpImageButton1" then
			self:ToggleSkillSelectFilter(1) 
		elseif buttonName == "SkillUpImageButton2" then
			self:ToggleSkillSelectFilter(2) 
		elseif buttonName == "SkillUpImageButton3" then
			self:ToggleSkillSelectFilter(3) 
		elseif buttonName == "SkillUpButton1" then
			DialogManager.Instance():OpenDialog(
				"スキルのレベルを上げていいですか？",
				function()
					self:UpdateSkillLevel(SkillTypeEnum.Emitter)
				end
				,
				function()
				end
			)
		elseif buttonName == "SkillUpButton2" then
			DialogManager.Instance():OpenDialog(
				"スキルのレベルを上げていいですか？",
				function()
					self:UpdateSkillLevel(SkillTypeEnum.Bullet)
				end
				,
				function()
				end
			)
		elseif buttonName == "SkillUpButton3" then
		end
	end
end

function SkillLevelUpDialog:ToggleSkillSelectFilter(selectIndex) 
	local player = PlayerManager.Instance():GetPlayer() 
	local skillDetailData = player:GetSkillDetailText()
	if selectIndex == 1 then
		LuaSetText("SkillDetailText", skillDetailData[1])
		LuaSetActive("SkillSelectFilter1", true)
		LuaSetActive("SkillSelectFilter2", false)
		LuaSetActive("SkillSelectFilter3", false)
	elseif selectIndex == 2 then
		LuaSetText("SkillDetailText", skillDetailData[2])
		LuaSetActive("SkillSelectFilter1", false)
		LuaSetActive("SkillSelectFilter2", true)
		LuaSetActive("SkillSelectFilter3", false)
	elseif selectIndex == 3 then
		LuaSetText("SkillDetailText", skillDetailData[3])
		LuaSetActive("SkillSelectFilter1", false)
		LuaSetActive("SkillSelectFilter2", false)
		LuaSetActive("SkillSelectFilter3", true)
	end
end

