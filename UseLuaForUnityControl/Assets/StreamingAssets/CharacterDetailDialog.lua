--直接Unityには登録しないスクリプト。いわゆる、ライブラリ化した奴

-- クラス定義
CharacterDetailDialog = {}

-- シングルトン用定義
local _instance = nil
function CharacterDetailDialog.Instance() 
	if not _instance then
		_instance = CharacterDetailDialog
		--setmetatable(_instance, { __index = CharacterDetailDialog })
	end

	return _instance
end

-- メソッド定義
function CharacterDetailDialog:Initialize() 
	self.IsActive = false
	self.CloseCallback = nil 
	self.CharacterData = {}

	LuaLoadPrefabAfter("Prefabs/System/CharacterDetailDialog", "CharacterDetailDialog", "SystemCanvas")
	
	LuaFindObject("CharacterDetailBaseHpText")
	LuaFindObject("CharacterDetailAddHpText")
	LuaFindObject("CharacterDetailBaseAttackText")
	LuaFindObject("CharacterDetailAddAttackText")
	LuaFindObject("CharacterDetailBaseDeffenseText")
	LuaFindObject("CharacterDetailAddDeffenseText")

	for i = 1, 5 do
		LuaFindObject("HpMeter"..i)
		LuaFindObject("AttackMeter"..i)
		LuaFindObject("DeffenseMeter"..i)
	end

	LuaSetActive("CharacterDetailDialog", false)
end

function CharacterDetailDialog:SetParent(parentName) 
	LuaSetParent("CharacterDetailDialog", parentName)
end

function CharacterDetailDialog:OpenDialog(closeCallback, characterData)
	if self.IsActive == false then

		self.CloseCallback = closeCallback
		self.CharacterData = characterData

		LuaSetText("CharacterDetailBaseHpText", self.CharacterData.BaseParameter:MaxHp())
		LuaSetText("CharacterDetailAddHpText", self.CharacterData.AddParameter:MaxHp())
		LuaSetText("CharacterDetailBaseAttackText", self.CharacterData.BaseParameter:Attack())
		LuaSetText("CharacterDetailAddAttackText", self.CharacterData.AddParameter:Attack())
		LuaSetText("CharacterDetailBaseDeffenseText", self.CharacterData.BaseParameter:Deffense())
		LuaSetText("CharacterDetailAddDeffenseText", self.CharacterData.AddParameter:Deffense())


		self:UpdateGrowMeter(characterData) 
		
		self.IsActive = true
		CallbackManager.Instance():AddCallback("CharacterDetailDialogManager_OpenCallback", {self}, self.DialogOpenCallback)
		LuaPlayAnimator("CharacterDetailDialog", "Open", false, false, "LuaCallback", "CharacterDetailDialogManager_OpenCallback")
	end
end

function CharacterDetailDialog:CloseDialog() 
	if self.IsActive == true then
		CallbackManager.Instance():AddCallback("CharacterDetailDialogManager_CloseCallback", {self}, self.DialogCloseCallback)
		LuaPlayAnimator("CharacterDetailDialog", "Close", false, true, "LuaCallback", "CharacterDetailDialogManager_CloseCallback")
	end
end

function CharacterDetailDialog.DialogOpenCallback(arg, unityArg) 
end

function CharacterDetailDialog.DialogCloseCallback(arg, unityArg) 
	local self =  arg[1]
	self.IsActive = false
	LuaSetActive("CharacterDetailDialog", false)
	if self.CloseCallback ~= nil then
		self.CloseCallback()
	end
end

function CharacterDetailDialog:OnClickButton(buttonName) 
	if self.IsActive == false then
		return
	end

	if buttonName == "CharacterDetailCloseButton" then
		self:CloseDialog()
	end
end

function CharacterDetailDialog:UpdateGrowMeter(characterConfig) 
	for i = 1, 5 do
		LuaSetActive("HpMeter"..i, false)
		LuaSetActive("AttackMeter"..i, false)
		LuaSetActive("DeffenseMeter"..i, false)
	end

	for i = 1, characterConfig.GrowType.Hp do
		LuaSetActive("HpMeter"..i, true)
	end

	for i = 1, characterConfig.GrowType.Attack do
		LuaSetActive("AttackMeter"..i, true)
	end
	
	for i = 1, characterConfig.GrowType.Deffense do
		LuaSetActive("DeffenseMeter"..i, true)
	end

end

