--����Unity�ɂ͓o�^���Ȃ��X�N���v�g�B������A���C�u�����������z
BulletTypeEnum = {
	Normal = 0,--�m�[�}�����ď����Ă��邯�ǁA�e�̏�񂾂��ŏ����ł���e
	UseTargetPosition = 1,--���̉����̍��W�l���e������e�̏��
}

-- �e�̒�`
Bullet0001 = {
	PrefabName = "Prefabs/EnemyCharacterObject",
	Name = "EnemyCharacterObject",
	Width = 64,
	Height = 64,
	NowHp = 1,
	MaxHp = 1,
	Attack = 1,
	ExistTime = 3,
	MoveType = MoveSinCurve.new(0, 10, 10),
	BulletType = BulletTypeEnum.Normal,
}

Bullet0002 = {
	PrefabName = "Prefabs/EnemyCharacterObject",
	Name = "EnemyCharacterObject",
	Width = 64,
	Height = 64,
	NowHp = 1,
	MaxHp = 1,
	Attack = 1,
	ExistTime = 3,
	MoveType = MoveStraight.new(15),
	BulletType = BulletTypeEnum.Normal,
}

Bullet0003 = {
	PrefabName = "Prefabs/EnemyCharacterObject",
	Name = "EnemyCharacterObject",
	Width = 64,
	Height = 64,
	NowHp = 1,
	MaxHp = 1,
	Attack = 1,
	ExistTime = 3,
	MoveType = MoveSinCurve.new(180, 10, 10),
	BulletType = BulletTypeEnum.Normal,
}

BulletHomingTest = {
	PrefabName = "Prefabs/EnemyCharacterObject",
	Name = "EnemyCharacterObject",
	Width = 64,
	Height = 64,
	NowHp = 30,
	MaxHp = 30,
	Attack = 1,
	ExistTime = 50,
	MoveType = MoveHoming.new(0.25, 0, 10),
	BulletType = BulletTypeEnum.UseTargetPosition,
}
