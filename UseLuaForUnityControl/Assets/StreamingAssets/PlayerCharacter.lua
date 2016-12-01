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
	this.BulletEmitterList = {}

	-- メソッド定義
	-- 更新
	this.BaseUpdate = this.Update
	this.Update = function(self, deltaTime)
		for i = 1, #self.BulletEmitterList do
			emitter = self.BulletEmitterList[i]
			emitter:Update(deltaTime)
		end
	end
	
	-- 弾が発射されるポイントの追加
	this.AddBulletEmitter = function(self, emitter)
		table.insert(self.BulletEmitterList, emitter)
	end
	
	-- 弾のクールタイムが終わっているかどうか
	this.ShootBullet = function(self, degree)
		for i = 1, #self.BulletEmitterList do
			emitter = self.BulletEmitterList[i]
			emitter:ShootBullet(degree)
		end
	end
	
	-- BulletEmitterSatellite
	this.UpdateSatelliteEmitterPosition = function(self, radian, degree)
		for i = 1, #self.BulletEmitterList do
			emitter = self.BulletEmitterList[i]
			emitter:UpdatePosition(radian, degree)
		end
	end
	
	-- メタテーブルセット
	--return setmetatable(this, {__index = PlayerCharacter})
	return this
end

