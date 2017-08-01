--直接Unityには登録しないスクリプト。いわゆる、ライブラリ化した奴

-- クラス定義
TitleScene = {}

-- コンストラクタ
function TitleScene.new()
	local this = SceneBase.new()

	--this.Test = 0

	-- メソッド定義
	-- 初期化
	this.SceneBaseInitialize = this.Initialize
	this.Initialize = function(self)
		this:SceneBaseInitialize()
		LuaSetActive("OkCancelDialog", false)
		LuaChangeScene("Title", "MainCanvas")
		
		SoundManager.Instance():PlayBGM(SoundManager.Instance().BGMIndexList.TitleSceneBgm)
	end
	
	-- 更新
	this.SceneBaseUpdate = this.Update
	this.Update = function(self, deltaTime)
		this:SceneBaseUpdate(deltaTime)
	end
	
	-- 終了
	this.SceneBaseEnd = this.End
	this.End = function(self)
		this:SceneBaseEnd()
	end
	
	-- 有効かどうか
	this.IsActive = function(self)
		return self.IsActive
	end
	
	-- コールバック
	this.OnClickButton = function(self, buttonName)
		if buttonName == "TitleSceneGoHomeButton" then
			if SaveObject.BattleSaveEnable == 1 then
				GameManager.Instance():SetSelectQuestId(SaveObject.BattleSelectQuestId)
				SceneManager.Instance():ChangeScene(SceneNameEnum.Battle)
			else
				SceneManager.Instance():ChangeScene(SceneNameEnum.Home)
			end
		end
	end
	
	return this
	--return setmetatable(this, {__index = TitleScene})
end

