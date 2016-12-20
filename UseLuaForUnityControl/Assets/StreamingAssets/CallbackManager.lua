--直接Unityには登録しないスクリプト。いわゆる、ライブラリ化した奴

-- クラス定義
CallbackManager = {}

-- シングルトン用定義
local _instance = nil
function CallbackManager.Instance() 
	if not _instance then
		_instance = CallbackManager
		--_instance:Initialize()
		--setmetatable(_instance, { __index = CallbackManager })
	end

	return _instance
end

-- メソッド定義
function CallbackManager:Initialize() 
	self.CallbackTable = {}
end

function CallbackManager:AddCallback(name, arg, callback) 
	callbackData = CallbackData.new(name, arg, callback)
	table.insert(self.CallbackTable, callbackData)
end

function CallbackManager:ExecuteCallback(functionName, unityArg) 
	for i = 1, #self.CallbackTable do
		callbackData = self.CallbackTable[i]
		if callbackData.FunctionName == functionName then
			callbackData.FunctionObject(callbackData.FunctionArg, unityArg)
			table.remove(self.CallbackTable, i)
			break;
		end
	end
end

-- クラス定義
-- コールバックオブジェクト
CallbackData = {}

-- メソッド定義

-- コンストラクタ
function CallbackData.new(functionName, functionArg, functionObject)
	local this = {
		FunctionName = functionName,
		FunctionArg = functionArg,
		FunctionObject = functionObject,
	}
	
	return this
end

