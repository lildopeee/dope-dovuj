isJoinedFight = false

Citizen.CreateThread(function()
    while true do

        local player = PlayerPedId()
        local playerLoc = GetEntityCoords(player, false)
        local distance = #(playerLoc - vector3(-522.8, -1715.16, 19.32))

        if distance < 1.6 then
            Wait = 5
            DrawText3D(vector3(-522.8, -1715.16, 19.32), '~w~[~g~E~w~] Tusuna Basarak UFC e Basvur')
            if IsControlJustReleased(0, 38) then
                isJoinedFight = true
                ScreenFade()
                final_boxer = CreateFinalBoxer()
            end 
        else
            Wait = 1000
        end
			
        Citizen.Wait(Wait)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(500)
        if DoesEntityExist(final_boxer)  then
            local getBoxerHP = GetEntityHealth(final_boxer)
            print(getBoxerHP)
            if getBoxerHP < 101 then
                TriggerServerEvent('dope:giveReward')
                Citizen.Wait(6500)
                DeletePed(final_boxer)
                Citizen.Wait(50)
                RenderScriptCams(false, false, 1, true, true)
            elseif IsEntityDead(PlayerPedId()) then
                Citizen.Wait(5500)
                RenderScriptCams(false, false, 1, true, true)
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        if isJoinedFight == true then
            CamRefreshTime = 3
            local player = PlayerPedId()
            local playerLoc = GetEntityCoords(player, false)
            SetCamCoord(FightCam, playerLoc.x-1.5, playerLoc.y-1.5,  21.00)
        else
            CamRefreshTime = 1000
        end
        Citizen.Wait(CamRefreshTime)
    end
end)


function CreateFinalBoxer()
    local finalboxer_hash = "s_m_y_prismuscl_01"
    local final_boxer = { x = -522.28, y = -1719.50, z = 19.28, h = 318.45}
	
	RequestModel(finalboxer_hash)
    while not HasModelLoaded(finalboxer_hash) do
	    Citizen.Wait(10)
    end
	
    final_boxer = CreatePed(1, finalboxer_hash, final_boxer.x, final_boxer.y, final_boxer.z, final_boxer.h, true, false)
    SetBlockingOfNonTemporaryEvents(final_boxer, true) 
    SetPedDiesWhenInjured(final_boxer, true) 
    SetPedCanPlayAmbientAnims(final_boxer, true) 
    TaskPedSlideToCoord(final_boxer, -518.69, -1714.75, 20.46, 318.45, 1.0)

    --Cam--

    RingCam = CreateCam("DEFAULT_SCRIPTED_CAMERA", false)
    SetCamActive(RingCam, true)
    RenderScriptCams(true, false, 1, true, true)
    SetCamCoord(RingCam, -516.91, -1712.39,  21.00)
    PointCamAtEntity(RingCam, final_boxer, 0.0, 0.0, 0.0, 1)
    Citizen.Wait(6800)
    RenderScriptCams(false, false, 1, true, true)
    Citizen.Wait(1)
    FightCam = CreateCam("DEFAULT_SCRIPTED_CAMERA", false)
    SetCamActive(FightCam, true)
    RenderScriptCams(true, false, 1, true, true)
    SetCamFov(FightCam, 100.0)
    PointCamAtEntity(FightCam, PlayerPedId(), 0.0, 0.0, 0.0, 1)
    

    TaskCombatPed(final_boxer, PlayerPedId(), 0, 16)
    SetPedCombatAbility(final_boxer, 3)
    SetPedCombatMovement(final_boxer, 3)
    SetPedCombatAttributes(final_boxer, 46)   
    SetEntityHealth(final_boxer, 700)
    SetPedCanRagdollFromPlayerImpact(final_boxer, true)

    SetAiMeleeWeaponDamageModifier(2.0)

    return final_boxer
end

function ScreenFade()
    DoScreenFadeOut(1000)
    Citizen.Wait(2000)
    DoScreenFadeIn(1000)
    SetEntityCoords(PlayerPedId(), -515.58, -1709.54, 20.46-1, false, false, false, false)
    SetEntityHeading(PlayerPedId(), 135.41)
end

DrawText3D = function(coords, text)
    local onScreen, _x, _y = World3dToScreen2d(coords.x, coords.y, coords.z)
    local pX, pY, pZ = table.unpack(GetGameplayCamCoords())
  
    SetTextScale(0.3, 0.3)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextEntry("STRING")
    SetTextCentre(1)
    SetTextColour(255, 255, 255, 255)
    SetTextOutline()
  
    AddTextComponentString(text)
    DrawText(_x, _y)
end
