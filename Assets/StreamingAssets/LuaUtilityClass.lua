--直接Unityには登録しないスクリプト。いわゆる、ライブラリ化した奴

-- クラス定義
-- 2点を表すオブジェクト
Vector2 = {}

-- コンストラクタ
function Vector2.new(x, y)
	local this = {
		x = x, 
		y = y
	}

	-- メソッド定義
	--this.Function = function()
	--end

	return this
end

-- 3点を表すオブジェクト
Vector3 = {}

-- コンストラクタ
function Vector3.new(x, y, z)
	local this = {
		x = x, 
		y = y,
		z = z
	}

	-- メソッド定義
	--this.Function = function()
	--end
	
	return this
end

-- クラス定義
UtilityFunction = {}

-- シングルトン用定義
local _instance = nil
function UtilityFunction.Instance() 
	if not _instance then
		_instance = UtilityFunction
		--_instance:Initialize()
		--setmetatable(_instance, { __index = EnemyManager })
	end

	return _instance
end

-- メソッド定義
function UtilityFunction:Initialize() 
end

-- エミッタ―設定
function UtilityFunction.SetEmitter(character, bulletEmitterList, equipBulletList, characterType) 
	for i = 1, #bulletEmitterList do
		emitter = nil
		if bulletEmitterList[i]:EmitterType() == EmitterTypeEnum.Normal then
			emitter = BulletEmitter.new()
			if i > #equipBulletList then
				-- 弾の設定がされてなかったら、1番目の弾を使う
				emitter:Initialize(bulletEmitterList[i]:Position(), bulletEmitterList[i]:ShootInterval(), bulletEmitterList[i]:RotateOffset(), equipBulletList[1], character:GetPosition(), characterType)
			else
				emitter:Initialize(bulletEmitterList[i]:Position(), bulletEmitterList[i]:ShootInterval(), bulletEmitterList[i]:RotateOffset(), equipBulletList[i], character:GetPosition(), characterType)
			end
		elseif bulletEmitterList[i]:EmitterType() == EmitterTypeEnum.Satellite then
			emitter = BulletEmitterSatellite.new()
			if i > #equipBulletList then
				emitter:Initialize(bulletEmitterList[i]:Position(), bulletEmitterList[i]:ShootInterval(), bulletEmitterList[i]:RotateOffset(), equipBulletList[1], character:GetPosition(), characterType, Vector2.new(0, 0))
			else
				emitter:Initialize(bulletEmitterList[i]:Position(), bulletEmitterList[i]:ShootInterval(), bulletEmitterList[i]:RotateOffset(), equipBulletList[i], character:GetPosition(), characterType, Vector2.new(0, 0))
			end
		end
		character:AddBulletEmitter(emitter)
	end

	return character
end

-- listから、被ってる要素を削除して返す
function UtilityFunction.ListUniq(list) 
	local dup ={};
	local outputList = {};  
	for i,v in pairs(list) do
		if(outputList[v] ~= nil) then
			table.insert(dup, v);
		end
		outputList[v] = i;
	end

	return outputList, dupList
end

-- © http://symfoware.blog68.fc2.com/blog-entry-455.html
-- 自作split関数
function UtilityFunction.StringSplit(str, delim)
    -- Eliminate bad cases...
    if string.find(str, delim) == nil then
        return { str }
    end

    local result = {}
    local pat = "(.-)" .. delim .. "()"
    local lastPos
    for part, pos in string.gfind(str, pat) do
        table.insert(result, part)
        lastPos = pos
    end
    table.insert(result, string.sub(str, lastPos))
    return result
end

-- ガチャのアイテムの説明を文字列で返す
function UtilityFunction.CreateGachaResultGetItemString(itemData) 
	local output = ""

	if itemData:GetItemType() == ItemType.ParameterUp then
		if itemData:GetKindType() == CharacterTypeEnum.Mochi then
			output = output.."『もち』の"
		elseif itemData:GetKindType() == CharacterTypeEnum.Tora then
			output = output.."『とら』の"
		elseif itemData:GetKindType() == CharacterTypeEnum.Buchi then
			output = output.."『ぶち』の"
		elseif itemData:GetKindType() == CharacterTypeEnum.Sakura then
			output = output.."『さくら』の"
		end

		if itemData:GetParameterType() == ParameterType.AddHp then
			output = output.."『HP』が"
		elseif itemData:GetParameterType() == ParameterType.AddAttack then
			output = output.."『攻撃力』が"
		elseif itemData:GetParameterType() == ParameterType.AddDeffense then
			output = output.."『防御力』が"
		elseif itemData:GetParameterType() == ParameterType.AddFriendPoint then
			output = output.."『信頼度』が"
		end
			
		output = output.."『"..itemData:GetAddValue().."』".."上がった！"
	else
	end
	
	return output
end

