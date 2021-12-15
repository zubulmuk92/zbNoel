Citizen.CreateThread(function()

    if zbConfig.controleDeLaMeteo == true then
        Citizen.Wait(50)
    
        local showHelp = true
        local loaded = false
        
        while true do
            Citizen.Wait(1)
            if IsNextWeatherType('XMAS') then
                -- effect de gel sur l'eau :)
                N_0xc54a08c85ae4d410(3.0)
                
                SetForceVehicleTrails(true)
                SetForcePedFootstepsTracks(true)
                
                if not loaded then
                    RequestScriptAudioBank("ICE_FOOTSTEPS", false)
                    RequestScriptAudioBank("SNOW_FOOTSTEPS", false)
                    RequestNamedPtfxAsset("core_snow")
                    while not HasNamedPtfxAssetLoaded("core_snow") do
                        Citizen.Wait(0)
                    end
                    UseParticleFxAssetNextCall("core_snow")
                    loaded = true
                end
                RequestAnimDict('anim@mp_snowball')
                if IsControlJustReleased(0, 119) and not IsPedInAnyVehicle(GetPlayerPed(-1), true) and not IsPlayerFreeAiming(PlayerId()) and not IsPedSwimming(PlayerPedId()) and not IsPedSwimmingUnderWater(PlayerPedId()) and not IsPedRagdoll(PlayerPedId()) and not IsPedFalling(PlayerPedId()) and not IsPedRunning(PlayerPedId()) and not IsPedSprinting(PlayerPedId()) and GetInteriorFromEntity(PlayerPedId()) == 0 and not IsPedShooting(PlayerPedId()) and not IsPedUsingAnyScenario(PlayerPedId()) and not IsPedInCover(PlayerPedId(), 0) then -- check if the snowball should be picked up
                    TaskPlayAnim(PlayerPedId(), 'anim@mp_snowball', 'pickup_snowball', 8.0, -1, -1, 0, 1, 0, 0, 0)
                    Citizen.Wait(1950) -- 1.95 secondes , temps de l'animation pour éviter les glitcheurs
                    GiveWeaponToPed(GetPlayerPed(-1), GetHashKey('WEAPON_SNOWBALL'), 2, false, true)
                end
    
    
                Citizen.Wait(5) -- optimisation , enlever cette attente si vous ne voulez pas que certaines fois le script ne detecte pas l'appuie sur [E]
                                -- (tres rare car reste une haute fréquence de rafraichissement ) , ca rajoutera 0.05ms constant parcontre ^^
    
                if not IsPedInAnyVehicle(GetPlayerPed(-1), true) then
                    if showHelp then
                        showHelpNotification()
                    end
                    showHelp = false
                else
                    showHelp = true
                end
            else
                if loaded then N_0xc54a08c85ae4d410(0.0) end
                loaded = false
                RemoveNamedPtfxAsset("core_snow")
                ReleaseNamedScriptAudioBank("ICE_FOOTSTEPS")
                ReleaseNamedScriptAudioBank("SNOW_FOOTSTEPS")
                SetForceVehicleTrails(false)
                SetForcePedFootstepsTracks(false)
            end
    
            -- pas de bobo pour les joueurs
            if GetSelectedPedWeapon(PlayerPedId()) == GetHashKey('WEAPON_SNOWBALL') then
                SetPlayerWeaponDamageModifier(PlayerId(), 0.0)
            end
        end     
    end

end)

Citizen.CreateThread(function()

    while zbConfig.controleDeLaMeteo == true do
        Citizen.Wait(0)
        SetWeatherTypeNowPersist('XMAS')  
    end
    
end)

function showHelpNotification()
    BeginTextCommandDisplayHelp("STRING")
    AddTextComponentSubstringPlayerName("Appuyez sur ~INPUT_VEH_FLY_VERTICAL_FLIGHT_MODE~ pour récuperer 2 boules de neiges !")
    EndTextCommandDisplayHelp(0, 0, 1, -1)
end

AddEventHandler('playerSpawned', function()
    showHelpNotification()
end)
