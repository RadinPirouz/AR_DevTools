ESX = nil
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

local FollowCamMode = false
local MovingSpeed = 0
local IsNoclipActive = false
local isDebugMode = false
local speeds = {
    [0] = "Very Slow",
    [1] = "Slow",
    [2] = "Normal",
    [3] = "Fast",
    [4] = "Very Fast",
    [5] = "Extremely Fast",
    [6] = "Extremely Fast v2.0",
    [7] = "Max Speed"
}
RegisterNetEvent("AR_DevTools:OpenMenu")
AddEventHandler("AR_DevTools:OpenMenu",function()
    ESX.TriggerServerCallback('AR_DevTools:CheakPermission', function(callback)
        if callback then
            OpenMenuDev()
        end
    end)
end)
function OpenMenuDev()
    ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'Dev_menu',
    {
        title    = 'Dev Menu',
        align    = 'top-left',
        elements = {
            {label = 'Noclip',	  value = 'noclip'},
            {label = 'Give Weapon',	value = 'weapon'},
            {label = 'Spawn ' ..Config.CarNameForSpawn ,	value = 'spcar'},
            {label = 'Send Coords To Discord',	value = 'ctodis'},
            {label = 'Enable Debug Mode',	value = 'debugmode'},


        }
    }, function(data, menu)

        if data.current.value == 'noclip' then
            
            IsNoclipActive = not IsNoclipActive
	        if IsNoclipActive then
		        NoClipThread()
	        end
            

        elseif data.current.value == 'weapon' then
            TriggerServerEvent('AR_DevTools:AddGun')
            menu.close() 
        

        elseif data.current.value == 'spcar' then
            menu.close()
            local playerPed = GetPlayerPed(-1)
            local pcoords = GetEntityCoords(playerPed)
            local pheading = GetEntityHeading(playerPed)
            ESX.Game.SpawnVehicle(Config.CarNameForSpawn, pcoords, pheading, function(vehicle)
                TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
                SetVehicleModKit(vehicle, 1)
                SetVehicleLivery(vehicle, 1)
                SetVehicleFuelLevel(vehicle, 0.0)
            end)
        

        elseif data.current.value == 'ctodis' then
            local pped = GetPlayerPed(-1)
            local pcoords = GetEntityCoords(pped)
            TriggerServerEvent('AR_DevTools:SendCoords',pcoords)


        elseif data.current.value == 'debugmode' then
            isDebugMode = not isDebugMode
            local pped = GetPlayerPed(-1)
            while isDebugMode do
                Citizen.Wait(1)
                local pcoords = GetEntityCoords(pped)
                local street = GetStreetNameAtCoord(pcoords.x,pcoords.y,pcoords.z)
                local streetname = GetStreetNameFromHashKey(street)
                text("~r~x: ~w~" .. FormatNumber(pcoords.x) .. " ~r~y: ~w~" .. FormatNumber(pcoords.y) .. " ~r~z: ~w~" .. FormatNumber(pcoords.z) .. " ~r~h~w~: ".. FormatNumber(GetEntityHeading(pped)) .. "\n~r~Health~w~: " .. GetEntityHealth(pped) .. " ~b~Armor~w~: " .. GetPedArmour(pped),0.01,0.7)
                text("~r~Street Name~w~: " .. streetname,0.01,0.675)
                if IsPedInAnyVehicle(pped) then
                    local carspeed = GetEntitySpeed(pped)
                    local veh = GetVehiclePedIsIn(pped,false)
                    local EntityModel = GetEntityModel(veh)
                    local VehicleName = GetDisplayNameFromVehicleModel(EntityModel)
                    local BodyHealth = GetVehicleBodyHealth(veh)
                    local Fuel = GetVehicleFuelLevel(veh)
                    text("~r~Speed: ~w~: " ..FormatNumber(carspeed).."\n~r~Car Model~w~: " .. VehicleName .. "\n~r~Body Health: ~w~" .. FormatNumber(BodyHealth) .. "\n ~r~Fuel: ~w~" .. FormatNumber(Fuel),0.01,0.55)
                end
            end
        end
end,function (data,menu)
    menu.close()       
end)


function NoClipThread()
	local function NoClipFunc()
		if (IsNoclipActive) then
			Scale = RequestScaleformMovie("INSTRUCTIONAL_BUTTONS");
			while (not HasScaleformMovieLoaded(Scale)) do
				Wait(0)
			end
		end

		while IsNoclipActive do
			local playerPed = PlayerPedId()
        	if (not IsHudHidden()) then
                BeginScaleformMovieMethod(Scale, "CLEAR_ALL")
                EndScaleformMovieMethod()

                BeginScaleformMovieMethod(Scale, "SET_DATA_SLOT")
                ScaleformMovieMethodAddParamInt(0)
                PushScaleformMovieMethodParameterString("~INPUT_SPRINT~")
                PushScaleformMovieMethodParameterString("Change Speed ("..speeds[MovingSpeed]..")")
                EndScaleformMovieMethod()

                BeginScaleformMovieMethod(Scale, "SET_DATA_SLOT")
                ScaleformMovieMethodAddParamInt(1)
                PushScaleformMovieMethodParameterString("~INPUT_MOVE_LR~")
                PushScaleformMovieMethodParameterString("Turn Left/Right")
                EndScaleformMovieMethod()

                BeginScaleformMovieMethod(Scale, "SET_DATA_SLOT")
                ScaleformMovieMethodAddParamInt(2)
                PushScaleformMovieMethodParameterString("~INPUT_MOVE_UD~")
                PushScaleformMovieMethodParameterString("Move")
                EndScaleformMovieMethod()

                BeginScaleformMovieMethod(Scale, "SET_DATA_SLOT")
                ScaleformMovieMethodAddParamInt(3)
                PushScaleformMovieMethodParameterString("~INPUT_MULTIPLAYER_INFO~")
                PushScaleformMovieMethodParameterString("Down")
                EndScaleformMovieMethod();

                BeginScaleformMovieMethod(Scale, "SET_DATA_SLOT")
                ScaleformMovieMethodAddParamInt(4)
                PushScaleformMovieMethodParameterString("~INPUT_COVER~")
                PushScaleformMovieMethodParameterString("Up")
                EndScaleformMovieMethod()

                BeginScaleformMovieMethod(Scale, "SET_DATA_SLOT")
                ScaleformMovieMethodAddParamInt(5)
                PushScaleformMovieMethodParameterString("~INPUT_VEH_HEADLIGHT~")
				local CamModeText
				if FollowCamMode then
					CamModeText = 'Active'
				else
					CamModeText = 'Deactive'
				end
                PushScaleformMovieMethodParameterString("Cam Mode: "..CamModeText)
                EndScaleformMovieMethod()

                BeginScaleformMovieMethod(Scale, "DRAW_INSTRUCTIONAL_BUTTONS")
                ScaleformMovieMethodAddParamInt(0)
                EndScaleformMovieMethod()

                DrawScaleformMovieFullscreen(Scale, 255, 255, 255, 255, 0)
            end

			local noclipEntity
			if IsPedInAnyVehicle(playerPed, true) then
				noclipEntity = GetVehiclePedIsIn(playerPed, false)
			else
				noclipEntity = playerPed
			end

            FreezeEntityPosition(noclipEntity, true);
            SetEntityInvincible(noclipEntity, true);

            DisableControlAction(0, 32)
            DisableControlAction(0, 268)
            DisableControlAction(0, 31)
            DisableControlAction(0, 269)
            DisableControlAction(0, 33)
            DisableControlAction(0, 266)
            DisableControlAction(0, 34)
            DisableControlAction(0, 30)
            DisableControlAction(0, 267)
            DisableControlAction(0, 35)
            DisableControlAction(0, 44)
            DisableControlAction(0, 20)
            DisableControlAction(0, 74)
            if (IsPedInAnyVehicle(playerPed, true)) then
                DisableControlAction(0, 85)
			end

            local yoff = 0.0;
            local zoff = 0.0;

            if (UpdateOnscreenKeyboard() ~= 0 and not IsPauseMenuActive()) then
                if (IsControlJustPressed(0, 21)) then
                    MovingSpeed = MovingSpeed+1
                    if (MovingSpeed > #speeds) then
                        MovingSpeed = 0;
                    end
                end

                if (IsDisabledControlPressed(0, 32)) then
                    yoff = 0.5
                end
                if (IsDisabledControlPressed(0, 33)) then
                    yoff = -0.5
                end
                if (IsDisabledControlPressed(0, 34)) then
                    SetEntityHeading(playerPed, GetEntityHeading(playerPed)+3)
                end
                if (IsDisabledControlPressed(0, 35)) then
                    SetEntityHeading(playerPed, GetEntityHeading(playerPed)-3)
            	end
                if (IsDisabledControlPressed(0, 44)) then
                    zoff = 0.21
                end
                if (IsDisabledControlPressed(0, 20)) then
                    zoff = -0.21
                end
				if (IsDisabledControlJustPressed(0, 74)) then
					FollowCamMode = not FollowCamMode
				end
                moveSpeed = MovingSpeed
                if (MovingSpeed > #speeds/2) then
                    moveSpeed = moveSpeed*1.8;
                end

                newPos = GetOffsetFromEntityInWorldCoords(noclipEntity, 0, yoff*(moveSpeed + 0.3), zoff*(moveSpeed + 0.3))

                local heading = GetEntityHeading(noclipEntity)
                SetEntityVelocity(noclipEntity, 0, 0, 0)
                SetEntityRotation(noclipEntity, 0, 0, 0, 0, false)
				if FollowCamMode then
					SetEntityHeading(noclipEntity, GetGameplayCamRelativeHeading())
				else
					SetEntityHeading(noclipEntity, heading)
				end

                SetEntityCollision(noclipEntity, false, false)
                SetEntityCoordsNoOffset(noclipEntity, newPos.x, newPos.y, newPos.z, true, true, true)

                SetLocalPlayerVisibleLocally(true)
                SetEntityAlpha(noclipEntity, 255*0.2, 0)

                SetEveryoneIgnorePlayer(PlayerId(), true)
                SetPoliceIgnorePlayer(PlayerId(), true)

                FreezeEntityPosition(noclipEntity, false)
                SetEntityInvincible(noclipEntity, false)
                SetEntityCollision(noclipEntity, true, true)

                SetLocalPlayerVisibleLocally(true)
                ResetEntityAlpha(noclipEntity)

                SetEveryoneIgnorePlayer(PlayerId(), false)
                SetPoliceIgnorePlayer(PlayerId(), false)
            end
            Wait(0)
		end
	end
	CreateThread(NoClipFunc)
end
end

