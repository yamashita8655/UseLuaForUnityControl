--����Unity�ɂ͓o�^���Ȃ��X�N���v�g�B������A���C�u�����������z

-- �N���X��`
-- �L������{�N���X
CharacterBase = {}

-- ���\�b�h��`

-- �R���X�g���N�^
function CharacterBase.new(position, rotate, name, number, width, height)
	local this = ObjectBase.new(position, rotate, name, number, width, height)
	
	-- �����o�ϐ�
	this.ExistCounter = 0.0
	this.ExistTime = 0.0
	this.MoveSpeed = 0.0
	this.NowHp = 0.0
	this.MaxHp = 0.0

	-- ���\�b�h��`
	-- ������
	this.ObjectBaseInitialize = this.Initialize
	this.Initialize = function(self, nowHp, maxHp)
		this:ObjectBaseInitialize()
		self.NowHp = nowHp
		self.MaxHp = maxHp
	end
	-- �T���v��
	--this.Function = function(self)
	--end

	-- ���^�e�[�u���Z�b�g
	--return setmetatable(this, {__index = CharacterBase})
	return this
end

