--直接Unityには登録しないスクリプト。いわゆる、ライブラリ化した奴

-- クラス定義
CharacterParameterUpDialog = {}

-- シングルトン用定義
local _instance = nil
function CharacterParameterUpDialog.Instance() 
	if not _instance then
		_instance = CharacterParameterUpDialog
		--setmetatable(_instance, { __index = CharacterParameterUpDialog })
	end

	return _instance
end

-- メソッド定義
function CharacterParameterUpDialog:Initialize() 
	self.IsActive = false
	self.CloseCallback = nil 
	self.PrefabName = ""

	LuaLoadPrefabAfter("gacharesultscene", "CharacterParameterUpDialog", "CharacterParameterUpDialog", "SystemCanvas")
	
	LuaFindObject("CharacterParameterUpBaseHpText")
	LuaFindObject("CharacterParameterUpAddHpText")
	LuaFindObject("CharacterParameterUpBaseAttackText")
	LuaFindObject("CharacterParameterUpAddAttackText")
	LuaFindObject("CharacterParameterUpBaseDeffenseText")
	LuaFindObject("CharacterParameterUpAddDeffenseText")
	LuaFindObject("CharacterParameterAttachRoot")
	LuaFindObject("CharacterParameterUpAddFriendPointText")
	LuaFindObject("CharacterParameterUpFriendSlider")

	LuaSetActive("CharacterParameterUpDialog", false)
end

function CharacterParameterUpDialog:SetParent(parentName) 
	LuaSetParent("CharacterParameterUpDialog", parentName)
end

function CharacterParameterUpDialog:OpenDialog(openCallback, closeCallback, baseHp, baseAttack,  baseDeffense, baseFriendPoint, addHp, addAttack, addDeffense, addFriendPoint, prefabName)
	if self.IsActive == false then
		LuaSetText("CharacterParameterUpBaseHpText", baseHp)
		LuaSetText("CharacterParameterUpAddHpText", "+"..addHp)
		LuaSetText("CharacterParameterUpBaseAttackText", baseAttack)
		LuaSetText("CharacterParameterUpAddAttackText", "+"..addAttack)
		LuaSetText("CharacterParameterUpBaseDeffenseText", baseDeffense)
		LuaSetText("CharacterParameterUpAddDeffenseText", "+"..addDeffense)
		LuaSetText("CharacterParameterUpAddFriendPointText", "+"..addFriendPoint)
		LuaSetSliderValue("CharacterParameterUpFriendSlider", baseFriendPoint)

		self.PrefabName = prefabName

		--キャラ画像
		LuaLoadPrefabAfter("common", self.PrefabName, self.PrefabName.."CharacterParameterUp", "CharacterParameterAttachRoot")

		self.OpenCallback = openCallback
		self.CloseCallback = closeCallback
		self.IsActive = true
		CallbackManager.Instance():AddCallback("CharacterParameterUpDialogManager_OpenCallback", {self}, self.DialogOpenCallback)
		LuaPlayAnimator("CharacterParameterUpDialog", "Open", false, false, "LuaCallback", "CharacterParameterUpDialogManager_OpenCallback")
	end
end

function CharacterParameterUpDialog:CloseDialog() 
	if self.IsActive == true then
		LuaDestroyObject(self.PrefabName.."CharacterParameterUp")
		CallbackManager.Instance():AddCallback("CharacterParameterUpDialogManager_CloseCallback", {self}, self.DialogCloseCallback)
		LuaPlayAnimator("CharacterParameterUpDialog", "Close", false, true, "LuaCallback", "CharacterParameterUpDialogManager_CloseCallback")
	end
end

function CharacterParameterUpDialog.DialogOpenCallback(arg, unityArg) 
	local self =  arg[1]
	if self.OpenCallback ~= nil then
		self.OpenCallback()
	end
end

function CharacterParameterUpDialog.DialogCloseCallback(arg, unityArg) 
	local self =  arg[1]
	self.IsActive = false
	LuaSetActive("CharacterParameterUpDialog", false)
	if self.CloseCallback ~= nil then
		self.CloseCallback()
	end
end

function CharacterParameterUpDialog:OnClickButton(buttonName) 
	if self.IsActive == false then
		return
	end

	if buttonName == "ResultOkButton" then
		self:CloseDialog()
	end
end

