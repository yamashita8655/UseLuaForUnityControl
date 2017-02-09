--直接Unityには登録しないスクリプト。いわゆる、ライブラリ化した奴
GachaMoneyType = {
	ExpPoint		= 0,--バトルやって手に入るポイント
	BillingPoint	= 1,--課金ポイント
}

-- 弾の定義
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


