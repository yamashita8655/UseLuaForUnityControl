--直接Unityには登録しないスクリプト。いわゆる、ライブラリ化した奴

-- クラス定義
-- 弾を打つ雑魚的クラス
EnemyShooter = {}

-- メソッド定義

-- コンストラクタ
function EnemyShooter.new(posx, posy, posz, rotx, roty, rotz, name, number, width, height)
	local this = EnemyBase.new(posx, posy, posz, rotx, roty, rotz, name, number, width, height)
	
	-- メンバ変数
	this.BulletEmitterList = {}

	-- メソッド定義
	-- 初期化
	this.EnemyBaseInitialize = this.Initialize
	this.Initialize = function(self, nowHp, maxHp, attack)
		this:EnemyBaseInitialize(nowHp, maxHp, attack)
	end
	
	-- 更新
	this.EnemyBaseUpdate = this.Update
	this.Update = function(self, deltaTime)
		this.EnemyBaseUpdate(deltaTime)
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

	return this
end

