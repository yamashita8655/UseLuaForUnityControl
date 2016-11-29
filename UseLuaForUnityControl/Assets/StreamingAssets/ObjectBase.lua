--����Unity�ɂ͓o�^���Ȃ��X�N���v�g�B������A���C�u�����������z

-- �N���X��`
ObjectBase = {}

-- �R���X�g���N�^
function ObjectBase.new(posx, posy, posz, rotx, roty, rotz, name, number, width, height)
	local this = {
		PositionX = posx, 
		PositionY = posy,
		PositionZ = posz,
		RotateX = rotx, 
		RotateY = roty,
		RotateZ = rotz,
		Name = name,
		Number = number,
		Width = width,
		Height = height,
		DeadFlag = false,
	}

	-- ���\�b�h��`
	-- ���W�擾
	this.GetPosition = function(self)
		return self.PositionX, self.PositionY, self.PositionZ
	end
	-- ���W�ݒ�
	this.SetPosition = function(self, positionx, positiony, positionz)
		self.PositionX = positionx
		self.PositionY = positiony
		self.PositionZ = positionz
	end

	-- �T�C�Y�擾
	this.GetSize = function(self) 
		return self.Width, self.Height
	end
	-- �T�C�Y�ݒ�
	this.SetSize = function(self, width, height) 
		self.Width = width
		self.Height = height
	end

	-- ��]���擾
	this.GetRotate = function(self) 
		return self.RotateX, self.RotateY, self.RotateZ
	end
	-- ��]���ݒ�
	this.SetRotate = function(self, rotatex, rotatey, rotatez) 
		self.RotateX = rotatex
		self.RotateY = rotatey
		self.RotateZ = rotatez
	end

	-- ���O�擾
	this.GetName = function(self) 
		return self.Name
	end
	-- ���O�ݒ�
	this.SetName = function(self, name) 
		self.Name = name
	end
	
	-- �������
	this.GetDeadFlag = function(self) 
		return self.DeadFlag
	end
	this.SetDeadFlag = function(self, isDead) 
		self.DeadFlag = isDead
	end

	-- ���^�e�[�u���Z�b�g
	return setmetatable(this, {__index = ObjectBase})
end

