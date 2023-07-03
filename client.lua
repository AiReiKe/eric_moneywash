if Config.oldESX then
    ESX = nil
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

    RegisterNetEvent("esx:playerLoaded")
    AddEventHandler("esx:playerLoaded", function(xPlayer)
        ESX.PlayerData = xPlayer
    end)

    RegisterNetEvent("esx:setJob")
    AddEventHandler("esx:setJob", function(job)
        ESX.PlayerData.job = job
    end)

    RegisterNetEvent("esx:onPlayerLogout")
    AddEventHandler("esx:onPlayerLogout", function()
        ESX.PlayerData = nil
    end)

    Citizen.CreateThread(function()
        if ESX.IsPlayerLoaded() then
            ESX.PlayerData = ESX.GetPlayerData()
        end
    end)
end

local showText, washing = false, false
local eventID = nil

local function IsZoneJobs(zone)
    if type(Config.Zone[zone].jobs) == 'string' then
        if Config.Zone[zone].jobs == ESX.PlayerData.job.name then
            return true
        end
    elseif type(Config.Zone[zone].jobs) == 'table' then
        for k, v in pairs(Config.Zone[zone].jobs) do
            if k == ESX.PlayerData.job.name and ESX.PlayerData.job.grade >= v then
                return true
            end
        end
    end
    return false
end

local function WashingMoney(zone)
    Citizen.CreateThread(function()
        local playerPed = PlayerPedId()
        while washing do
            if Vdist(GetEntityCoords(playerPed), Config.Zone[zone].pos) > 1.7 then
                CancelProgress(function()
                    washing = false
                end)
            end
            Citizen.Wait(0)
        end
    end)
end

local WashMoney = function(zone)
    washing = true
    ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'washing_count', {
        title = _U("washing_count")
    }, function(data, menu)
        if data.value and tonumber(data.value) > 0 then
            menu.close()
            ESX.TriggerServerCallback("eric_moneywash:haveEnoughBlack", function(have)
                if have then
                    if math.random(1, 100) <= (Config.Zone[zone].dispatchRate or 0) then
                        TriggerEvent("eric_moneywash:dispatch", Config.Zone[zone].pos)
                    end
                    ProgressBar(8000 + math.ceil(tonumber(data.value)/1000*Config.PriceTime), _U("washing_money"), {dict = 'amb@prop_human_bum_bin@idle_a', clip = 'idle_a'}, nil,
                    function()
                        while not eventID do
                            Wait(1)
                        end
                        TriggerServerEvent("eric_moneywash:WashMoney", tonumber(data.value), zone, eventID)
                        washing = false
                    end, function()
                        TriggerEvent("eric_moneywash:notify", _U('wash_fail'), "error")
                        washing = false
                    end)
                else
                    TriggerEvent("eric_moneywash:notify", _U('no_enough_black'), "error")
                    washing = false
                end
            end, tonumber(data.value))
        else
            TriggerEvent("eric_moneywash:notify", _U('count_empty'), "error")
        end
    end, function(data, menu)
        menu.close()
        washing = false
    end)
end

RegisterNetEvent("eric_moneywash:updateValue")
AddEventHandler("eric_moneywash:updateValue", function(value)
    eventID = value
end)

Citizen.CreateThread(function()
    ESX.TriggerServerCallback("eric_moneywash:getServerValue", function(value)
        eventID = value
        print('MoneyWash created by AiReiKe')
    end)
    while true do
        local inZone, inTextZone = false, false
        local pedCoords = GetEntityCoords(PlayerPedId())
        for i = 1, #Config.Zone, 1 do
            local dist = Vdist(pedCoords, Config.Zone[i].pos)
            if dist <= 25 then
                if not Config.Zone[i].jobs or IsZoneJobs(i) then
                    inZone = true
                    DrawMarker(1, Config.Zone[i].pos, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.0, 0, 0, 0, 100, false, true, 2, true, false, false, false)
                    if dist <= 1.5 and not washing then
                        inTextZone = true
                        if not showText then
                            showText = true
                            TextUI(_U("press_to_open", Config.Zone[i].name))
                        end

                        if IsControlJustReleased(0, 38) then
                            WashMoney(i)
                        end
                    end
                end
            end
        end

        if not inTextZone and showText then
            showText = false
            HideUI()
        end

        if not inZone then
            Citizen.Wait(500)
        end
        Citizen.Wait(0)
    end
end)

Citizen.CreateThread(function()
    for key, value in pairs(Config.Zone) do
        if value.blip then
            local blip = AddBlipForCoord(value.pos)
            SetBlipSprite(blip, 500)
            SetBlipColour(blip, 1)
            SetBlipScale(blip, 0.8)
            SetBlipDisplay(blip, 4)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(_U('moneywash', value.name))
            EndTextCommandSetBlipName(blip)
        end
    end
end)