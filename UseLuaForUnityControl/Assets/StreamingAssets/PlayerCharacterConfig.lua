--����Unity�ɂ͓o�^���Ȃ��X�N���v�g�B������A���C�u�����������z

-- �v���C���[�L�����N�^�[��`
PlayerCharacter001 = {
	PrefabName = "Prefabs/PlayerCharacterObject001",
	Name = "PlayerCharacterObject001",
	Width = 128,
	Height = 128,
	NowHp = 100,
	MaxHp = 100,
	BulletEmitterList = {
		Emitter001.new(0.5, Vector2.new(0, 0), EmitterTypeEnum.Normal),
	},
	EquipBulletList = {
		BulletHomingTest,
	},-- ���́ABulletEmitterList��EquipBulletList�̐��͓����ɂ��Ă����Ȃ��ƃ_��
}

PlayerCharacter002 = {
	PrefabName = "Prefabs/PlayerCharacterObject002",
	Name = "PlayerCharacterObject002",
	Width = 64,
	Height = 64,
	NowHp = 50,
	MaxHp = 100,
	BulletEmitterList = {
		Emitter001.new(0.25, Vector2.new(0, 0), EmitterTypeEnum.Normal),
	},
}

