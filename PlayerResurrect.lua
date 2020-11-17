PlayerResurrect = {}

local function OnPlayerActivateValidator(eventStatus, pid, otherpid, cellDescription)
    if Players[otherpid] ~= nil and Players[otherpid]:IsLoggedIn() then

        local health = tes3mp.GetHealthCurrent(otherpid)

        tes3mp.LogMessage(enumerations.log.INFO, "Player health: " .. tostring(health))
        if health < 1 then
            -- The player you're interacting with is dead so we're going to disable showing the menu
            return customEventHooks.makeEventStatus(false, true)
        end
    end
end

local function OnPlayerActivateHandler(eventStatus, pid, otherpid, menu, cellDescription)
    if eventStatus.validCustomHandlers then
        if Players[otherpid] ~= nil and Players[otherpid]:IsLoggedIn() then
            local health = tes3mp.GetHealthCurrent(otherpid)
            local maxHealth = tes3mp.GetHealthBase(otherpid)
            -- Make sure player is dead
            if health < 1 then
                -- Here is where I can look to see if you share a party
                tes3mp.StopTimer(Players[otherpid].resurrectTimerId)
                
                tes3mp.Resurrect(otherpid, enumerations.resurrect.REGULAR)
                tes3mp.SetHealthCurrent(otherpid, maxHealth * 0.1)
                tes3mp.SendStatsDynamic(otherpid)
                
            end
        end
    end
end


customEventHooks.registerValidator("OnPlayerActivate", OnPlayerActivateValidator)
customEventHooks.registerHandler("OnPlayerActivate", OnPlayerActivateHandler)

tes3mp.LogMessage(enumerations.log.INFO, "PlayerResurrect is ready.")

return PlayerResurrect