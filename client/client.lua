----locals----
local rob = false 
local freezed = false
local hacked = false
local collectingtime = true
----IPL----
AddEventHandler('onResourceStart', function(resource)
   if resource == GetCurrentResourceName() then
     if Config.ipl == 'dv_union' then
        RequestIpl('FINBANK')
     end
   end
end)
RegisterNetEvent(Config.loaded, function()
    if Config.blip then
        blip( -5.6612, -669.8186, 32.3381)
    end
end)
----THREADS----
--collecting money
CreateThread(
        function()
            while true do
                Wait(0)
                local sleep = true
                if rob == true   then
                for k, collect in pairs(Config.Locations.Collect) do 
                local ped = PlayerPedId()
                local player = GetEntityCoords(ped)
                local distance = #(player - collect)
                if distance < Config.textdistance and  collectingtime then
                    sleep = false
                    Draw3DText(collect.x, collect.y, collect.z, Config.DrawTexts[6])
                if IsControlJustReleased(0, 38) then
                    progressbar()
                end
             end
         end
        end
         if sleep then 
            Wait(500)
      end
    end
end)
--starting heist
CreateThread(
        function()
            while true do
                Wait(0)
                if rob == false    then
                local ped = PlayerPedId()
                local player = GetEntityCoords(ped)
                local distance = #(player - Config.Locations.Start)
                local sleep = true
                if distance < Config.textdistance then
                    sleep = false
                    Draw3DText(Config.Locations.Start.x, Config.Locations.Start.y, Config.Locations.Start.z,Config.DrawTexts[4])
                    if IsControlJustReleased(0, 38) then
                        TriggerServerEvent('dv:server:start') 
                    end
                end
        if sleep then
            Wait(500)   
      end
   end
end
end)

--hacking  
CreateThread(function()
    while true do
        Wait(0)
    if rob == true   then
        local ped = PlayerPedId()
        local player = GetEntityCoords(ped)
        local distance1 = #(player - Config.Locations.Hack)
        local sleep = true
    if  distance1 < Config.textdistance and  hacked == false then
        sleep = false
        Draw3DText(Config.Locations.Hack.x, Config.Locations.Hack.y, Config.Locations.Hack.z,  Config.DrawTexts[5])
        if IsControlJustReleased(0, 38) then
        TriggerServerEvent('hacking')
        end
    end
    if sleep then
        Wait(500)
       end
     end
   end
end)
----TELEPORTS---- 
CreateThread(function()
    while true do
        Wait(0)
        local ped = PlayerPedId()
        local player = GetEntityCoords(ped)
        local distance2 = #(player - Config.Locations.Teleports.Up)
        local sleep = true
    if distance2 < Config.textdistance then
        sleep = false
        Draw3DText(Config.Locations.Teleports.Up.x, Config.Locations.Teleports.Up.y, Config.Locations.Teleports.Up.z,  Config.DrawTexts[3])
        if IsControlJustReleased(0, 38) then
        teleportToCoords(ped,Config.Locations.Teleports.Down)
        end
    end
    if sleep then
        Wait(500)
     end
   end
end)
CreateThread(function()
    while true do
        Wait(0)
        local ped = PlayerPedId()
        local player = GetEntityCoords(ped)
        local distance3 = #(player - Config.Locations.Teleports.Down)
        local sleep = true
    if distance3 < Config.textdistance then
        sleep = false
        Draw3DText(Config.Locations.Teleports.Down.x, Config.Locations.Teleports.Down.y, Config.Locations.Teleports.Down.z,  Config.DrawTexts[2])
        if IsControlJustReleased(0, 38) then
        teleportToCoords(ped,Config.Locations.Teleports.Up)
        end
    end
    if sleep then
        Wait(500)
end
end
end)
--stop robbery
CreateThread(function()
    while true do
        Wait(0)
    if rob == true   then
        local ped = PlayerPedId()
        local player = GetEntityCoords(ped)
        local distance = #(player - Config.Locations.Escape.TextCoords)
        local sleep = true
        if distance < Config.textdistance then
            sleep = false
        Draw3DText(Config.Locations.Escape.TextCoords.x, Config.Locations.Escape.TextCoords.y, Config.Locations.Escape.TextCoords.z,Config.DrawTexts[1])
        if IsControlJustReleased(0, 38) then
            teleportToCoords(ped,Config.Locations.Escape.TeleportCoords)
            TriggerServerEvent('dv-unionrobbery:server:stoprobbery')        
        end
    end
    if sleep then
        Wait(500)
       end
     end
   end
end)


--freezing vault
CreateThread(function()
    while true do
        Wait(0)
        local sleep = true
       if rob then
        local ped = PlayerPedId()
        local player = GetEntityCoords(ped)
        local pos = vector3(1.15, -702.66, 16.13)
        local distance = #(player - pos)
        if distance < 5.0 and freezed == false  then
             sleep = false
            TriggerServerEvent('dv-unionrobbery:server:freeze')
            freezed = true
        end
    end
    if sleep then
        Wait(500)
    end
    end
end)
----EVENTS----
--hacking
RegisterNetEvent('dv_union:client:hack', function()
TriggerEvent("mhacking:show")
TriggerEvent("mhacking:start",7,35,mycb)
end)
--stoping robbery
RegisterNetEvent('dv-unionrobbery:client:stoprobbery', function()
    Wait(180000)
    if rob == true then 
        rob = false
    end
end)
--rob
RegisterNetEvent('dv-union:client:rob', function()
    rob = true 
end)
RegisterNetEvent('dv_union:client:vehicle', function()
if Config.framework == 'qb' then
    local QBCore = exports['qb-core']:GetCoreObject()
    QBCore.Functions.SpawnVehicle(1747439474, function(veh)
        exports['LegacyFuel']:SetFuel(veh, 100)
        TriggerEvent("vehiclekeys:client:SetOwner", QBCore.Functions.GetPlate(veh))
    end, vector3(443.9419, -1922.5876, 24.6235), true)
end
end)
--hacking success
RegisterNetEvent('dv-union:hacking:success', function()
    TriggerServerEvent('dv-union:server:callpd')
    TriggerServerEvent('dv:vault:server:unfreeze')
    TriggerEvent('mhacking:hide')
end)
--freezing
RegisterNetEvent('dv:vault:freeze', function()
    local obj = GetClosestObjectOfType(-1.72947, -686.5417, 16.68913, 2.0, GetHashKey("v_ilev_fin_vaultdoor"), false, false, false)
    FreezeEntityPosition(obj, true)
    freezed = true
end)
--unfreezing
RegisterNetEvent('dv:vault:unfreeze', function()
    local obj = GetClosestObjectOfType(-1.72947, -686.5417, 16.68913, 2.0, GetHashKey("v_ilev_fin_vaultdoor"), false, false, false)
    FreezeEntityPosition(obj, false)
end)
--hacked
RegisterNetEvent('dv:client:hacked', function()
    hacked = true
end)
----FUNCTION----
--mhacking
function mycb(success, timeremaining)
	if success then
TriggerEvent('dv-union:hacking:success')
TriggerServerEvent('dv:server:hacked')
	else
		TriggerEvent('mhacking:hide')
	end
end
--teleporting
function progressbar()
    if Config.framework == 'qb' then
    local QBCore = exports['qb-core']:GetCoreObject()
    QBCore.Functions.Progressbar(Config.DrawTexts[7], Config.DrawTexts[7], math.random(3000, 5000), false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
}, {}, {}, {},function() 
TriggerServerEvent('dv-unionrobbery:server:addmoney') 
Wait(120000)
collectingtime = false   
end) 
end
if Config.framework == 'esx' then
exports["esx_progressbar"]:Progressbar(Config.DrawTexts[7], math.random(3000, 5000),{
        FreezePlayer = true, 
        onFinish = function()
            TriggerServerEvent('dv-unionrobbery:server:addmoney') 
            Wait(120000)
            collectingtime = false      
        end})
end
end
function teleportToCoords(ped, x, y, z, heading)
    CreateThread( 
      function()
        DoScreenFadeOut(250)
        while not IsScreenFadedOut() do
          Wait(0)
        end
        SetEntityCoords(ped, x, y, z)
        SetEntityHeading(ped, heading)
        DoScreenFadeIn(250)
      end)
  end
--drawtext
function Draw3DText(x, y, z, text)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end
--blip
function blip(x,y,z)
    local Dealer = AddBlipForCoord(x, y,z)
    SetBlipSprite (Dealer, 475  )
    SetBlipDisplay(Dealer, 4)
    SetBlipScale  (Dealer, 0.7)
    SetBlipAsShortRange(Dealer, true)
    SetBlipColour(Dealer, 3)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName("Union Depository")
    EndTextCommandSetBlipName(Dealer) 
end