--直接Unityには登録しないスクリプト。いわゆる、ライブラリ化した奴

--FIleIOって書いてあるけど、実質セーブデータ単体の為の機能
--今度リネームしないとね…

CharacterParameterEnum = {
	AddHp = 1,
	AddAttack = 2,
	AddDeffense = 3,
	FriendPoint = 4,
	RemainParameterPoint = 5,
}

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
	saveString = saveString.."CustomScene_CharacterUnlockList = {"
	for i = 1, #SaveObject.CustomScene_CharacterUnlockList do
		if i ~= 1 then
			saveString = saveString..","
		end
		saveString = saveString..SaveObject.CustomScene_CharacterUnlockList[i]
	end
	saveString = saveString.."},\r\n"

	saveString = saveString.."CustomScene_HaveKarikariValue = "..SaveObject.CustomScene_HaveKarikariValue..",\r\n"
	
	saveString = saveString.."HaveMochiPointValue = "..SaveObject.HaveMochiPointValue..",\r\n"
	
	saveString = saveString.."CharacterList = {\r\n"
	for i = 1, #SaveObject.CharacterList do
		saveString = saveString.."{"
		local character = SaveObject.CharacterList[i]
		for j = 1, #character do
			if j ~= 1 then
				saveString = saveString..","
			end
			saveString = saveString..character[j]
		end
		saveString = saveString.."},\r\n"
	end
	saveString = saveString.."},\r\n"

	saveString = saveString.."HaveMochiPointValue = "..SaveObject.HaveMochiPointValue..",\r\n"
	
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
		CustomScene_CharacterUnlockList = {1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		CustomScene_HaveKarikariValue = 0,
		HaveMochiPointValue = 0,
		CharacterList = {
			{0,0,0,0,100,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
			{0,0,0,0,100,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
			{0,0,0,0,100,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
			{0,0,0,0,100,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
			{0,0,0,0,100,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
			{0,0,0,0,100,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
			{0,0,0,0,100,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
			{0,0,0,0,100,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
			{0,0,0,0,100,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
			{0,0,0,0,100,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
			{0,0,0,0,100,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
			{0,0,0,0,100,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
			{0,0,0,0,100,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
			{0,0,0,0,100,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
			{0,0,0,0,100,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
			{0,0,0,0,100,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
			{0,0,0,0,100,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
			{0,0,0,0,100,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
			{0,0,0,0,100,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
			{0,0,0,0,100,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
			{0,0,0,0,100,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
			{0,0,0,0,100,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
			{0,0,0,0,100,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
			{0,0,0,0,100,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
			{0,0,0,0,100,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
			{0,0,0,0,100,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
			{0,0,0,0,100,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
			{0,0,0,0,100,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
			{0,0,0,0,100,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
			{0,0,0,0,100,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		},
	}
end

-- ロード
function FileIOManager:Load(endCallback) 
	LuaUnityDebugLog("StartLoad")
	local f = io.open(self.FileName, "r")
	if f == nil then
		--self:CreateDefaultSaveObject()
		--endCallback()	
		self:CreateDefaultSaveObject()
		TimerCallbackManager:AddCallback({}, endCallback, 1) 
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
	TimerCallbackManager:AddCallback({self}, self.LoadTimerCallback, 1) 
end

function FileIOManager.LoadTimerCallback(argList)
	self = argList[1]
	dofile(self.OneTimeLoadFileName)
	self:CheckSaveFile()
	CallbackManager.Instance():AddCallback("FileIOManager_DeleteCallback", {self}, self.EndCallback)
	LuaUnityDeleteFile(self.OneTimeLoadFileName, "LuaCallback", "FileIOManager_DeleteCallback")
end

function FileIOManager:CheckSaveFile()
	if SaveObject.CustomScene_SelectIndex == nil then
		SaveObject.CustomScene_SelectIndex = 1
	end
	if SaveObject.OptionScene_SEVolumeRate == nil then
		SaveObject.OptionScene_SEVolumeRate = 100
	end
	if SaveObject.OptionScene_BGMVolumeRate == nil then
		SaveObject.OptionScene_BGMVolumeRate = 100
	end
	if SaveObject.CustomScene_CharacterUnlockList == nil then
		SaveObject.CustomScene_CharacterUnlockList = {1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
	end
	if SaveObject.CustomScene_HaveKarikariValue == nil then
		SaveObject.CustomScene_HaveKarikariValue = 0
	end
	if SaveObject.HaveMochiPointValue == nil then
		SaveObject.HaveMochiPointValue = 0
	end
	
	if SaveObject.CharacterList == nil then
		SaveObject.CharacterList = {
			{0,0,0,0,100,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
			{0,0,0,0,100,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
			{0,0,0,0,100,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
			{0,0,0,0,100,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
			{0,0,0,0,100,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
			{0,0,0,0,100,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
			{0,0,0,0,100,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
			{0,0,0,0,100,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
			{0,0,0,0,100,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
			{0,0,0,0,100,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
			{0,0,0,0,100,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
			{0,0,0,0,100,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
			{0,0,0,0,100,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
			{0,0,0,0,100,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
			{0,0,0,0,100,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
			{0,0,0,0,100,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
			{0,0,0,0,100,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
			{0,0,0,0,100,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
			{0,0,0,0,100,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
			{0,0,0,0,100,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
			{0,0,0,0,100,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
			{0,0,0,0,100,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
			{0,0,0,0,100,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
			{0,0,0,0,100,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
			{0,0,0,0,100,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
			{0,0,0,0,100,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
			{0,0,0,0,100,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
			{0,0,0,0,100,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
			{0,0,0,0,100,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
			{0,0,0,0,100,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		}
	end
end

