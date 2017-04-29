--直接Unityには登録しないスクリプト。いわゆる、ライブラリ化した奴

-- クラス定義
-- 弾クラス
CharacterParameter = {}

-- メソッド定義

-- コンストラクタ
function CharacterParameter.new(maxHp, attack, deffense, friendPoint)
	local this = {
		LocalMaxHp = maxHp,
		LocalAttack = attack,
		LocalDeffense = deffense,
		LocalFriendPoint = friendPoint
	}
	
	-- メソッド定義
	-- 初期化
	this.ObjectBaseInitialize = this.Initialize
	
	-- 最大HP
	this.MaxHp = function(self)
		return self.LocalMaxHp
	end
	-- 攻撃力
	this.Attack = function(self)
		return self.LocalAttack
	end
	-- 防御力
	this.Deffense = function(self)
		return self.LocalDeffense
	end
	-- 信頼度
	this.FriendPoint = function(self)
		return self.LocalFriendPoint
	end

	return this
end

