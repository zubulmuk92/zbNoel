ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

-- Fonctions

function DrawMissionText(msg, time)
    ClearPrints()
    SetTextEntry_2('STRING')
    AddTextComponentString(msg)
    DrawSubtitleTimed(time, 1)
end

function round(x, n)
    n = math.pow(10, n or 0)
    x = x * n
    if x >= 0 then x = math.floor(x + 0.5) else x = math.ceil(x - 0.5) end
    return x / n
end

function create_object(object_model,x,y,z)
    Citizen.CreateThread(function()
        Citizen.Wait(5)
        RequestModel(object_model)
        local iter_for_request = 1
         while not HasModelLoaded(object_model) and iter_for_request < 5 do
            Citizen.Wait(500)				
            iter_for_request = iter_for_request + 1
        end
        if not HasModelLoaded(object_model) then
            SetModelAsNoLongerNeeded(object_model)
        else
            local ped = PlayerPedId()
            local bool,nouveauz = GetGroundZFor_3dCoord(x,y,z,true) -- on essaye de placer le props le plus proprement possible
            local created_object = CreateObjectNoOffset(object_model, x, y, z-6, 1, 1, 1)
            FreezeEntityPosition(created_object,true)
            local nouveauz_bis = round(nouveauz)
            local boucle = true
            while boucle == true do
                z = round(z)
                local x,y,z = table.unpack(GetEntityCoords(created_object))
                SetEntityCoords(created_object, x, y, round(z)-1)
                Citizen.Wait(50)
                z = round(z)

                if z == nouveauz_bis then
                    boucle = false
                end
            end
            SetEntityCoords(created_object, x,y,nouveauz)
            SetModelAsNoLongerNeeded(object_model)
            
        end
    end)
end

-- Script

-- props sapin : prop_xmas_tree_int

RegisterNetEvent('zubul:perenoelMessageCl')
AddEventHandler('zubul:perenoelMessageCl', function()
    AddTextEntry("Entrer le message", "")
    DisplayOnscreenKeyboard(1, "Entrer le message ( 256 caractères )", '', "", '', '', '', 256)
    
    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
        Citizen.Wait(0)
    end
    
    if UpdateOnscreenKeyboard() ~= 2 then
        message = GetOnscreenKeyboardResult()
        Citizen.Wait(1)
    else
        Citizen.Wait(1)
    end

    TriggerServerEvent("zubul:perenoelMessageSrv",message)

end)

RegisterNetEvent('zubul:tenuePereNoel')
AddEventHandler('zubul:tenuePereNoel', function()

local ped = 'Santaclaus'
local hash = GetHashKey(ped)
	RequestModel(hash)

	while not HasModelLoaded(hash) do
        DrawMissionText("Chargement du ped ...")
		RequestModel(hash)
		Citizen.Wait(0)
	end	

	SetPlayerModel(PlayerId(), hash)
end)

-- boucle pour lancer les cadeaux

Citizen.CreateThread(function()

    while true do
        Citizen.Wait(5)

        local vehicule = GetVehiclePedIsIn(PlayerPedId(), false)

        if GetEntityModel(vehicule) == 970385471 then
            DrawMissionText("Appuyez sur ~r~[G]~w~ pour lancer des ~g~cadeaux~w~")
            if IsControlJustPressed(1,zbConfig.touchePourLancerCadeaux) then
                local x,y,z = table.unpack(GetEntityCoords(PlayerPedId()))

                create_object(zbConfig.props,x,y,z)
                Citizen.Wait(1000)
            end
            
        else
            Citizen.Wait(2000)
        end
    end

end)

-- boucle pour récupérer les cadeaux

Citizen.CreateThread(function()

    while true do

        Citizen.Wait(10)
        local x,y,z = table.unpack(GetEntityCoords(PlayerPedId()))
        local cadeauxProche = GetClosestObjectOfType(x, y, z, 40.0, zbConfig.props, false, false, false)
        local x2,y2,z2 = table.unpack(GetEntityCoords(cadeauxProche))
        local distanceCadeaux = GetDistanceBetweenCoords(x, y, z, x2, y2, z2, true)
    
        if distanceCadeaux < 2.0 then
            ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour rammasser le ~r~cadeau~w~")
            if IsControlJustReleased(0, 38) then
                SetModelAsNoLongerNeeded(zbConfig.props)
                DeleteEntity(cadeauxProche) -- si c'est pendant l'event
                DeleteObject(cadeauxProche) -- si jamais script restart vous me remercierez d'avoir mis ca
                TriggerServerEvent("zubul:gainNoelCadeaux")
            end

        -- ON OPTIMISE HIHIII

        elseif distanceCadeaux > 3.0 and distanceCadeaux < 8.0 then
            Citizen.Wait(500)
        elseif distanceCadeaux > 8.0 then
            Citizen.Wait(1000)
        end

    end

end)