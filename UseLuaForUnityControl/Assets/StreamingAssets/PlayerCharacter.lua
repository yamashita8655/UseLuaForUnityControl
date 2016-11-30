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
	this.ShootPointList = {}
	this.ShootCooltime = 0.0
	this.ShootInterval = 0.25

	-- メソッド定義
	-- 更新
	this.BaseUpdate = this.Update
	this.Update = function(self, deltaTime)
		self.ShootCooltime = self.ShootCooltime + deltaTime
	end
	
	-- 弾が発射されるポイントの追加
	this.AddShootPoint = function(self, point)
		table.insert(self.ShootPointList, point)
	end
	
	-- 弾のクールタイムが終わっているかどうか
	this.CanShootBullet = function(self)
		local canShoot = false
		if self.ShootCooltime > self.ShootInterval then
			canShoot = true
		end
		return canShoot
	end
	
	-- 弾のクールタイムリセット
	this.ResetBulletCooltime = function(self)
		self.ShootCooltime = 0.0
	end
	
	-- メタテーブルセット
	--return setmetatable(this, {__index = PlayerCharacter})
	return this
end

