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
	-- ������
	this.CharacterBaseInitialize = this.Initialize
	this.Initialize = function(self, nowHp, maxHp)
		this:CharacterBaseInitialize(nowHp, maxHp)
		LuaFindObject("PlayerHPGaugeBar")
		self:UpdateHpGauge()
	end
	
	-- HP�Q�[�W�̍X�V
	this.UpdateHpGauge = function(self)
		barRate = self.NowHp / self.MaxHp
		LuaSetScale("PlayerHPGaugeBar", 1.0, barRate, 1.0)
	end
	
	-- ����HP�̉����Z
	this.CharacterBaseAddNowHp = this.AddNowHp
	this.AddNowHp = function(self, addValue)
		self:CharacterBaseAddNowHp(addValue)
		self:UpdateHpGauge()
	end
	
	-- ����HP�̒��ڒl�w��
	this.CharacterBaseSetNowHp = this.SetNowHp
	this.SetNowHp = function(self, value)
		self:CharacterBaseSetNowHp(value)
		self:UpdateHpGauge()
	end
	
	-- �ő�HP�̉����Z
	this.CharacterBaseAddMaxHp = this.AddMaxHp
	this.AddMaxHp = function(self, addValue)
		self:CharacterBaseAddMaxHp(addValue)
		self:UpdateHpGauge()
	end
	
	-- �ő�HP�̒��ڒl�w��
	this.CharacterBaseSetMaxHp = this.SetMaxHp
	this.SetMaxHp = function(self, value)
		self:CharacterBaseSetMaxHp(value)
		self:UpdateHpGauge()
	end

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

