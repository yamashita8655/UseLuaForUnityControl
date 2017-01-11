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
		
		local emitterNowLevel = skillData:GetSkillLevel(SkillTypeEnum.Emitter)
		local emitterMaxLevel = skillData:GetMaxSkillLevel(SkillTypeEnum.Emitter)
		
		local bulletNowLevel = skillData:GetSkillLevel(SkillTypeEnum.Bullet)
		local bulletMaxLevel = skillData:GetMaxSkillLevel(SkillTypeEnum.Bullet)

		local playerExp = player:GetEXP()
		
		LuaSetText("SkillNowLevelText1", emitterNowLevel)
		LuaSetText("SkillMaxLevelText1", emitterMaxLevel)
		
		LuaSetText("SkillNowLevelText2", bulletNowLevel)
		LuaSetText("SkillMaxLevelText2", bulletMaxLevel)
		
		LuaSetText("SkillNowLevelText3", "1")
		LuaSetText("SkillMaxLevelText3", "1")
	
		LuaSetText("SkillHaveExpText", playerExp)

		local emitterNextExp = skillData:GetNextExp(SkillTypeEnum.Emitter)
		if emitterNextExp == "MAX" then
			LuaSetButtonInteractable("SkillUpButton1", false)
		else
			if emitterNextExp > playerExp then
				LuaSetButtonInteractable("SkillUpButton1", false)
			else
				LuaSetButtonInteractable("SkillUpButton1", true)
			end
		end
		LuaSetText("SkillNeedExpText1", emitterNextExp)
		
		local bulletNextExp = skillData:GetNextExp(SkillTypeEnum.Bullet)
		if bulletNextExp == "MAX" then
			LuaSetButtonInteractable("SkillUpButton2", false)
		else
			if bulletNextExp > playerExp then
				LuaSetButtonInteractable("SkillUpButton2", false)
			else
				LuaSetButtonInteractable("SkillUpButton2", true)
			end
		end
		LuaSetText("SkillNeedExpText2", bulletNextExp)
		
		LuaSetButtonInteractable("SkillUpButton3", false)
		LuaSetText("SkillNeedExpText3", "empty")

		self.IsActive = true
		CallbackManager.Instance():AddCallback("SkillLevelUpDialogManager_OpenCallback", {self}, self.DialogOpenCallback)
		LuaPlayAnimator("SkillUpDialog", "Open", false, false, "LuaCallback", "SkillLevelUpDialogManager_OpenCallback")
	end
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

function SkillLevelUpDialog:OnClickButton(buttonName) 
	if self.IsActive == false then
		return
	end

	LuaUnityDebugLog(buttonName)

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
					LuaUnityDebugLog("clickOk")
				end
				,
				function()
					LuaUnityDebugLog("clickCancel")
				end
			)
		elseif buttonName == "SkillUpButton2" then
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

