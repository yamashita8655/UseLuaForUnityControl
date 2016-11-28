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
	}

	-- ���\�b�h��`
	-- ���W�擾
	this.GetPosition = function(self)
		return self.PositionX, self.PositionY, self.PositionZ
	end

	-- �T�C�Y�擾
	this.GetSize = function(self) 
		return self.Width, self.Height
	end

	-- ��]���擾
	this.GetRotate = function(self) 
		return self.RotateX, self.RotateY, self.RotateZ
	end

	-- ���O�擾
	this.GetName = function(self) 
		return self.Name
	end

	-- ���^�e�[�u���Z�b�g
	return setmetatable(this, {__index = ObjectBase})
end

