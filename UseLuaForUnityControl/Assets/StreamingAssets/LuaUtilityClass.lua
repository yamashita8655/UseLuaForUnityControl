--直接Unityには登録しないスクリプト。いわゆる、ライブラリ化した奴

-- クラス定義
-- 2点を表すオブジェクト
Vector2 = {}

-- コンストラクタ
function Vector2.new(x, y)
	local this = {
		x = x, 
		y = y
	}

	-- メソッド定義
	--this.Function = function()
	--end

	return this
end

-- 3点を表すオブジェクト
Vector3 = {}

-- コンストラクタ
function Vector3.new(x, y, z)
	local this = {
		x = x, 
		y = y,
		z = z
	}

	-- メソッド定義
	--this.Function = function()
	--end
	
	return this
end

-- クラス定義
UtilityFunction = {}

-- シングルトン用定義
local _instance = nil
function UtilityFunction.Instance() 
	if not _instance then
		_instance = UtilityFunction
		--_instance:Initialize()
		--setmetatable(_instance, { __index = EnemyManager })
	end

	return _instance
end

-- メソッド定義
function UtilityFunction:Initialize() 
end

-- エミッタ―設定
function UtilityFunction.SetEmitter(character, bulletEmitterList, equipBulletList, characterType) 
	for i = 1, #bulletEmitterList do
		emitter = nil
		if bulletEmitterList[i]:EmitterType() == EmitterTypeEnum.Normal then
			emitter = BulletEmitter.new()
			--emitter:Initialize(bulletEmitterList[i]:Position(), bulletEmitterList[i]:ShootInterval(), equipBulletList[i], character:GetPosition(), characterType)
			emitter:Initialize(bulletEmitterList[i]:Position(), bulletEmitterList[i]:ShootInterval(), bulletEmitterList[i]:RotateOffset(), equipBulletList[1], character:GetPosition(), characterType)
		elseif bulletEmitterList[i]:EmitterType() == EmitterTypeEnum.Satellite then
			emitter = BulletEmitterSatellite.new()
			--emitter:Initialize(bulletEmitterList[i]:Position(), bulletEmitterList[i]:ShootInterval(), equipBulletList[i], character:GetPosition(), characterType, Vector2.new(0, 0))
			emitter:Initialize(bulletEmitterList[i]:Position(), bulletEmitterList[i]:ShootInterval(), bulletEmitterList[i]:RotateOffset(), equipBulletList[1], character:GetPosition(), characterType, Vector2.new(0, 0))
		end
		character:AddBulletEmitter(emitter)
	end

	return character
end

