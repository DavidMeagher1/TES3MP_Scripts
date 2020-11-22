PlayerResurrect = {}
PlayerResurrect.scriptName = "PlayerResurrect"
PlayerResurrect.defaultConfig = {
    deathTime = config.deathTime,
    partyDeathTimer = 3,
    healthMultiplier = 0.1
}

PlayerResurrect.config = DataManager.loadConfiguration(PlayerResurrect.scriptName, PlayerResurrect.defaultConfig)
tableHelper.fixNumericalKeys(PlayerResurrect.config)

local function hasPartySystem()
    return PartySystem ~= nil
end

local function OnPlayerActivateValidator(eventStatus, pid, otherpid, cellDescription)
    if Players[otherpid] ~= nil and Players[otherpid]:IsLoggedIn() then

        local health = tes3mp.GetHealthCurrent(otherpid)

        -- Make sure player is dead
        local canHeal = health < 1
        -- only party members will heal each other
        if canHeal and hasPartySystem() then
            local myPartyId = PartySystem.getPartyId(pid)
            local theirPartyId = PartySystem.getPartyId(otherpid)
            canHeal = myPartyId ~= nil and myPartyId == theirPartyId
        end

        if canHeal then
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
            local canHeal = health < 1

            if canHeal and hasPartySystem() then
                local myPartyId = PartySystem.getPartyId(pid)
                local theirPartyId = PartySystem.getPartyId(otherpid)
                canHeal = myPartyId ~= nil and myPartyId == theirPartyId
            end

            if canHeal then
                -- Here is where I can look to see if you share a party
                tes3mp.StopTimer(Players[otherpid].resurrectTimerId)
                
                tes3mp.Resurrect(otherpid, enumerations.resurrect.REGULAR)
                tes3mp.SetHealthCurrent(otherpid, maxHealth * PlayerResurrect.config.healthMultiplier)
                tes3mp.SendStatsDynamic(otherpid)
                
            end
        end
    end
end

local function OnPlayerDeathHandler(eventStatus, pid)
    if eventStatus.validCustomHandlers and hasPartySystem() and PartySystem.getPartyId(pid) then
        local player = Players[pid]
        tes3mp.StopTimer(player.resurrectTimerId)
        player.resurrectTimerId = tes3mp.CreateTimerEx("OnDeathTimeExpiration",time.seconds(PlayerResurrect.config.deathTime), "i", pid)
        tes3mp.StartTimer(player.resurrectTimerId)
    end
end

local function OnPartyDeath(eventStatus, partyId)
    if eventStatus.validCustomHandlers then
        for _, member in PartySystem.getMembers(partyId) do
            local player = logicHandler.GetPlayerByName(member)
            tes3mp.StopTimer(player.resurrectTimerId)
            player.resurrectTimerId = tes3mp.CreateTimerEx("OnDeathTimeExpiration",time.seconds(PlayerResurrect.config.partyDeathTimer), "i", player.pid)
            tes3mp.StartTimer(player.resurrectTimerId)
        end
        PartySystem.messageParty(partyId, "Everyone has died.")
    end
end

customEventHooks.registerValidator("OnPlayerActivate", OnPlayerActivateValidator)
customEventHooks.registerHandler("OnPlayerActivate", OnPlayerActivateHandler)
customEventHooks.registerHandler("OnPlayerDeath", OnPlayerDeathHandler)
customEventHooks.registerHandler("OnPartyDeath", OnPartyDeath)

tes3mp.LogMessage(enumerations.log.INFO, "PlayerResurrect is ready.")

return PlayerResurrect