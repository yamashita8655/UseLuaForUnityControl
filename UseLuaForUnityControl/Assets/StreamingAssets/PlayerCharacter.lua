--直接Unityには登録しないスクリプト。いわゆる、ライブラリ化した奴

-- クラス定義
-- プレイヤークラス
PlayerCharacter = {}

-- メソッド定義

-- コンストラクタ
function PlayerCharacter.new(posx, posy, posz, rotx, roty, rotz, name, width, height)
	local this = CharacterBase.new(posx, posy, posz, rotx, roty, rotz, name, 0, width, height)
	
	-- メンバ変数
	this.ExistCounter = 0.0
	this.ExistTime = 0.0
	this.MoveSpeed = 1.0

	-- メソッド定義
	-- 更新
	this.BaseUpdate = this.Update
	this.Update = function(self, deltaTime)
	end

	-- メタテーブルセット
	return setmetatable(this, {__index = PlayerCharacter})
end

