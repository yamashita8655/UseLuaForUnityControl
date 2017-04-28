--直接Unityには登録しないスクリプト。いわゆる、ライブラリ化した奴

-- クラス定義
OptionScene = {}

-- コンストラクタ
function OptionScene.new()
	local this = SceneBase.new()

	this.SEValue = 0
	this.BGMValue = 0

	-- メソッド定義
	-- 初期化
	this.SceneBaseInitialize = this.Initialize
	this.Initialize = function(self)
		this:SceneBaseInitialize()
		
		LuaChangeScene("Option", "MainCanvas")
		LuaSetActive("HeaderObject", false)
		LuaSetActive("FooterObject", false)

		LuaFindObject("SESlider")
		LuaFindObject("BGMSlider")
		
		self.SEValue = SaveObject.OptionScene_SEVolumeRate
		self.BGMValue = SaveObject.OptionScene_BGMVolumeRate
		LuaSetSliderValue("SESlider", self.SEValue)
		LuaSetSliderValue("BGMSlider", self.BGMValue)
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
		
		SaveObject.OptionScene_SEVolumeRate = self.SEValue
		SaveObject.OptionScene_BGMVolumeRate = self.BGMValue
		FileIOManager.Instance():Save()
	end
	
	-- 有効かどうか
	this.IsActive = function(self)
		return self.IsActive
	end
	
	-- ボタン
	this.OnClickButton = function(self, buttonName)
		if buttonName == "OptionBackButton" then
			SceneManager.Instance():ChangeScene(SceneNameEnum.Home)
		end
	end
	
	-- スライダーイベント
	this.OnChangeSliderValue = function(self, sliderName, value)
		if sliderName == "SESlider" then
			self.SEValue = value
		elseif sliderName == "BGMSlider" then
			self.BGMValue = value
		end
	end
	
	return this
end

