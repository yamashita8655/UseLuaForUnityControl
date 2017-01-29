﻿--直接Unityには登録しないスクリプト。いわゆる、ライブラリ化した奴

-- クラス定義
ResultDialog = {}

-- シングルトン用定義
local _instance = nil
function ResultDialog.Instance() 
	if not _instance then
		_instance = ResultDialog
		--setmetatable(_instance, { __index = ResultDialog })
	end

	return _instance
end

-- メソッド定義
function ResultDialog:Initialize() 
	self.IsActive = false
	self.CloseCallback = nil 

	LuaLoadPrefabAfter("Prefabs/System/ResultDialog", "ResultDialog", "SystemCanvas")

	LuaSetActive("ResultDialog", false)
end

function ResultDialog:SetParent(parentName) 
	LuaSetParent("ResultDialog", parentName)
end

function ResultDialog:OpenDialog(closeCallback) 
	if self.IsActive == false then
		self.CloseCallback = closeCallback
		self.IsActive = true
		CallbackManager.Instance():AddCallback("ResultDialogManager_OpenCallback", {self}, self.DialogOpenCallback)
		LuaPlayAnimator("ResultDialog", "Open", false, false, "LuaCallback", "ResultDialogManager_OpenCallback")
	end
end

function ResultDialog:CloseDialog() 
	if self.IsActive == true then
		CallbackManager.Instance():AddCallback("ResultDialogManager_CloseCallback", {self}, self.DialogCloseCallback)
		LuaPlayAnimator("ResultDialog", "Close", false, true, "LuaCallback", "ResultDialogManager_CloseCallback")
	end
end

function ResultDialog.DialogOpenCallback(arg, unityArg) 
end

function ResultDialog.DialogCloseCallback(arg, unityArg) 
	local self =  arg[1]
	self.IsActive = false
	LuaSetActive("ResultDialog", false)
	if self.CloseCallback ~= nil then
		self.CloseCallback()
	end
end

function ResultDialog:OnClickButton(buttonName) 
	if self.IsActive == false then
		return
	end

	if buttonName == "ResultOkButton" then
		self:CloseDialog()
	end
end

