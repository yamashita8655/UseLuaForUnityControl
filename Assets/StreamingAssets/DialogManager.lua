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

end

function DialogManager:OpenDialog(detailText, okCallback, cancelCallback, okCloseCallback, cancelCloseCallback) 
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

function DialogManager:OkCloseDialog() 
	if self.IsDialogActive == true then
		CallbackManager.Instance():AddCallback("DialogManager_OkCloseCallback", {self}, self.DialogOkCloseCallback)
		LuaPlayAnimator("OkCancelDialog", "Close", false, true, "LuaCallback", "DialogManager_OkCloseCallback")
	end
end

function DialogManager:CancelCloseDialog() 
	if self.IsDialogActive == true then
		CallbackManager.Instance():AddCallback("DialogManager_CancelCloseCallback", {self}, self.DialogCancelCloseCallback)
		LuaPlayAnimator("OkCancelDialog", "Close", false, true, "LuaCallback", "DialogManager_CancelCloseCallback")
	end
end

function DialogManager.DialogOpenCallback(arg, unityArg) 
end

function DialogManager.DialogOkCloseCallback(arg, unityArg) 
	local self =  arg[1]
	self.OkCloseCallback()
	self.IsDialogActive = false
	LuaSetActive("OkCancelDialog", false)
end

function DialogManager.DialogCancelCloseCallback(arg, unityArg) 
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
		self:OkCloseDialog()
	elseif buttonName == "OkCancelDialogCancelButton" then
		if self.CancelCallback ~= nil then
			self.CancelCallback()
		end
		self:CancelCloseDialog()
	end
end

