--直接Unityには登録しないスクリプト。いわゆる、ライブラリ化した奴

--FIleIOって書いてあるけど、実質セーブデータ単体の為の機能
--今度リネームしないとね…

-- クラス定義
FileIOManager = {}

-- シングルトン用定義
local _instance = nil
function FileIOManager.Instance() 
	if not _instance then
		_instance = FileIOManager
		--setmetatable(_instance, { __index = FileIOManager })
	end

	return _instance
end

-- メソッド定義
--function FileIOManager.Initialize(self)と同じ 
function FileIOManager:Initialize() 
	self.FileName = PersistentDataPath.."/SaveData.lua"
end

-- デバッグ機能：セーブファイルを削除する
function FileIOManager:DebugDeleteSaveFile()
	res, mes = os.remove(self.FileName)
	LuaUnityDebugLog(res)
	LuaUnityDebugLog(mes)
end

-- セーブ
function FileIOManager:Save()
	local saveString = ""
	saveString = saveString.."SaveObject = {\n"
	saveString = saveString.."SelectCharacterIndex = 1,\n"
	saveString = saveString.."}\n"
	
	CallbackManager.Instance():AddCallback("FileIOManager_SaveCallback", {self}, self.SaveCallback)
	LuaUnitySaveFile(self.FileName, saveString, "LuaCallback", "FileIOManager_SaveCallback")
end

-- セーブコールバック
function FileIOManager.SaveCallback(argList, unityArg) 
	local self = argList[1]
	local unityText = unityArg
end

-- プログラム中でアクセスするので、デフォルトデータは用意する
function FileIOManager:CreateDefaultSaveObject() 
	--一応グローバル扱いになる
	SaveObject = {
		SelectCharacterIndex = 10101,
	}
end

-- ロード
function FileIOManager:Load() 
	local f = io.open(self.FileName, "r")
	if f == nil then
		self:CreateDefaultSaveObject()
	else
		dofile(self.FileName)
	end
	
	if SaveObject == nil then
		LuaUnityDebugLog("nonilnilnil")
	end
end

