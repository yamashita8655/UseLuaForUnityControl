--����Unity�ɂ͓o�^���Ȃ��X�N���v�g�B������A���C�u�����������z

-- �N���X��`
ObjectBase = {}

-- �R���X�g���N�^
function ObjectBase.new(position, rotate, name, number, width, height)
	local this = {
		Position = position,
		Rotate = rotate,
		Name = name,
		Number = number,
		Width = width,
		Height = height,
		DeadFlag = false,
		NowHp = 0,
		MaxHp = 0,
	}

	-- ���\�b�h��`
	-- ������
	this.Initialize = function(self, nowHp, maxHp)
		self.NowHp = nowHp
		self.MaxHp = maxHp
	end
	
	-- ����HP�̉����Z
	this.AddNowHp = function(self, addValue)
		self.NowHp = self.NowHp + addValue
		if self.NowHp < 0 then
			self.NowHp = 0
		end
		if self.NowHp > self.MaxHp then
			self.NowHp = self.MaxHp
		end
	end
	
	-- ����HP�̒��ڒl�w��
	this.SetNowHp = function(self, value)
		self.NowHp = value
		if self.NowHp < 0 then
			self.NowHp = 0
		end
		if self.NowHp > self.MaxHp then
			self.NowHp = self.MaxHp
		end
	end
	
	-- �ő�HP�̉����Z
	this.AddMaxHp = function(self, addValue)
		if addValue > 0 then
			self.NowHp = self.NowHp + addValue
		end
		self.MaxHp = self.MaxHp + addValue
		if self.MaxHp <= 0 then
			self.MaxHp = 1
		end
		if self.NowHp > self.MaxHp then
			self.NowHp = self.MaxHp
		end
	end
	
	-- �ő�HP�̒��ڒl�w��
	this.SetMaxHp = function(self, value)
		if value > self.MaxHp then
			diffValue = value - self.MaxHp
			self.NowHp = self.NowHp + diffValue
		end
		self.MaxHp = value
		if self.MaxHp <= 0 then
			self.MaxHp = 1
		end
		if self.NowHp > self.MaxHp then
			self.NowHp = self.MaxHp
		end
	end

	-- ���W�擾
	this.GetPosition = function(self)
		return self.Position
	end
	-- ���W�ݒ�
	this.SetPosition = function(self, positionx, positiony, positionz)
		self.Position.x = positionx
		self.Position.y = positiony
		self.Position.z = positionz
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
		return self.Rotate
	end
	-- ��]���ݒ�
	this.SetRotate = function(self, rotatex, rotatey, rotatez) 
		self.Rotate.x = rotatex
		self.Rotate.y = rotatey
		self.Rotate.z = rotatez
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
	this.IsAlive = function(self) 
		local isAlive = true
		-- HP��0�ȉ���������A����
		if self.NowHp <= 0 then
			isAlive = false
		end
		return isAlive
	end

	-- ���^�e�[�u���Z�b�g
	--return setmetatable(this, {__index = ObjectBase})
	return this
end

