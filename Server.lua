
WebHook = ""

ESX = nil
TriggerEvent("esx:getSharedObject",function(obj) ESX = obj end)

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
    local IsDeveloper = xPlayer.permission_level >= Config.DeveloperPermission
    if IsDeveloper then
        cb(true)
    else
        cb(false)
    end
    
end)