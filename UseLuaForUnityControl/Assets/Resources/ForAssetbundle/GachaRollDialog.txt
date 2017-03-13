--直接Unityには登録しないスクリプト。いわゆる、ライブラリ化した奴

-- クラス定義
GachaRollDialog = {}

-- シングルトン用定義
local _instance = nil
function GachaRollDialog.Instance() 
	if not _instance then
		_instance = GachaRollDialog
		--setmetatable(_instance, { __index = GachaRollDialog })
	end

	return _instance
end

-- メソッド定義
function GachaRollDialog:Initialize() 
	self.IsActive = false
	self.RollCallback = nil 
	self.RollCount = 0
	self.HavePoint = 0
	self.Price = 0

	LuaLoadPrefabAfter("gachascene", "GachaRollDialog", "GachaRollDialog", "SystemCanvas")
	
	LuaFindObject("GachaRollOneTimePriceText")
	LuaFindObject("GachaRollHavePointText")
	LuaFindObject("GachaRollUsePointText")
	LuaFindObject("GachaRollRollValueText")
	LuaFindObject("GachaRollRollValueMinButton")
	LuaFindObject("GachaRollRollValueMinusButton")
	LuaFindObject("GachaRollRollValuePlusButton")
	LuaFindObject("GachaRollRollValueMaxButton")
	LuaFindObject("GachaRollButton")

	LuaSetActive("GachaRollDialog", false)
end

function GachaRollDialog:SetParent(parentName) 
	LuaSetParent("GachaRollDialog", parentName)
end

function GachaRollDialog:OpenDialog(rollCallback, price, havePoint)
	if self.IsActive == false then

		self.RollCallback = rollCallback 
		self.IsActive = true
	
		self.RollCount = 0
		self.HavePoint = havePoint
		self.Price = price
		self:UpdatePriceText()
		self:UpdateButtonInteractable() 

		LuaSetText("GachaRollOneTimePriceText", price)
		LuaSetText("GachaRollHavePointText", havePoint)

		CallbackManager.Instance():AddCallback("GachaRollDialogManager_OpenCallback", {self}, self.DialogOpenCallback)
		LuaPlayAnimator("GachaRollDialog", "Open", false, false, "LuaCallback", "GachaRollDialogManager_OpenCallback")
	end
end

function GachaRollDialog:CloseDialog() 
	if self.IsActive == true then
		CallbackManager.Instance():AddCallback("GachaRollDialogManager_CloseCallback", {self}, self.DialogCloseCallback)
		LuaPlayAnimator("GachaRollDialog", "Close", false, true, "LuaCallback", "GachaRollDialogManager_CloseCallback")
	end
end

function GachaRollDialog.DialogOpenCallback(arg, unityArg) 
end

function GachaRollDialog.DialogCloseCallback(arg, unityArg) 
	local self =  arg[1]
	self.IsActive = false
	LuaSetActive("GachaRollDialog", false)
end

function GachaRollDialog:OnClickButton(buttonName) 
	if self.IsActive == false then
		return
	end
	
	if buttonName == "GachaRollButton" then
		local price = self.Price * self.RollCount
		local count = self.RollCount
		DialogManager.Instance():OpenDialog(
			price.."ポイントで"..count.."回引きますが\nよろしいですか？",
			function()
			end ,
			function()
			end,
			function()
				self.RollCallback(count)
				self.DialogCloseCallback({self})
			end,
			function()
			end
		)
	end
	if buttonName == "GachaRollCancelButton" then
		self:CloseDialog()
	end
	
	if buttonName == "GachaRollRollValueMinButton" then
		self.RollCount = 0
		self:UpdatePriceText()
		self:UpdateButtonInteractable() 
	end
	if buttonName == "GachaRollRollValueMinusButton" then
		self.RollCount = self.RollCount - 1
		if self.RollCount < 0 then
			self.RollCount = 0
		end
		self:UpdatePriceText()
		self:UpdateButtonInteractable() 
	end
	if buttonName == "GachaRollRollValuePlusButton" then
		local max = math.floor(self.HavePoint / self.Price)
		self.RollCount = self.RollCount + 1
		if self.RollCount > max then
			self.RollCount = max
		end
		self:UpdatePriceText()
		self:UpdateButtonInteractable() 
	end
	if buttonName == "GachaRollRollValueMaxButton" then
		local max = math.floor(self.HavePoint / self.Price)
		self.RollCount = max
		self:UpdatePriceText()
		self:UpdateButtonInteractable() 
	end
end

function GachaRollDialog:UpdatePriceText() 
	LuaSetText("GachaRollUsePointText", self.Price * self.RollCount)
	LuaSetText("GachaRollRollValueText", self.RollCount)
end

function GachaRollDialog:UpdateButtonInteractable() 
	if self.RollCount <= 0 then
		LuaSetButtonInteractable("GachaRollRollValueMinButton", false)
		LuaSetButtonInteractable("GachaRollRollValueMinusButton", false)
		LuaSetButtonInteractable("GachaRollButton", false)
	else
		LuaSetButtonInteractable("GachaRollRollValueMinButton", true)
		LuaSetButtonInteractable("GachaRollRollValueMinusButton", true)
		LuaSetButtonInteractable("GachaRollButton", true)
	end
		
	local max = math.floor(self.HavePoint / self.Price)
	if self.RollCount >= max then
		LuaSetButtonInteractable("GachaRollRollValuePlusButton", false)
		LuaSetButtonInteractable("GachaRollRollValueMaxButton", false)
	else
		LuaSetButtonInteractable("GachaRollRollValuePlusButton", true)
		LuaSetButtonInteractable("GachaRollRollValueMaxButton", true)
	end
end

