﻿--直接Unityには登録しないスクリプト。いわゆる、ライブラリ化した奴

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
	LuaFindObject("SkillDetailText")
	LuaFindObject("SkillHaveExpText")

	LuaSetActive("SkillUpDialog", false)
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
		
		LuaSetText("SkillNowLevelText1", emitterNowLevel)
		LuaSetText("SkillMaxLevelText1", emitterMaxLevel)
		
		LuaSetText("SkillNowLevelText2", bulletNowLevel)
		LuaSetText("SkillMaxLevelText2", bulletMaxLevel)
		
		LuaSetText("SkillNowLevelText3", "1")
		LuaSetText("SkillMaxLevelText3", "1")
	
		LuaSetText("SkillHaveExpText", player:GetEXP())

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

