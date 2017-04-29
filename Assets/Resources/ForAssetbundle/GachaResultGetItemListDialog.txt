--直接Unityには登録しないスクリプト。いわゆる、ライブラリ化した奴

-- クラス定義
GachaResultGetItemListDialog = {}

-- シングルトン用定義
local _instance = nil
function GachaResultGetItemListDialog.Instance() 
	if not _instance then
		_instance = GachaResultGetItemListDialog
		--setmetatable(_instance, { __index = GachaResultGetItemListDialog })
	end

	return _instance
end

-- メソッド定義
function GachaResultGetItemListDialog:Initialize() 
	self.IsActive = false
	self.CloseCallback = nil 

	LuaLoadPrefabAfter("gacharesultscene", "GachaResultGetItemListDialog", "GachaResultGetItemListDialog", "SystemCanvas")
	LuaFindObject("GachaResultGetItemListScrollContent")

	for i = 1, 100 do
		LuaLoadPrefabAfter("gacharesultscene", "GachaResultGetItemListItem", "GachaResultGetItemListItem"..i, "GachaResultGetItemListScrollContent")
		LuaRenameObject("GachaResultGetItemListText", "GachaResultGetItemListText"..i)
		LuaSetText("GachaResultGetItemListText"..i, i)
	end
	
	--LuaFindObject("SkillHaveExpText")

	LuaSetActive("GachaResultGetItemListDialog", false)
end

function GachaResultGetItemListDialog:SetParent(parentName) 
	LuaSetParent("GachaResultGetItemListDialog", parentName)
end

function GachaResultGetItemListDialog:OpenDialog(closeCallback, itemList) 
	if self.IsActive == false then

		self:SetNonActiveTextItem()
		self:SetItemText(itemList)

		self.CloseCallback = closeCallback
		
		self.IsActive = true
		CallbackManager.Instance():AddCallback("GachaResultGetItemListDialogManager_OpenCallback", {self}, self.DialogOpenCallback)
		LuaPlayAnimator("GachaResultGetItemListDialog", "Open", false, false, "LuaCallback", "GachaResultGetItemListDialogManager_OpenCallback")
	end
end

function GachaResultGetItemListDialog:CloseDialog() 
	if self.IsActive == true then
		CallbackManager.Instance():AddCallback("GachaResultGetItemListDialogManager_CloseCallback", {self}, self.DialogCloseCallback)
		LuaPlayAnimator("GachaResultGetItemListDialog", "Close", false, true, "LuaCallback", "GachaResultGetItemListDialogManager_CloseCallback")
	end
end

function GachaResultGetItemListDialog.DialogOpenCallback(arg, unityArg) 
end

function GachaResultGetItemListDialog.DialogCloseCallback(arg, unityArg) 
	local self =  arg[1]
	self.IsActive = false
	LuaSetActive("GachaResultGetItemListDialog", false)
	if self.CloseCallback ~= nil then
		self.CloseCallback()
	end
end

function GachaResultGetItemListDialog:OnClickButton(buttonName) 
	if self.IsActive == false then
		return
	end

	if buttonName == "GachaResultGetItemListCloseButton" then
		self:CloseDialog()
	end
end

function GachaResultGetItemListDialog:SetItemText(itemList) 
	for i = 1, #itemList do
		LuaSetActive("GachaResultGetItemListItem"..i, true)
		local str = UtilityFunction.CreateGachaResultGetItemString(itemList[i])
		LuaSetText("GachaResultGetItemListText"..i, str)
	end
end

function GachaResultGetItemListDialog:SetNonActiveTextItem() 
	for i = 1, 100 do
		LuaSetActive("GachaResultGetItemListItem"..i, false)
	end
end

