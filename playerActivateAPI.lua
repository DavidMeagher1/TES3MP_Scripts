--[[
  This is a module that just adds some simple helpers for player to player activation
  Activation should always pop up a menu for custom options
]] --
-- onPlayerActivated
--[[function logd(msg)
  tes3mp.LogMessage(enumerations.log.INFO,msg)
end]] --

PlayerActivationApi = {}
PlayerActivationApi.config = {}

-- this function checks to see if this is a player activating another player and calls the validator and handler for "OnPlayerActivate"
local function ObjectToPlayerHandler(eventStatus, pid, cellDescription, objects, players)
    if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
        if LoadedCells[cellDescription] ~= nil then
            if eventStatus.validDefaultHandler then
                if #objects == 0 and #players > 0 then
                    local otherPid = players[1].pid
                    local MenuKey = "PlayerActivationApiMenu_" .. tostring(pid)

                    eventStatus = customEventHooks.triggerValidators("OnPlayerActivate",
                                      {pid, otherPid, cellDescription})

                    Menus[MenuKey] = {
                        text = "",
                        buttons = {{
                            caption = "Exit",
                            destinations = nil
                        }}
                    }
                    local menu = Menus[MenuKey]
                    customEventHooks.triggerHandlers("OnPlayerActivate", eventStatus,
                        {pid, otherPid, menu, cellDescription})
                    if eventStatus.validDefaultHandler then
                        menu.text = Players[otherPid].name
                        Players[pid].currentCustomMenu = MenuKey
                        menuHelper.DisplayMenu(pid, MenuKey)
                    end
                    Menus[MenuKey] = nil

                end
            end
        end
    end
end
-- register that function to be called when the player activates an object
customEventHooks.registerHandler("OnObjectActivate", ObjectToPlayerHandler)

-- this validator just makes sure everyone is logged in
function PlayerActivationApi.OnPlayerActivateValidator(eventStatus, activatingPlayer, activatedPlayer, cellDescription)
    if (Players[activatingPlayer] == nil or Players[activatedPlayer] == nil or Players[activatingPlayer]:IsLoggedIn() ==
        false or Players[activatedPlayer]:IsLoggedIn() == false or LoadedCells[cellDescription] == nil) then
        return customEventHooks.makeEventStatus(false, false)
    end
end

function PlayerActivationApi.enableMenu()
    PlayerActivationApi.config.showMenuOnActivate = true
end
function PlayerActivationApi.disableMenu()
    PlayerActivationApi.config.showMenuOnActivate = false
end

customEventHooks.registerValidator("OnPlayerActivate", PlayerActivationApi.OnPlayerActivateValidator)

return PlayerActivationApi
