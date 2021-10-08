VorpInv = exports.vorp_inventory:vorp_inventoryApi()

local VorpCore = {}

TriggerEvent("getCore",function(core)
    VorpCore = core
end)
---------------------------StealMoney------------------------------------------------
RegisterServerEvent("vorpinventory:search_money")
AddEventHandler("vorpinventory:search_money", function(target) 
		local _source = source
		local User = VorpCore.getUser(target) 
		local Character = User.getUsedCharacter 
		local name = Character.identifier
        local tableInv = {}
		table.insert(tableInv, {Name="Деньги", Quantity = Character.money}) -- Money name item
	
        TriggerClientEvent("vorpinventory:inspectPlayerClient", _source, name, tableInv)
end)

RegisterServerEvent("vorpinventory:steal_money")
AddEventHandler("vorpinventory:steal_money", function(target, qt)
    local _source = source
    local User = VorpCore.getUser(target) 
    local Character = User.getUsedCharacter 
	local number = Character.money-qt 

	if Character.money >= qt then

	TriggerEvent("vorp:addMoney", _source, 0, tonumber(qt))
	TriggerEvent("vorp:removeMoney", target, 0, tonumber(qt))
	
	end
end)
----------------------------------------SearchItems---------------------------------------------------

RegisterServerEvent("vorpinventory:search_item")
AddEventHandler("vorpinventory:search_item", function(target) 
    local _source = source
    local User = VorpCore.getUser(target) 
    local Character = User.getUsedCharacter 
    local name = Character.identifier
        local tableInv = {}		
		TriggerEvent("vorpCore:getUserInventory", tonumber(target), function(getInventory)
			for k, v in pairs (getInventory) do
				table.insert(tableInv,  {Id = v.name, Name = v.label, Quantity = v.count})
			end
		end)
		
        TriggerClientEvent("vorpinventory:inspectPlayerClient2", _source, name, tableInv)
end)

RegisterServerEvent("vorpinventory:steal_items")
AddEventHandler("vorpinventory:steal_items", function(item, target, qt)
    local _source = source
    local User = VorpCore.getUser(target) 
    local Character = User.getUsedCharacter 
	local count = VorpInv.getItemCount(target, item)
      if count >= tonumber(qt) then
	--print("StealItems:", item)
	VorpInv.addItem(_source, item, tonumber(qt))
	VorpInv.subItem(target, item, tonumber(qt))
	  end
end)

------------------------------------------SearchWeapon-----------------------------------------------------

RegisterServerEvent("vorpinventory:search_weapon")
AddEventHandler("vorpinventory:search_weapon", function(target) 
    local _source = source
    local User = VorpCore.getUser(target) 
    local Character = User.getUsedCharacter 
    local name = Character.identifier
        local tableInv = {}
		local weapons = VorpInv.getUserWeapons(target)
        if weapons ~= nil then
            for k,v in pairs(weapons) do 
                table.insert(tableInv, {Id = getWeaponNameFromId(v["id"]), Name = getWeaponNameFromId(v["name"]), Quantity = "1"})
            end
        end
		
        TriggerClientEvent("vorpinventory:inspectPlayerClient3", _source, name, tableInv)
end)

RegisterServerEvent("vorpinventory:steal_weapon")
AddEventHandler("vorpinventory:steal_weapon", function(weapid, target)
    local _source = source
    local User = VorpCore.getUser(target) 
    local Character = User.getUsedCharacter 
	local weapons = VorpInv.getUserWeapons(target)
	--print("StealWeapon:", weapid)
	VorpInv.giveWeapon(_source, weapid, target)
	VorpInv.subWeapon(target, weapid)
end)

function getWeaponNameFromId(weapon) 
	local weaponNames = {
		{id = "WEAPON_REVOLVER_LEMAT", name = "Revolver Lemant"},
		{id = "WEAPON_MELEE_KNIFE", name = "Coltello"},
		{id = "WEAPON_KIT_CAMERA", name = "Cinepresa"},
		{id = "WEAPON_MELEE_LANTERN_ELECTRIC", name = "Lanterna elettrica"},
		{id = "WEAPON_MELEEE_TORCH", name = "Torcia"},
		{id = "WEAPON_THROWN_THROWING_KNIEVES", name = "Coltelli da lancio"},
		{id = "WEAPON_LASSO", name = "Lasso"},
		{id = "WEAPON_THROWN_TOMAHAWK", name = "Tomahawk"},
		{id = "WEAPON_PISTOL_M1899", name = "Pistola M1899"},
		{id = "WEAPON_PISTOL_MAUSER", name = "Pistola mauser"},
		{id = "WEAPON_PISTOL_VOLCANIC", name = "Pistola volcanic"},
		{id = "WEAPON_REPEATER_CARABINE", name = "Carabina a ripetizione"},
		{id = "WEAPON_REPETER_EVANS", name = "ripetitore evans"},
		{id = "WEAPON_REPEATER_HENRY", name = "Ripetitore Henry"},
		{id = "WEAPON_RIFLE_VARMINT", name = "Fucile Varmint"},
		{id = "WEAPON_REPEATER_WINCHESTER", name = "Ripetitore winchester"},
		{id = "WEAPON_REVOLVER_CATTLEMAN", name = "Revolver cattleman"},
		{id = "WEAPON_REVOLVER_DOUBLEACTION", name = "Revolver Doppia Azione"},
		{id = "WEAPON_REVOLVER_SCHOFIELD", name = "Revolver Schofield"},
		{id = "WEAPON_RIFLE_BOLTACTION", name = "Fucile Boltaction"},
		{id = "WEAPON_SNIPERRIFLE_CARCANO", name = "Fucile carcano"},
		{id = "WEAPON_SNIPERRIFLE_ROLLINGBLOCK", name = "Fucile Rollingblock"},
		{id = "WEAPON_RIFLE_SPRINGFIELD", name = "Fucile springfield"},
		{id = "WEAPON_SHOTGUN_PUMP", name = "Fucile a pompa"},
		{id = "WEAPON_BOW", name = "Arco"},
		{id = "WEAPON_MELEE_HATCHET", name = "Accetta"},
		{id = "WEAPON_SHOTGUN_SAWEDOFF", name = "Fucile a pompa sawedoff"},
	}

	local name 

	for k,v in pairs(weaponNames) do
		if weapon == v.id then 
			name = v.name
		end
	end

	if name == nil then name = weapon end

	return name
end