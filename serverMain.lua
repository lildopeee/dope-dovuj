RegisterServerEvent('dope:giveReward')
AddEventHandler('dope:giveReward', function()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    xPlayer.addMoney(3500)
    end
end)
