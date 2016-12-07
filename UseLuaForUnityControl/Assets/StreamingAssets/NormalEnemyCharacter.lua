--直接Unityには登録しないスクリプト。いわゆる、ライブラリ化した奴

-- クラス定義
-- 通常雑魚的クラス
NormalEnemyCharacter = {}

-- メソッド定義

-- コンストラクタ
function NormalEnemyCharacter.new(position, rotate, name, number, width, height)
	local this = EnemyBase.new(position, rotate, name, number, width, height)
	
	-- メンバ変数

	-- メソッド定義
	-- 初期化
	this.EnemyBaseInitialize = this.Initialize
	this.Initialize = function(self, nowHp, maxHp, attack)
		this:EnemyBaseInitialize(nowHp, maxHp, attack)
	end
	
	return this
end

