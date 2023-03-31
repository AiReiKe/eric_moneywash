if Config.oldESX then
    ESX = nil
    TriggerEvent("esx:getSharedObject", function(obj) ESX = obj end)
end

local serverID = nil

local function discordLogs(msg, color)
    if Config.Discord.enable then
        PerformHttpRequest(Config.Discord.webhook, function(err, Content, Head) end, 'POST', json.encode({username = "Eric Money Wash", embeds = {
            {
                ["color"] = color,
                ["title"] = "**Eric Money Wash**",
                ["description"] = msg,
                ["footer"] = {
                    ["text"] = "",
                },
            }
        }, avatar_url = Config.Discord.imgURL}), {['Content-Type'] = 'application/json'})
    end
end

RegisterServerEvent("eric_moneywash:WashMoney")
AddEventHandler("eric_moneywash:WashMoney", function(count, zone, cbID)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    if serverID and cbID == serverID then
        if xPlayer.getAccount('black_money').money >= count then
            xPlayer.removeAccountMoney('black_money', count)
            xPlayer.addMoney(math.ceil(count * Config.Zone[zone].rate))
            TriggerClientEvent("eric_moneywash:notify", src, _U("washed_money", count, math.ceil(count * Config.Zone[zone].rate)), 'success')
            discordLogs(_U("defaultLog", GetPlayerName(src), GetPlayerIdentifier(src), xPlayer.getName(), count, math.ceil(count * Config.Zone[zone].rate), Config.Zone[zone].name, os.date("%Y/%m/%d %X")), 155400)
        else
            TriggerClientEvent("eric_moneywash:notify", src, _U('no_enough_black'), 'error')
            local steam, discord = nil, nil
            for k, v in pairs(GetPlayerIdentifiers(src)) do
                if string.sub(v, 1, string.len('steam:')) == 'steam:' then
                    steam = string.sub(v, string.len('steam:') + 1, -1)
                elseif string.sub(v, 1, string.len('discord:')) == 'discord:' then
                    discord = string.sub(v, string.len('discord:') + 1, -1)
                end
            end
            discordLogs(_U('mechanism', GetPlayerName(src), xPlayer and xPlayer.getName() or "N/A", steam or "N/A", os.date("%Y/%m/%d %X"), discord or "N/A"), 16765702)
        end
    else
        local steam, discord = nil, nil
        for k, v in pairs(GetPlayerIdentifiers(src)) do
            if string.sub(v, 1, string.len('steam:')) == 'steam:' then
                steam = string.sub(v, string.len('steam:') + 1, -1)
            elseif string.sub(v, 1, string.len('discord:')) == 'discord:' then
                discord = string.sub(v, string.len('discord:') + 1, -1)
            end
        end
        discordLogs(_U('cheating', GetPlayerName(src), xPlayer and xPlayer.getName() or "N/A", steam or "N/A", os.date("%Y/%m/%d %X"), discord or "N/A"), 16711680)
        print(string.format("%s[%s] tried to cheating", GetPlayerName(src), ("steam:%s"):format(steam) or "N/A"))
    end
end)

ESX.RegisterServerCallback("eric_moneywash:haveEnoughBlack", function(source, cb, count)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.getAccount('black_money').money >= count then
        cb(true)
    else
        cb(false)
    end
end)

ESX.RegisterServerCallback("eric_moneywash:getServerValue", function(source, cb)
    cb(serverID)
end)

Citizen.CreateThread(function()
    while true do
        serverID = math.random(1000, 9999)
        TriggerClientEvent("eric_moneywash:updateValue", -1, serverID)
        Citizen.Wait(15*60*1000)
    end
end)

print("This script is a free script created by AiReiKe")