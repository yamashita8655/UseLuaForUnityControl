--����Unity�ɂ͓o�^���Ȃ��X�N���v�g�B������A���C�u�����������z

-- �N���X��`
EmitterBase = {}

-- �R���X�g���N�^
function EmitterBase.new()
	local this = {
		Position = Vector2.new(0, 0),
		ShootCooltime = 0.0,
		ShootInterval = 0.25,
	}
	
	-- ���\�b�h��`
	-- ������
	this.Initialize = function(self, position, interval)
		self.Position = position
		self.ShootInterval = interval
	end
	
	-- �X�V
	this.Update = function(self, deltaTime)
		self.ShootCooltime = self.ShootCooltime + deltaTime
	end
	
	-- �e�̔���
	this.ShootBullet = function(self, degree)
		local canShoot = self:CanShootBullet()
		if canShoot then
			--BulletManager.Instance():CreateSpeedBullet(self.Position.x, self.Position.y, degree, CharacterType.Player);
			BulletManager.Instance():CreateNormalBullet(self.Position.x, self.Position.y, degree, CharacterType.Player);
			self:ResetBulletCooltime()
		end
	end
	
	-- �e�̃N�[���^�C�����I����Ă��邩�ǂ���
	this.CanShootBullet = function(self)
		local canShoot = false
		if self.ShootCooltime > self.ShootInterval then
			canShoot = true
		end
		return canShoot
	end
	
	-- �e�̃N�[���^�C�����Z�b�g
	this.ResetBulletCooltime = function(self)
		self.ShootCooltime = 0.0
	end

	return this
end

-- �N���X��`
-- �e�𔭎˂���I�u�W�F�N�g�B�T�O�I�ɂ̓I�v�V�����݂����ȕ�
BulletEmitter = {}

-- �R���X�g���N�^
function BulletEmitter.new()
	local this = EmitterBase.new()
	return this
end

-- �N���X��`
-- �e�𔭎˂���I�u�W�F�N�g�B�w��̈ʒu����A�w��̈ʒu�𒆐S�Ƃ��ĉq���I�ȓ���������
BulletEmitterSatellite = {}

-- �R���X�g���N�^
function BulletEmitterSatellite.new()
	local this = EmitterBase.new()
	this.SpawnPosition = Vector2.new(0, 0)
	this.CenterPosition = Vector2.new(0, 0)
	
	-- ���\�b�h��`
	-- ������
	this.BaseInitialize = this.Initialize
	this.Initialize = function(self, position, interval, centerPosition)
		this.BaseInitialize(self, position, interval)
		-- �V���ɍ쐬���Ȃ��ƁA�Q�ƂȂ̂ŁAPosition������������ƁASpawnPosition�̒l���ς���Ă��܂�
		self.SpawnPosition = Vector2.new(position.x, position.y)
		self.CenterPosition = centerPosition
	end
	
	-- �X�V
	this.BaseUpdate = this.Update
	this.Update = function(self, deltaTime)
		self.BaseUpdate(this, deltaTime)
	end
	
	-- �^�b�`�A�h���b�O�����������A���̌����ɂ��̃I�u�W�F�N�g���g���Ǐ]������
	this.UpdatePosition = function(self, radian, degree)
		-- ��{�̍��W�́A�I�t�Z�b�g�ʂƂ��Ďg��
		-- �܂��A���̍��W�ʒu�́A��{��]�l�����߂鎖�ɂ��g��
		local spawnx = self.SpawnPosition.x
		local spawny = self.SpawnPosition.y
		local baseRadian = math.atan2(spawny, spawnx)
		local basedegree = baseRadian * 180 / 3.1415
		
		-- �I�t�Z�b�g���������߂�
		local xvalue = (self.SpawnPosition.x - self.CenterPosition.x)
		local yvalue = (self.SpawnPosition.y - self.CenterPosition.y)
		local offsetRange = math.sqrt((xvalue*xvalue) + (yvalue*yvalue))
		
		-- -90�x�␳�̓��������W�A�����~�����̂ŁA�v�Z����
		local rawradian = (degree) / 180 * 3.1415
		local addx = math.cos(rawradian+baseRadian)
		local addy = math.sin(rawradian+baseRadian)
		self.Position.x = addx*offsetRange
		self.Position.y = addy*offsetRange
	end
	return this
end

