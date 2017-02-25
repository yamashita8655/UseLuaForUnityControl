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
	LuaFindObject("CharacterDetailFriendSlider")
	LuaFindObject("CharacterDetailRemailParameterUpCountText")
	LuaFindObject("CharacterAttachRoot")

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
		LuaSetText("CharacterDetailBaseAttackText", self.CharacterData.BaseParameter:Attack())
		LuaSetText("CharacterDetailBaseDeffenseText", self.CharacterData.BaseParameter:Deffense())

		LuaLoadPrefabAfter(self.CharacterData.PrefabName, self.CharacterData.PrefabName.."CharacterDetail", "CharacterAttachRoot")

		self:UpdateAddParameter()

		self:UpdateGrowMeter(characterData) 
		
		self.IsActive = true
		CallbackManager.Instance():AddCallback("CharacterDetailDialogManager_OpenCallback", {self}, self.DialogOpenCallback)
		LuaPlayAnimator("CharacterDetailDialog", "Open", false, false, "LuaCallback", "CharacterDetailDialogManager_OpenCallback")
	end
end

function CharacterDetailDialog:CloseDialog() 
	if self.IsActive == true then
		LuaDestroyObject(self.CharacterData.PrefabName.."CharacterDetail")
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
	elseif buttonName == "CharacterDetailStatusResetButton" then
		local isUnlocked = SaveObject.CustomScene_CharacterUnlockList[self.CharacterData.IdIndex]
		if isUnlocked == 0 then
			DialogManager.Instance():OpenDialog(
				"この子はまだ仲間になっていませんが、スキルをリセットしていいですか？",
				function()
					local characterAddParameter = SaveObject.CharacterList[self.CharacterData.IdIndex]
					characterAddParameter[CharacterParameterEnum.RemainParameterPoint] = 100
					characterAddParameter[CharacterParameterEnum.AddHp] = 0
					characterAddParameter[CharacterParameterEnum.AddAttack] = 0
					characterAddParameter[CharacterParameterEnum.AddDeffense] = 0
					FileIOManager.Instance():Save()
					self:UpdateAddParameter()
				end ,
				function()
				end,
				function()
				end,
				function()
				end
			)
		else
			DialogManager.Instance():OpenDialog(
				"本当にスキルをリセットしていいですか？",
				function()
					local characterAddParameter = SaveObject.CharacterList[self.CharacterData.IdIndex]
					characterAddParameter[CharacterParameterEnum.RemainParameterPoint] = 100
					characterAddParameter[CharacterParameterEnum.AddHp] = 0
					characterAddParameter[CharacterParameterEnum.AddAttack] = 0
					characterAddParameter[CharacterParameterEnum.AddDeffense] = 0
					FileIOManager.Instance():Save()
					self:UpdateAddParameter()
				end ,
				function()
				end,
				function()
				end,
				function()
				end
			)
		end
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

function CharacterDetailDialog:UpdateAddParameter() 
	local characterAddParameter = SaveObject.CharacterList[self.CharacterData.IdIndex]
	LuaSetText("CharacterDetailRemailParameterUpCountText", characterAddParameter[CharacterParameterEnum.RemainParameterPoint])
	LuaSetText("CharacterDetailAddHpText", characterAddParameter[CharacterParameterEnum.AddHp])
	LuaSetText("CharacterDetailAddAttackText", characterAddParameter[CharacterParameterEnum.AddAttack])
	LuaSetText("CharacterDetailAddDeffenseText", characterAddParameter[CharacterParameterEnum.AddDeffense])

	LuaSetSliderValue("CharacterDetailFriendSlider", characterAddParameter[CharacterParameterEnum.FriendPoint])

end

