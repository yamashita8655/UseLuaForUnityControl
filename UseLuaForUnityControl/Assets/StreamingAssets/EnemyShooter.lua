--����Unity�ɂ͓o�^���Ȃ��X�N���v�g�B������A���C�u�����������z

-- �N���X��`
-- �e��łG���I�N���X
EnemyShooter = {}

-- ���\�b�h��`

-- �R���X�g���N�^
function EnemyShooter.new(posx, posy, posz, rotx, roty, rotz, name, number, width, height)
	local this = EnemyBase.new(posx, posy, posz, rotx, roty, rotz, name, number, width, height)
	
	-- �����o�ϐ�
	this.BulletEmitterList = {}

	-- ���\�b�h��`
	-- ������
	this.EnemyBaseInitialize = this.Initialize
	this.Initialize = function(self, nowHp, maxHp, attack)
		this:EnemyBaseInitialize(nowHp, maxHp, attack)
	end
	
	-- �X�V
	this.EnemyBaseUpdate = this.Update
	this.Update = function(self, deltaTime)
		this.EnemyBaseUpdate(deltaTime)
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

	return this
end

