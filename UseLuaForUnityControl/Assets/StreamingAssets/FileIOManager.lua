﻿--直接Unityには登録しないスクリプト。いわゆる、ライブラリ化した奴

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
	self.OneTimeLoadFileName = PersistentDataPath.."/aaa.lua"
	self.EndCallback = nil
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
	saveString = saveString.."SaveObject = {\r\n"

	saveString = saveString.."CustomScene_SelectIndex = "..SaveObject.CustomScene_SelectIndex..",\r\n"
	saveString = saveString.."OptionScene_SEVolumeRate = "..SaveObject.OptionScene_SEVolumeRate..",\r\n"
	saveString = saveString.."OptionScene_BGMVolumeRate = "..SaveObject.OptionScene_BGMVolumeRate..",\r\n"
	
	saveString = saveString.."}\r\n"
	
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
	LuaUnityDebugLog("CreateDefaultSaveObject")
	--一応グローバル扱いになる
	SaveObject = {
		CustomScene_SelectIndex = 1,
		OptionScene_SEVolumeRate = 100,
		OptionScene_BGMVolumeRate = 100,
	}
end

-- ロード
function FileIOManager:Load(endCallback) 
	LuaUnityDebugLog("StartLoad")
	local f = io.open(self.FileName, "r")
	if f == nil then
		self:CreateDefaultSaveObject()
		endCallback()	
	else
		--dofile(self.FileName)
		self.EndCallback = endCallback
		CallbackManager.Instance():AddCallback("FileIOManager_LoadCallback", {self}, self.LoadCallback)
		LuaUnityLoadSaveFile(self.FileName, self.OneTimeLoadFileName, "LuaCallback", "FileIOManager_LoadCallback")
	end
end

-- ロード
function FileIOManager.LoadCallback(argList, unityArg)
	self = argList[1]
	TimerCallbackManager:AddCallback({self}, self.LoadTimerCallback, 3) 
end

function FileIOManager.LoadTimerCallback(argList)
	self = argList[1]
	dofile(self.OneTimeLoadFileName)
	CallbackManager.Instance():AddCallback("FileIOManager_DeleteCallback", {self}, self.EndCallback)
	LuaUnityDeleteFile(self.OneTimeLoadFileName, "LuaCallback", "FileIOManager_DeleteCallback")
end

