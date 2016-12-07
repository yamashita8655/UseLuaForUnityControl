--����Unity�ɂ͓o�^���Ȃ��X�N���v�g�B������A���C�u�����������z
EmitterTypeEnum = {
	Normal = 0,
	Satellite = 1,
}

-- �e�̔��ˑ�̐ݒ�
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


