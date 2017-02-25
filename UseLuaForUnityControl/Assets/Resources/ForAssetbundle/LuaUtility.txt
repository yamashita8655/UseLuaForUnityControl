--直接Unityには登録しないスクリプト。いわゆる、ライブラリ化した奴

-- クラス定義
TestClassObject = {}

-- メソッド定義
function TestClassObject.GetName(self) 
	return self.name
end

-- コンストラクタ
function TestClassObject.new(name)
	local obj = {
		name = name
	}
  -- メタテーブルセット
  return setmetatable(obj, {__index = TestClassObject})
end

function ReturnIntValue()
	return 1
end

function ReturnStringValue()
	return "String"
end

function TestClassDebugLog()
	LuaUnityDebugLog("LuaUnityDebugLog:TestTest")
end


