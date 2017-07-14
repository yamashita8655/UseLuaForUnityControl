--直接Unityには登録しないスクリプト。いわゆる、ライブラリ化した奴

-- クラス定義
QuestEditDialog = {}

-- シングルトン用定義
local _instance = nil
function QuestEditDialog.Instance() 
	if not _instance then
		_instance = QuestEditDialog
		--setmetatable(_instance, { __index = QuestEditDialog })
	end

	return _instance
end

-- メソッド定義
function QuestEditDialog:Initialize() 
	self.IsActive = false
	self.WaveCount = 0
	
	self.MaxWaveCount = 999

	LuaLoadPrefabAfter("questscene", "QuestEditDialog", "QuestEditDialog", "SystemCanvas")
	
	LuaFindObject("QuestEditWaveValueText")
	LuaFindObject("QuestEditWaveValueTenMinusButton")
	LuaFindObject("QuestEditWaveValueMinusButton")
	LuaFindObject("QuestEditWaveValuePlusButton")
	LuaFindObject("QuestEditWaveValueTenPlusButton")
	LuaFindObject("QuestEditPlayTimeText")
	LuaFindObject("QuestEditPlayTimeHUNorIJOU")
	
	LuaSetActive("QuestEditDialog", false)
end

function QuestEditDialog:SetParent(parentName) 
	LuaSetParent("QuestEditDialog", parentName)
end

function QuestEditDialog:OpenDialog()
	if self.IsActive == false then

		self.IsActive = true
	
		self.WaveCount = 1
		self:UpdateWaveText()
		self:UpdateButtonInteractable() 
		self:UpdateTimeText() 


		--LuaSetText("GachaRollOneTimePriceText", price)
		--LuaSetText("GachaRollHavePointText", math.floor(havePoint))

		CallbackManager.Instance():AddCallback("QuestEditDialogManager_OpenCallback", {self}, self.DialogOpenCallback)
		LuaPlayAnimator("QuestEditDialog", "Open", false, false, "LuaCallback", "QuestEditDialogManager_OpenCallback")
	end
end

function QuestEditDialog:CloseDialog() 
	if self.IsActive == true then
		CallbackManager.Instance():AddCallback("QuestEditDialogManager_CloseCallback", {self}, self.DialogCloseCallback)
		LuaPlayAnimator("QuestEditDialog", "Close", false, true, "LuaCallback", "QuestEditDialogManager_CloseCallback")
	end
end

function QuestEditDialog.DialogOpenCallback(arg, unityArg) 
end

function QuestEditDialog.DialogCloseCallback(arg, unityArg) 
	local self =  arg[1]
	self.IsActive = false
	LuaSetActive("QuestEditDialog", false)
end

function QuestEditDialog:OnClickButton(buttonName) 
	if self.IsActive == false then
		LuaUnityDebugLog("active false")
		return
	end

	if buttonName == "QuestEditOkButton" then
	end

	if buttonName == "QuestEditCancelButton" then
		self:CloseDialog()
	end
	
	if buttonName == "QuestEditWaveValueTenMinusButton" then
		self.WaveCount = self.WaveCount - 10
		if self.WaveCount < 1 then
			self.WaveCount = 1
		end
		self:UpdateWaveText()
		self:UpdateButtonInteractable() 
		self:UpdateTimeText() 
	end
	if buttonName == "QuestEditWaveValueMinusButton" then
		self.WaveCount = self.WaveCount - 1
		if self.WaveCount < 1 then
			self.WaveCount = 1
		end
		self:UpdateWaveText()
		self:UpdateButtonInteractable() 
		self:UpdateTimeText() 
	end
	if buttonName == "QuestEditWaveValuePlusButton" then
		--local max = math.floor(self.HavePoint / self.Price)
		local max = self.MaxWaveCount
		self.WaveCount = self.WaveCount + 1
		if self.WaveCount > max then
			self.WaveCount = max
		end
		self:UpdateWaveText()
		self:UpdateButtonInteractable() 
		self:UpdateTimeText() 
	end
	if buttonName == "QuestEditWaveValueTenPlusButton" then
		--local max = math.floor(self.HavePoint / self.Price)
		local max = self.MaxWaveCount
		self.WaveCount = self.WaveCount + 10
		if self.WaveCount > max then
			self.WaveCount = max
		end
		self:UpdateWaveText()
		self:UpdateButtonInteractable() 
		self:UpdateTimeText() 
	end
end

function QuestEditDialog:UpdateWaveText() 
	LuaSetText("QuestEditWaveValueText", self.WaveCount)
end

function QuestEditDialog:UpdateButtonInteractable() 
	if self.WaveCount <= 1 then
		LuaSetButtonInteractable("QuestEditWaveValueTenMinusButton", false)
		LuaSetButtonInteractable("QuestEditWaveValueMinusButton", false)
	else
		LuaSetButtonInteractable("QuestEditWaveValueTenMinusButton", true)
		LuaSetButtonInteractable("QuestEditWaveValueMinusButton", true)
	end
		
	if self.WaveCount >= self.MaxWaveCount then
		LuaSetButtonInteractable("QuestEditWaveValuePlusButton", false)
		LuaSetButtonInteractable("QuestEditWaveValueTenPlusButton", false)
	else
		LuaSetButtonInteractable("QuestEditWaveValuePlusButton", true)
		LuaSetButtonInteractable("QuestEditWaveValueTenPlusButton", true)
	end
end

function QuestEditDialog:UpdateTimeText() 
	if self.WaveCount <= 120 then
		local minute = self.WaveCount*15/60
		if minute < 0 then
			minute = 1
		end
		LuaSetText("QuestEditPlayTimeText", minute)
		LuaSetText("QuestEditPlayTimeHUNorIJOU", "分")
	else
		LuaSetText("QuestEditPlayTimeText", "30")
		LuaSetText("QuestEditPlayTimeHUNorIJOU", "分以上")
	end
end

