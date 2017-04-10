--直接Unityには登録しないスクリプト。いわゆる、ライブラリ化した奴
GachaMoneyType = {
	ExpPoint		= 0,--バトルやって手に入るポイント
	BillingPoint	= 1,--課金ポイント
}


GachaList = {
	{
		Name = "初めてくじ",
		PrefabName = "Prefabs/",
		Price = 10,
		Detail = "ゲームを始めたばっかりの人の為のくじ。\n『もち』と『とら』が強くなるアイテムが手に入る。\n効果は低いけど安いので、気軽に引いてしまおう。\n\n1回10ねこポイント。",
		MoneyType = GachaMoneyType.ExpPoint,
		GachaData = GachaExecuteObject.new(GachaTableWood),
	},
	
	{
		Name = "慣れたくじ",
		PrefabName = "Prefabs/",
		Price = 100,
		Detail = "ゲームに慣れてきた人の為のくじ。\nこのくじ以降は、『全もちねこ』の強くなるアイテムが手に入る。\n少し高くなるが、そこそこ強くなれるアイテムが手に入る。\n\n1回100ねこポイント。",
		MoneyType = GachaMoneyType.ExpPoint,
		GachaData = GachaExecuteObject.new(GachaTableBronze),
	},
	
	{
		Name = "つわものくじ",
		PrefabName = "Prefabs/",
		Price = 1000,
		Detail = "もっと強くなりたい人の為のくじ。\n値段相応なアイテムが手に入る。\n\n1回1000ねこポイント。",
		MoneyType = GachaMoneyType.ExpPoint,
		GachaData = GachaExecuteObject.new(GachaTableSilver),
	},
	
	{
		Name = "きわみのくじ",
		PrefabName = "Prefabs/",
		Price = 10000,
		Detail = "強さを極めたい人の為のくじ\n値段が見合っていないが、最強を目指すならこのくじを引くことになる。\n\n1回10000ねこポイント。",
		MoneyType = GachaMoneyType.ExpPoint,
		GachaData = GachaExecuteObject.new(GachaTableGold),
	},
}

-- ガチャの定義
Gacha_Wood = {
	Name = "ウッドガチャ",
	Detail = "入門者用のアイテムが手に入るガチャ",
	PrefabName = "Prefabs/",
	Price = 10,
	MoneyType = GachaMoneyType.ExpPoint,
	GachaData = GachaExecuteObject.new(GachaTableWood),
}

Gacha_Bronze = {
	Name = "ブロンズガチャ",
	Detail = "初級者用のアイテムが手に入るガチャ",
	PrefabName = "Prefabs/",
	Price = 100,
	MoneyType = GachaMoneyType.ExpPoint,
	GachaData = GachaExecuteObject.new(GachaTableBronze),
}

Gacha_Silver = {
	Name = "シルバーガチャ",
	Detail = "中級者用のアイテムが手に入るガチャ",
	PrefabName = "Prefabs/",
	Price = 1000,
	MoneyType = GachaMoneyType.ExpPoint,
	GachaData = GachaExecuteObject.new(GachaTableSilver),
}

Gacha_Gold = {
	Name = "ゴールドガチャ",
	Detail = "上級者用のアイテムが手に入るガチャ",
	PrefabName = "Prefabs/",
	Price = 10000,
	MoneyType = GachaMoneyType.ExpPoint,
	GachaData = GachaExecuteObject.new(GachaTableGold),
}

--------
--〇ガチャ情報
--・ガチャ名
--・ガチャ排出テーブルデータ
--・使用するポイント
--・一回で使用するポイント
--・ガチャ詳細説明文
--
--〇ガチャ排出テーブルデータのデータ一つ
--・アイテム情報
--・排出確率
--
--〇アイテム情報
--・アイテム名
--・アイテムタイプ
--・アイテム効果
--・レアリティ


