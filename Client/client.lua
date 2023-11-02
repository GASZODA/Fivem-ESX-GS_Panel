RegisterNetEvent("discordc:kill")
AddEventHandler("discordc:kill", function() 
   SetEntityHealth(PlayerPedId(), 0)  
end)

RegisterNetEvent("fix")
AddEventHandler("fix", function() 
   local localPlayerPed = GetPlayerPed(-1)
   local localVehicle = GetVehiclePedIsIn(localPlayerPed, false)
   local plate = GetVehicleNumberPlateText(localVehicle)
   SetVehicleFixed(localVehicle)
   SetVehicleEngineHealth(localVehicle, 1000)
   SetVehicleDeformationFixed(localVehicle)
   SetVehicleUndriveable(localVehicle, false)
   SetVehicleEngineOn(localVehicle, true, true)
end)



--Felhívás és DM Script--


announcestring = false
lastfor = 7


RegisterNetEvent('announce')
announcestring = false
AddEventHandler('announce', function(msg)
	announcestring = msg
	PlaySoundFrontend(-1, "DELETE","HUD_DEATHMATCH_SOUNDSET", 1)
	Citizen.Wait(lastfor * 1000)
	announcestring = false
end)

function Initialize(scaleform)
    local scaleform = RequestScaleformMovie(scaleform)
    while not HasScaleformMovieLoaded(scaleform) do
        Citizen.Wait(0)
    end
    PushScaleformMovieFunction(scaleform, "SHOW_SHARD_WASTED_MP_MESSAGE")
	PushScaleformMovieFunctionParameterString("~r~Felhívás")
    PushScaleformMovieFunctionParameterString(announcestring)
    PopScaleformMovieFunctionVoid()
    return scaleform
end


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if announcestring then
            scaleform = Initialize("mp_big_message_freemode")
            DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255, 0)
        end
    end
end)

