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

	LuaLoadPrefabAfter("battlescene", "SkillUpDialog", "SkillUpDialog", "SystemCanvas")
	
	LuaFindObject("SkillNowLevelText1")
	LuaFindObject("SkillNowLevelText2")
	--LuaFindObject("SkillNowLevelText3")
	LuaFindObject("SkillMaxLevelText1")
	LuaFindObject("SkillMaxLevelText2")
	--LuaFindObject("SkillMaxLevelText3")
	LuaFindObject("SkillSelectFilter1")
	LuaFindObject("SkillSelectFilter2")
	--LuaFindObject("SkillSelectFilter3")
	LuaFindObject("SkillUpButton1")
	LuaFindObject("SkillUpButton2")
	--LuaFindObject("SkillUpButton3")
	LuaFindObject("SkillDetailText")
	LuaFindObject("SkillHaveExpText")

	LuaFindObject("SkillHaveSkillPointText")
	LuaFindObject("SkillNextLevelUpText")
	

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
		--LuaSetActive("SkillSelectFilter3", false)

		local player = PlayerManager.Instance():GetPlayer() 
		local skillData = player:GetSkillConfig()
		local skillDetailData = player:GetSkillDetailText()
		
		self:UpdateHaveExpText()
		self:UpdateHaveSkillPoint()
		self:UpdateNeedNextExp()
		self:UpdateSkillText(SkillTypeEnum.Emitter) 
		self:UpdateSkillText(SkillTypeEnum.Bullet) 
		
		--LuaSetText("SkillNowLevelText3", "1")
		--LuaSetText("SkillMaxLevelText3", "1")
		--LuaSetButtonInteractable("SkillUpButton3", false)

		self.IsActive = true
		CallbackManager.Instance():AddCallback("SkillLevelUpDialogManager_OpenCallback", {self}, self.DialogOpenCallback)
		LuaPlayAnimator("SkillUpDialog", "Open", false, false, "LuaCallback", "SkillLevelUpDialogManager_OpenCallback")
	end
end

function SkillLevelUpDialog:UpdateSkillText(skillType) 
	--local objectIndex = 0
	--if skillType == SkillTypeEnum.Emitter then
	--	objectIndex = 1
	--elseif skillType == SkillTypeEnum.Bullet then
	--	objectIndex = 2
	--end
	--	
	--local player = PlayerManager.Instance():GetPlayer() 
	--local skillData = player:GetSkillConfig()
	--	
	--local nowLevel = skillData:GetSkillLevel(skillType)
	--local maxLevel = skillData:GetMaxSkillLevel(skillType)

	--LuaSetText("SkillNowLevelText"..objectIndex, nowLevel)
	--LuaSetText("SkillMaxLevelText"..objectIndex, maxLevel)
	--	
	--local nextExp = skillData:GetNextExp(skillType)
	--local playerExp = player:GetEXP()
	--if nextExp == "MAX" then
	--	LuaSetButtonInteractable("SkillUpButton"..objectIndex, false)
	--else
	--	if nextExp > playerExp then
	--		LuaSetButtonInteractable("SkillUpButton"..objectIndex, false)
	--	else
	--		LuaSetButtonInteractable("SkillUpButton"..objectIndex, true)
	--	end
	--end
	
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
		
	local playerSkillPoint = player:GetHaveSkillPoint()
	LuaUnityDebugLog("point"..playerSkillPoint)
	if nowLevel == maxLevel then
		LuaSetButtonInteractable("SkillUpButton"..objectIndex, false)
	else
		if playerSkillPoint > 0 then
			LuaSetButtonInteractable("SkillUpButton"..objectIndex, true)
		else
			LuaSetButtonInteractable("SkillUpButton"..objectIndex, false)
		end
	end
	
	-- 次のレベルまでの経験値量設定
	local playerSkillLevel = player:GetSkillLevel()
	local nextExp = skillData:GetNextExp(playerSkillLevel)
	if nextExp == -1 then
		nextExp = "MAX"
	end
	LuaSetText("SkillNextLevelUpText", nextExp)
end

function SkillLevelUpDialog:UpdateHaveExpText() 
	local player = PlayerManager.Instance():GetPlayer() 
	local exp = player:GetEXP()
	LuaSetText("SkillHaveExpText", math.floor(exp))
end

function SkillLevelUpDialog:UpdateSkillPointText() 
	local player = PlayerManager.Instance():GetPlayer() 
	local playerSkillPoint = player:GetHaveSkillPoint()
	LuaSetText("SkillHaveSkillPointText", playerSkillPoint)
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
	local playerSkillLevel = player:GetSkillLevel()
	local nextExp = skillConfig:GetNextExp(playerSkillLevel)
	skillConfig:AddSkillLevel(skillType)
	
	local emitterNowLevel = skillConfig:GetSkillLevel(SkillTypeEnum.Emitter)
	local bulletNowLevel = skillConfig:GetSkillLevel(SkillTypeEnum.Bullet)
	local skillTable = skillConfig:GetSkillTable()
	
	player:ClearBulletEmitter()
	player = UtilityFunction.Instance().SetEmitter(player, skillTable[SkillTypeEnum.Emitter][emitterNowLevel].BulletEmitterList, skillTable[SkillTypeEnum.Bullet][bulletNowLevel].EquipBulletList, CharacterType.Player)

	self:UpdateHaveSkillPoint()
	self:UpdateSkillPointText()
	self:UpdateSkillText(skillType) 
end

function SkillLevelUpDialog:UpdateHaveSkillPoint() 
	local player = PlayerManager.Instance():GetPlayer()
	local point = player:GetHaveSkillPoint()
	LuaSetText("SkillHaveSkillPointText", point)
end

function SkillLevelUpDialog:UpdateNeedNextExp() 
	local needExp = 0
	LuaSetText("SkillNextLevelUpText", needExp)
end

function SkillLevelUpDialog:OnClickButton(buttonName) 
	if self.IsActive == false then
		return
	end

	if buttonName == "SkillUpCloseButton" then
		self:CloseDialog()
	else
		if buttonName == "SkillDetailButton1" then
			self:ToggleSkillSelectFilter(1) 
		elseif buttonName == "SkillDetailButton2" then
			self:ToggleSkillSelectFilter(2) 
		elseif buttonName == "SkillDetailButton3" then
			self:ToggleSkillSelectFilter(3) 
		elseif buttonName == "SkillUpButton1" then
			DialogManager.Instance():OpenOkCancelDialog(
				"スキルのレベルを上げていいですか？",
				function()
					self:AddPlayerSkillPoint(-1)
					self:UpdateSkillLevel(SkillTypeEnum.Emitter)
					self:UpdateSkillText(SkillTypeEnum.Bullet) 
					self:UpdateSkillPointText() 
				end ,
				function()
				end,
				function()
				end,
				function()
				end
			)
		elseif buttonName == "SkillUpButton2" then
			DialogManager.Instance():OpenOkCancelDialog(
				"スキルのレベルを上げていいですか？",
				function()
					self:AddPlayerSkillPoint(-1)
					self:UpdateSkillLevel(SkillTypeEnum.Bullet)
					self:UpdateSkillText(SkillTypeEnum.Emitter) 
					self:UpdateSkillPointText() 
				end,
				function()
				end,
				function()
				end,
				function()
				end
			)
		elseif buttonName == "SkillUpButton3" then
		end
	end
end

function SkillLevelUpDialog:AddPlayerSkillPoint(val) 
	local player = PlayerManager.Instance():GetPlayer() 
	player:AddHaveSkillPoint(val)
end

function SkillLevelUpDialog:ToggleSkillSelectFilter(selectIndex) 
	local player = PlayerManager.Instance():GetPlayer() 
	local skillDetailData = player:GetSkillDetailText()
	if selectIndex == 1 then
		LuaSetText("SkillDetailText", skillDetailData[1])
		LuaSetActive("SkillSelectFilter1", true)
		LuaSetActive("SkillSelectFilter2", false)
		--LuaSetActive("SkillSelectFilter3", false)
	elseif selectIndex == 2 then
		LuaSetText("SkillDetailText", skillDetailData[2])
		LuaSetActive("SkillSelectFilter1", false)
		LuaSetActive("SkillSelectFilter2", true)
		--LuaSetActive("SkillSelectFilter3", false)
	elseif selectIndex == 3 then
		LuaSetText("SkillDetailText", skillDetailData[3])
		LuaSetActive("SkillSelectFilter1", false)
		LuaSetActive("SkillSelectFilter2", false)
		--LuaSetActive("SkillSelectFilter3", true)
	end
end

