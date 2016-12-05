--直接Unityには登録しないスクリプト。いわゆる、ライブラリ化した奴

-- クラス定義
-- 弾クラス
BulletBase = {}

-- メソッド定義

-- コンストラクタ
function BulletBase.new(posx, posy, posz, rotx, roty, rotz, name, number, width, height)
	local this = ObjectBase.new(posx, posy, posz, rotx, roty, rotz, name, number, width, height)
	
	-- メンバ変数
	this.ExistCounter = 0.0
	this.ExistTime = 0.0
	this.MoveSpeed = 0.0
	this.Attack = 0

	-- メソッド定義
	-- 初期化
	this.ObjectBaseInitialize = this.Initialize
	this.Initialize = function(self, nowHp, maxHp, attack)
		this:ObjectBaseInitialize(nowHp, maxHp)
		self.Attack = attack
	end

	-- 攻撃力の取得
	this.GetAttack = function(self)
		return self.Attack
	end

	-- メタテーブルセット
	--return setmetatable(this, {__index = BulletBase})
	return this
end

