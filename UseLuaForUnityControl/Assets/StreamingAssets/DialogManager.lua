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
	self.CancelCallback = nil

	LuaLoadPrefabAfter("Prefabs/System/OkCancelDialog", "OkCancelDialog", "SystemCanvas")
	LuaFindObject("OkCancelDialogDetailText")
	LuaSetActive("OkCancelDialog", false)

end

function DialogManager:OpenDialog(detailText, okCallback, cancelCallback) 
	self.OkCallback =  okCallback
	self.CancelCallback = cancelCallback
	LuaSetText("OkCancelDialogDetailText", detailText)
	
	if self.IsDialogActive == false then
		self.IsDialogActive = true
		CallbackManager.Instance():AddCallback("DialogManager_OpenCallback", {self}, self.DialogOpenCallback)
		LuaPlayAnimator("OkCancelDialog", "Open", false, false, "LuaCallback", "DialogManager_OpenCallback")
	end
end

function DialogManager:CloseDialog() 
	if self.IsDialogActive == true then
		CallbackManager.Instance():AddCallback("DialogManager_CloseCallback", {self}, self.DialogCloseCallback)
		LuaPlayAnimator("OkCancelDialog", "Close", false, true, "LuaCallback", "DialogManager_CloseCallback")
	end
end

function DialogManager.DialogOpenCallback(arg, unityArg) 
end

function DialogManager.DialogCloseCallback(arg, unityArg) 
	local self =  arg[1]
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
		self:CloseDialog()
	elseif buttonName == "OkCancelDialogCancelButton" then
		if self.CancelCallback ~= nil then
			self.CancelCallback()
		end
		self:CloseDialog()
	end
end

