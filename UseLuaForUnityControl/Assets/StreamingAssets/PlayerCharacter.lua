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
	this.ShootPointList = {}
	this.ShootCooltime = 0.0
	this.ShootInterval = 0.25

	-- ���\�b�h��`
	-- �X�V
	this.BaseUpdate = this.Update
	this.Update = function(self, deltaTime)
		self.ShootCooltime = self.ShootCooltime + deltaTime
	end
	
	-- �e�����˂����|�C���g�̒ǉ�
	this.AddShootPoint = function(self, point)
		table.insert(self.ShootPointList, point)
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
	
	-- ���^�e�[�u���Z�b�g
	--return setmetatable(this, {__index = PlayerCharacter})
	return this
end

