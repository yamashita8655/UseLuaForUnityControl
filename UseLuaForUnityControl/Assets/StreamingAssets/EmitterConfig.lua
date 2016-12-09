--直接Unityには登録しないスクリプト。いわゆる、ライブラリ化した奴
EmitterTypeEnum = {
	Normal = 0,
	Satellite = 1,
}

-- 弾の発射台の設定
Emitter001 = {}

function Emitter001.new(shootInterval, position, emitterType)
	local this = {
		LocalShootInterval = shootInterval,
		LocalPosition = position,
		LocalEmitterType = emitterType,
	}

	this.ShootInterval = function(self)
		return self.LocalShootInterval
	end
	
	this.Position = function(self)
		return self.LocalPosition
	end
	
	this.EmitterType = function(self)
		return self.LocalEmitterType
	end

	return this
end


