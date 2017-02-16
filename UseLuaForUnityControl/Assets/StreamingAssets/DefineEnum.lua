--直接Unityには登録しないスクリプト。いわゆる、ライブラリ化した奴

BulletTypeEnum = {
	Normal = 0,--ノーマルって書いてあるけど、弾の情報だけで処理できる弾
	UseTargetPosition = 1,--他の何かの座標値が影響する弾の情報
}

EffectNameEnum = {
	HitEffect		= "HitEffect2",
	KarikariEffect	= "KarikariEffect",
}

EmitterTypeEnum = {
	Normal = 0,
	Satellite = 1,
}

EnemyTypeEnum = {
	Normal = 0,
	BulletShooter = 1,
}

CharacterParameterEnum = {
	AddHp = 1,
	AddAttack = 2,
	AddDeffense = 3,
	FriendPoint = 4,
	RemainParameterPoint = 5,
}

MoveTypeEnum = {
	None = -1,
	Straight = 0,
	SinCurve = 1,
	Homing = 2,
	Circle = 3,
}

SceneNameEnum = {
	Boot		= 1,
	Title   	= 2,
	--Loading = 3,
	Home		= 3,
	Custom  	= 4,
	Quest   	= 5,
	Option  	= 6,
	Battle  	= 7,
	Gacha		= 8,
	GachaEffect	= 9,
}

SkillTypeEnum = {
	Emitter = 1,
	Bullet = 2,
	ExpTable = 3,
}

ParameterType = {
	AddHp = 1,
	AddAttack = 2,
	AddDeffense = 3,
	AddFriend = 4,
}

RarityType = {
	Normal = 1,
	Rare = 2,
	SuperRare = 3,
}

