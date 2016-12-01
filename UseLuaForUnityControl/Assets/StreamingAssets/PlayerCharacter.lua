--����Unity�ɂ͓o�^���Ȃ��X�N���v�g�B������A���C�u�����������z

-- �N���X��`
-- �v���C���[�N���X
PlayerCharacter = {}

-- ���\�b�h��`

-- �R���X�g���N�^
function PlayerCharacter.new(posx, posy, posz, rotx, roty, rotz, name, width, height)
	local this = CharacterBase.new(posx, posy, posz, rotx, roty, rotz, name, 0, width, height)
	
	-- �����o�ϐ�
	this.ExistCounter = 0.0
	this.ExistTime = 0.0
	this.MoveSpeed = 1.0
	this.BulletEmitterList = {}

	-- ���\�b�h��`
	-- �X�V
	this.BaseUpdate = this.Update
	this.Update = function(self, deltaTime)
		for i = 1, #self.BulletEmitterList do
			emitter = self.BulletEmitterList[i]
			emitter:Update(deltaTime)
		end
	end
	
	-- �e�����˂����|�C���g�̒ǉ�
	this.AddBulletEmitter = function(self, emitter)
		table.insert(self.BulletEmitterList, emitter)
	end
	
	-- �e�̃N�[���^�C�����I����Ă��邩�ǂ���
	this.ShootBullet = function(self, degree)
		for i = 1, #self.BulletEmitterList do
			emitter = self.BulletEmitterList[i]
			emitter:ShootBullet(degree)
		end
	end
	
	-- BulletEmitterSatellite
	this.UpdateSatelliteEmitterPosition = function(self, radian, degree)
		for i = 1, #self.BulletEmitterList do
			emitter = self.BulletEmitterList[i]
			emitter:UpdatePosition(radian, degree)
		end
	end
	
	-- ���^�e�[�u���Z�b�g
	--return setmetatable(this, {__index = PlayerCharacter})
	return this
end

