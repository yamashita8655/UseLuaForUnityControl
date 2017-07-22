--直接Unityには登録しないスクリプト。いわゆる、ライブラリ化した奴

-- クラス定義
DialogManager = {}

-- シングルトン用定義
local _instance = nil
function DialogManager.Instance() 
	if not _instance then
		_instance = DialogManager
		--setmetatable(_instance, { __index = DialogManager })
	end

	return _instance
end

-- メソッド定義
function DialogManager:Initialize() 
	self.IsDialogActive = false
	self.OkCallback = nil 
	self.OkAfterCloseCallback = nil 
	self.CancelCallback = nil
	self.CancelAfterCloseCallback = nil

	LuaLoadPrefabAfter("common", "OkCancelDialog", "OkCancelDialog", "SystemCanvas")
	LuaFindObject("OkCancelDialogDetailText")
	LuaSetActive("OkCancelDialog", false)
	
	LuaLoadPrefabAfter("common", "OkDialog", "OkDialog", "SystemCanvas")
	LuaFindObject("OkDialogDetailText")
	LuaSetActive("OkDialog", false)

end

function DialogManager:OpenOkDialog(detailText, okCallback, okCloseCallback) 
	self.OkCallback =  okCallback
	self.OkCloseCallback =  okCloseCallback
	self.CancelCloseCallback = cancelCloseCallback
	LuaSetText("OkDialogDetailText", detailText)
	
	if self.IsDialogActive == false then
		self.IsDialogActive = true
		CallbackManager.Instance():AddCallback("DialogManager_OpenCallback", {self}, self.DialogOpenCallback)
		LuaPlayAnimator("OkDialog", "Open", false, false, "LuaCallback", "DialogManager_OpenCallback")
	end
end

function DialogManager:OkCloseDialog() 
	if self.IsDialogActive == true then
		CallbackManager.Instance():AddCallback("DialogManager_OkCloseCallback", {self}, self.DialogOkCloseCallback)
		LuaPlayAnimator("OkDialog", "Close", false, true, "LuaCallback", "DialogManager_OkCloseCallback")
	end
end

function DialogManager.DialogOkCloseCallback(arg, unityArg) 
	local self =  arg[1]
	self.OkCloseCallback()
	self.IsDialogActive = false
	LuaSetActive("OkDialog", false)
end

function DialogManager:OpenOkCancelDialog(detailText, okCallback, cancelCallback, okCloseCallback, cancelCloseCallback) 
	self.OkCallback =  okCallback
	self.CancelCallback = cancelCallback
	self.OkCloseCallback =  okCloseCallback
	self.CancelCloseCallback = cancelCloseCallback
	LuaSetText("OkCancelDialogDetailText", detailText)
	
	if self.IsDialogActive == false then
		self.IsDialogActive = true
		CallbackManager.Instance():AddCallback("DialogManager_OpenCallback", {self}, self.DialogOpenCallback)
		LuaPlayAnimator("OkCancelDialog", "Open", false, false, "LuaCallback", "DialogManager_OpenCallback")
	end
end

function DialogManager:OkCancelOkCloseDialog() 
	if self.IsDialogActive == true then
		CallbackManager.Instance():AddCallback("DialogManager_OkCloseCallback", {self}, self.DialogOkCancelOkCloseCallback)
		LuaPlayAnimator("OkCancelDialog", "Close", false, true, "LuaCallback", "DialogManager_OkCloseCallback")
	end
end

function DialogManager:OkCancelCancelCloseDialog() 
	if self.IsDialogActive == true then
		CallbackManager.Instance():AddCallback("DialogManager_CancelCloseCallback", {self}, self.DialogOkCancelCancelCloseCallback)
		LuaPlayAnimator("OkCancelDialog", "Close", false, true, "LuaCallback", "DialogManager_CancelCloseCallback")
	end
end

function DialogManager.DialogOpenCallback(arg, unityArg) 
end

function DialogManager.DialogOkCancelOkCloseCallback(arg, unityArg) 
	local self =  arg[1]
	self.OkCloseCallback()
	self.IsDialogActive = false
	LuaSetActive("OkCancelDialog", false)
end

function DialogManager.DialogOkCancelCancelCloseCallback(arg, unityArg) 
	local self =  arg[1]
	self.CancelCloseCallback()
	self.IsDialogActive = false
	LuaSetActive("OkCancelDialog", false)
end

function DialogManager:OnClickButton(buttonName) 
	if self.IsDialogActive == false then
		return
	end

	if buttonName == "OkCancelDialogOkButton" then
		if self.OkCallback ~= nil then
			self.OkCallback()
		end
		self:OkCancelOkCloseDialog()
	elseif buttonName == "OkCancelDialogCancelButton" then
		if self.CancelCallback ~= nil then
			self.CancelCallback()
		end
		self:OkCancelCancelCloseDialog()
	elseif buttonName == "OkDialogOkButton" then
		if self.OkCallback ~= nil then
			self.OkCallback()
		end
		self:OkCloseDialog()
	end
end

function DialogManager:OnToggleValueChange(hierarchyName, value)
	if self.IsDialogActive == false then
		return
	end
end
