--直接Unityには登録しないスクリプト。いわゆる、ライブラリ化した奴

-- クラス定義
EffectManager = {}

-- シングルトン用定義
local _instance = nil
function EffectManager.Instance() 
	if not _instance then
		_instance = EffectManager
		--_instance:Initialize()
		--setmetatable(_instance, { __index = EffectManager })
	end

	return _instance
end

-- メソッド定義
function EffectManager:Initialize() 
	self.EffectCounter = 0
	self.EffectList = {}
	
	LuaFindObject("EffectRoot")
	LuaFindObject("HitEffect2")
end

function EffectManager:SpawnEffect(position) 
	LuaLoadPrefabAfter("Prefabs/System/HitEffect2", "HitEffect2_"..self.EffectCounter, "EffectRoot")
	table.insert(self.EffectList, "HitEffect2_"..self.EffectCounter)
	LuaSetPosition("HitEffect2_"..self.EffectCounter, position.x, position.y, position.z)
	callbackTag = "EffectManager_CallbackEffectAnimationEnd"..self.EffectCounter
	CallbackManager.Instance():AddCallback(callbackTag, {self, "HitEffect2_"..self.EffectCounter}, self.EffectAnimationEnd)
	LuaPlayAnimator("HitEffect2_"..self.EffectCounter, "Play", false, false, "LuaCallback", callbackTag)
	self.EffectCounter = self.EffectCounter + 1

end

function EffectManager:PauseEffect() 
	for i = 1, #self.EffectList do
		LuaPauseAnimator(self.EffectList[i])
	end
end

function EffectManager:ResumeEffect() 
	for i = 1, #self.EffectList do
		LuaResumeAnimator(self.EffectList[i])
	end
end

function EffectManager.EffectAnimationEnd(argList) 
	local self = argList[1]
	local prefabName = argList[2]
	for i = 1, #self.EffectList do
		if self.EffectList[i] == prefabName then
			table.remove(self.EffectList, i)
		end
	end
	LuaDestroyObject(prefabName)
end

function EffectManager:Release() 
	for i = 1, #self.EffectList do
		LuaDestroyObject(self.EffectList[i])
	end

	self.EffectList = {}
end
