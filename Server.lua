
WebHook = ""

ESX = nil
TriggerEvent("esx:getSharedObject",function(obj) ESX = obj end)


RegisterCommand('DevMenu', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.permission_level >= Config.DeveloperPermission then
        TriggerClientEvent('AR_DevTools:OpenMenu',source)
    else
        TriggerClientEvent('esx:showNotification', xPlayer.source, "~r~ Shoma Be In Command Dastresi Nadarid")
    end
end)

RegisterNetEvent("AR_DevTools:SendCoords")
AddEventHandler("AR_DevTools:SendCoords",function(coords)
    PerformHttpRequest(WebHook, function() end, "POST", 
    json.encode({
        content = '```css\n{'..coords.x  ..', '..coords.y..', '..coords.z..'}\n\nvector3('..coords.x..', '..coords.y..', '..coords.z..')\n\n{ x = '..coords.x..', y = '..coords.y..', z = '..coords.z..'}```',
    }), 
    {["Content-Type"] = "application/json"})
end)

RegisterNetEvent("AR_DevTools:AddGun")
AddEventHandler("AR_DevTools:AddGun",function()
    local playerId = source
    local xPlayer = ESX.GetPlayerFromId(playerId)
    if xPlayer.permission_level >= Config.DeveloperPermission then
        for k,v in ipairs(Config.WeaponList) do
           xPlayer.addWeapon(v, 250)
        end
    else
        DropPlayer(playerId,"Dont Use Cheat")
    end
end)
ESX.RegisterServerCallback('AR_DevTools:CheakPermission', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local temp = xPlayer.permission_level >= Config.DeveloperPermission
    
    if temp then
        cb(true)
    else
        DropPlayer(source,"Dont Use Cheat")
        cb(false)
    end
    
end)