--直接Unityには登録しないスクリプト。いわゆる、ライブラリ化した奴

-- クラス定義
TimerCallbackManager = {}

-- シングルトン用定義
local _instance = nil
function TimerCallbackManager.Instance() 
	if not _instance then
		_instance = TimerCallbackManager
		--_instance:Initialize()
		--setmetatable(_instance, { __index = TimerCallbackManager })
	end

	return _instance
end

-- メソッド定義
function TimerCallbackManager:Initialize() 
	self.CallbackTable = {}
end

function TimerCallbackManager:AddCallback(functionArg, functionObject, executeTimer) 
	callbackData = TimerCallbackData.new(functionArg, functionObject, executeTimer)
	table.insert(self.CallbackTable, callbackData)
end

function TimerCallbackManager:Update(deltaTime)
	for i = 1, #self.CallbackTable do
		callbackData = self.CallbackTable[i]
		if callbackData.CountTimer > callbackData.ExecuteTimer then
			callbackData.FunctionObject(callbackData.FunctionArg)
			callbackData.IsDelete = true
		else
			callbackData.CountTimer = callbackData.CountTimer + deltaTime
		end
	end

	local index = 1
	while true do
		if index <= #self.CallbackTable then
			local obj = self.CallbackTable[index]
			if callbackData.IsDelete == true then
				table.remove(self.CallbackTable, index)
			else
				index = index + 1
			end
		else
			break
		end
	end
end

-- クラス定義
-- コールバックオブジェクト
TimerCallbackData = {}

-- メソッド定義

-- コンストラクタ
function TimerCallbackData.new(functionArg, functionObject, executeTimer)
	local this = {
		FunctionArg = functionArg,
		FunctionObject = functionObject,
		ExecuteTimer = executeTimer,
		CountTimer = 0,
		IsDelete = false,
	}
	
	return this
end

