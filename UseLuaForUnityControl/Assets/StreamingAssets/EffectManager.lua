--����Unity�ɂ͓o�^���Ȃ��X�N���v�g�B������A���C�u�����������z

-- �N���X��`
EffectManager = {}

-- �V���O���g���p��`
local _instance = nil
function EffectManager.Instance() 
	if not _instance then
		_instance = EffectManager
		_instance:Initialize()
		--setmetatable(_instance, { __index = EffectManager })
	end

	return _instance
end

-- ���\�b�h��`
function EffectManager:Initialize() 
	self.EffectCounter = 0
	
	LuaFindObject("EffectRoot")
	LuaFindObject("HitEffect1")
end

function EffectManager:SpawnEffect(position) 
	LuaLoadPrefabAfter("Prefabs/System/HitEffect1", "HitEffect1_"..self.EffectCounter, "EffectRoot")
	LuaSetPosition("HitEffect1_"..self.EffectCounter, position.x, position.y, position.z)
	LuaPlayAnimator("HitEffect1_"..self.EffectCounter, "Play", false, false, "EffectAnimationEnd", "HitEffect1_"..self.EffectCounter)
	self.EffectCounter = self.EffectCounter + 1

end

function EffectManager:EffectAnimationEnd(arg) 
	LuaDestroyObject(arg)
end
