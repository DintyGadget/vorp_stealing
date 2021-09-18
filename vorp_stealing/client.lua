local inv = {}
---------------------------------------------Menu items and etc func----------------------------------------
RegisterNetEvent("vorpinventory:inspectPlayerClient")
AddEventHandler("vorpinventory:inspectPlayerClient", function(name, inv)
    local _name = name
    local _inv = inv
    WarMenu.CreateSubMenu(_name, 'funny_search', Config.Language.searchmoney)
    WarMenu.SetMenuX(_name, 0.7) -- [0.0..1.0] top left corner
    WarMenu.SetMenuY(_name, 0.1) -- [0.0..1.0] top
    WarMenu.OpenMenu(_name)
	
        while not WarMenu.IsMenuAboutToBeClosed() do 
			Citizen.Wait(0)
            if WarMenu.IsMenuOpened(_name) then
                for k,v in pairs(_inv) do
                    if WarMenu.Button(v["Name"] .. " (" .. tostring(v["Quantity"]) .. " $)") then 
						TriggerEvent("vorpinputs:getInput", Config.Language.take, Config.Language.quantity, function(cb)
							local qt = tonumber(cb)
							if qt ~= nil then
								local closestPlayer, closestDistance = GetClosestPlayer()
								TriggerServerEvent("vorpinventory:steal_money", GetPlayerServerId(closestPlayer), qt)
								WarMenu.CloseMenu()
							end
						end)
					end
                end
            end
			WarMenu.Display()
        end
end)

RegisterNetEvent("vorpinventory:inspectPlayerClient2")
AddEventHandler("vorpinventory:inspectPlayerClient2", function(name, inv)
    local _name = name
    local _inv = inv
    WarMenu.CreateSubMenu(_name, 'funny_search', Config.Language.searchitems)
    WarMenu.SetMenuX(_name, 0.7) -- [0.0..1.0] top left corner
    WarMenu.SetMenuY(_name, 0.1) -- [0.0..1.0] top
    WarMenu.OpenMenu(_name)
        while not WarMenu.IsMenuAboutToBeClosed() do 
            Citizen.Wait(0)
            if WarMenu.IsMenuOpened(_name) then
                for k,v in pairs(_inv) do
                    if WarMenu.Button(v["Name"] .. " (x" .. tostring(v["Quantity"]) .. ")") then 
						TriggerEvent("vorpinputs:getInput", Config.Language.take, Config.Language.quantity, function(cb)
							local qt = tonumber(cb)
							if qt ~= nil then
								--print("Testing:", v["Id"])
								local closestPlayer, closestDistance = GetClosestPlayer()
								TriggerServerEvent("vorpinventory:steal_items", v["Id"], GetPlayerServerId(closestPlayer), qt)
								WarMenu.CloseMenu()
							end
						end)
					end
                end
            end
			WarMenu.Display()
        end
end)

RegisterNetEvent("vorpinventory:inspectPlayerClient3")
AddEventHandler("vorpinventory:inspectPlayerClient3", function(name, inv)
    local _name = name
    local _inv = inv
    WarMenu.CreateSubMenu(_name, 'funny_search', Config.Language.searchweapons)
    WarMenu.SetMenuX(_name, 0.7) -- [0.0..1.0] top left corner
    WarMenu.SetMenuY(_name, 0.1) -- [0.0..1.0] top
    WarMenu.OpenMenu(_name)
	 
        while not WarMenu.IsMenuAboutToBeClosed() do 
			Citizen.Wait(0)
            if WarMenu.IsMenuOpened(_name) then
                for k,v in pairs(_inv) do
                    if WarMenu.Button(v["Name"] .. " (x" .. tostring(v["Quantity"]) .. ")") then 
						--print("Testing:", tostring(v["Id"]))
						local closestPlayer, closestDistance = GetClosestPlayer()
						TriggerServerEvent("vorpinventory:steal_weapon", v["Id"], GetPlayerServerId(closestPlayer))
						WarMenu.CloseMenu()
					end
                end
            end
			WarMenu.Display()
        end
end)
-------------------------------------------Main menu-------------------------------------------
Citizen.CreateThread(function() 
	WarMenu.CreateMenu('funny_search', Config.Language.mainmenu)
    WarMenu.SetMenuX('funny_search', 0.76) -- [0.0..1.0] top left corner
    WarMenu.SetMenuY('funny_search', 0.15) -- [0.0..1.0] top
	
	while true do
		Citizen.Wait(0)
		if WarMenu.IsMenuOpened('funny_search') then
			if WarMenu.Button(Config.Language.money) then
				WarMenu.CloseMenu()
				TriggerEvent("inspectplayer1")
			elseif WarMenu.Button(Config.Language.items) then
				WarMenu.CloseMenu()
				TriggerEvent("inspectplayer2")
			elseif WarMenu.Button(Config.Language.weapons) then
				WarMenu.CloseMenu()
				TriggerEvent("inspectplayer3")
			end
			WarMenu.Display()
		end
                        ----------------------------Keybind and call menu-------------------------
	local closestPlayer, closestDistance = GetClosestPlayer()
		if closestDistance < 2.0 and closestPlayer ~= -1 then
			if Citizen.InvokeNative(0x3AA24CCC0D451379, GetPlayerPed(closestPlayer)) or IsEntityDead(GetPlayerPed(closestPlayer)) then
				SetTextScale(0.5, 0.5)
				local msg = Config.Language.drawtext
				local str = Citizen.InvokeNative(0xFA925AC00EB830B9, 10, "LITERAL_STRING", msg, Citizen.ResultAsLong())
				Citizen.InvokeNative(0xFA233F8FE190514C, str)
				Citizen.InvokeNative(0xE9990552DEC71600)
				if IsControlJustReleased(0, Config.OpenMenu) then
					WarMenu.OpenMenu('funny_search')
					WarMenu.Display()
				end
			elseif not Citizen.InvokeNative(0x3AA24CCC0D451379, GetPlayerPed(closestPlayer)) or IsEntityDead(GetPlayerPed(closestPlayer)) then
				WarMenu.CloseMenu()
			end
		elseif closestDistance > 2.0 and closestPlayer ~= -1 then
			WarMenu.CloseMenu()
		end		
	end
end)

--------------------------------------Search function-----------------------------------------
RegisterNetEvent("inspectplayer1") --money
AddEventHandler("inspectplayer1", function()
    local closestPlayer, closestDistance = GetClosestPlayer()
        TriggerServerEvent("vorpinventory:search_money", GetPlayerServerId(closestPlayer))
end)

RegisterNetEvent("inspectplayer2") --items
AddEventHandler("inspectplayer2", function()
    local closestPlayer, closestDistance = GetClosestPlayer()
        TriggerServerEvent("vorpinventory:search_item", GetPlayerServerId(closestPlayer))
end)

RegisterNetEvent("inspectplayer3") --weapon
AddEventHandler("inspectplayer3", function()
    local closestPlayer, closestDistance = GetClosestPlayer()
        TriggerServerEvent("vorpinventory:search_weapon", GetPlayerServerId(closestPlayer))
end)
--------------------------------Search closest player around you-----------------------------

function GetClosestPlayer()
    local players, closestDistance, closestPlayer = GetActivePlayers(), -1, -1
    local playerPed, playerId = PlayerPedId(), PlayerId()
    local coords, usePlayerPed = coords, false
    
    if coords then
        coords = vector3(coords.x, coords.y, coords.z)
    else
        usePlayerPed = true
        coords = GetEntityCoords(playerPed)
    end
    
    for i=1, #players, 1 do
        local tgt = GetPlayerPed(players[i])

        if not usePlayerPed or (usePlayerPed and players[i] ~= playerId) then

            local targetCoords = GetEntityCoords(tgt)
            local distance = #(coords - targetCoords)
            if closestDistance == -1 or closestDistance > distance then
                
                closestPlayer = players[i]
                closestDistance = distance
            end
        end
    end
    return closestPlayer, closestDistance
end