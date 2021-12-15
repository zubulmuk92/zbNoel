ESX = nil

TriggerEvent('esx:getSharedObject', function(obj)
    ESX = obj
end)

-- Fonction

function havePermission(xPlayer, exclude)
	if exclude and type(exclude) ~= 'table' then exclude = nil;print("^3[zubulmuk] ^1ERREUR ^0argument non autorisé..^0") end

	local playerGroup = xPlayer.getGroup()
	for k,v in pairs(zbConfig.RangAutorise) do
		if v == playerGroup then
			if not exclude then
				return true
			else
				for a,b in pairs(exclude) do
					if b == v then
						return false
					end
				end
				return true
			end
		end
	end
	return false
end

RegisterNetEvent("zubul:gainNoelCadeaux")
AddEventHandler("zubul:gainNoelCadeaux", function()

    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    local argent = math.random(zbConfig.argentParCadeauMin,zbConfig.argentParCadeauMax)
    xPlayer.addAccountMoney('money', argent)

    TriggerClientEvent('esx:showAdvancedNotification', _source, zbConfig.nomDuServeur, '~w~Noël', "Tu as ~g~ramassé~w~ un ~r~cadeau~w~.\nTu as gagné : ~g~"..argent.."~w~$.", zbConfig.logoDuServeur, 8)

end)

RegisterNetEvent("zubul:perenoelMessageSrv")
AddEventHandler("zubul:perenoelMessageSrv", function(message)

    local xPlayers = ESX.GetPlayers()

    for i=1, #xPlayers, 1 do
        TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], zbConfig.nomDuServeur, '~w~NOËL', message, zbConfig.logoDuServeur, 8)
	end
end)

RegisterCommand("perenoel", function(source, args, rawCommand)
    if source ~= 0 then
		local xPlayer = ESX.GetPlayerFromId(source)
		if havePermission(xPlayer) then
			TriggerClientEvent("zubul:tenuePereNoel",source)
		end
	end
end, true)

RegisterCommand("perenoelmessage", function(source, args, rawCommand)
    if source ~= 0 then
		local xPlayer = ESX.GetPlayerFromId(source)
		if havePermission(xPlayer) then
			TriggerClientEvent("zubul:perenoelMessageCl",source)
		end
	end
end, true)