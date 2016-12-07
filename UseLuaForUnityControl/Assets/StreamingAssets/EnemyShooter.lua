--����Unity�ɂ͓o�^���Ȃ��X�N���v�g�B������A���C�u�����������z

-- �N���X��`
-- �e��łG���I�N���X
EnemyShooter = {}

-- ���\�b�h��`

-- �R���X�g���N�^
function EnemyShooter.new(position, rotate, name, number, width, height)
	local this = EnemyBase.new(position, rotate, name, number, width, height)
	
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
		this:EnemyBaseUpdate(deltaTime)

		local targetPosition = Vector2.new(0, 0)-- �v���C���[�L�����̈ʒu
		local offsetx = targetPosition.x - self.Position.x
		local offsety = targetPosition.y - self.Position.y
		local radian = math.atan2(offsety, offsetx)
		local degree = radian * 180 / 3.1415
		self:ShootBullet(degree-90)
		
		for i = 1, #self.BulletEmitterList do
			emitter = self.BulletEmitterList[i]
			emitter:Update(deltaTime)
		end
	end
	
	-- �e�����˂����|�C���g�̒ǉ�
	this.AddBulletEmitter = function(self, emitter)
		table.insert(self.BulletEmitterList, emitter)
	end
	
	-- �e����
	this.ShootBullet = function(self, degree)
		for i = 1, #self.BulletEmitterList do
			emitter = self.BulletEmitterList[i]
			emitter:ShootBullet(degree)
		end
	end

	return this
end

