--直接Unityには登録しないスクリプト。いわゆる、ライブラリ化した奴

-- クラス定義
-- キャラ基本クラス
CharacterBase = {}

-- メソッド定義

-- コンストラクタ
function CharacterBase.new(position, rotate, name, number, width, height)
	local this = ObjectBase.new(position, rotate, name, number, width, height)
	
	-- メンバ変数
	this.ExistCounter = 0.0
	this.ExistTime = 0.0
	this.MoveSpeed = 0.0
	this.NowHp = 0.0
	this.MaxHp = 0.0

	-- メソッド定義
	-- 初期化
	this.ObjectBaseInitialize = this.Initialize
	this.Initialize = function(self, nowHp, maxHp)
		this:ObjectBaseInitialize()
		self.NowHp = nowHp
		self.MaxHp = maxHp
	end
	-- サンプル
	--this.Function = function(self)
	--end

	-- メタテーブルセット
	--return setmetatable(this, {__index = CharacterBase})
	return this
end

