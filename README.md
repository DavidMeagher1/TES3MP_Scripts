# TES3MP_Scripts
![Release](https://github.com/DavidMeagher1/TES3MP_Scripts/workflows/Release/badge.svg?branch=main&event=push)

## PartySystem
A customizeable party system for tes3mp. Activate a user to invite them to a party, or if you've been invited activate a user of that party to accept. Share journal and topic updates with only the people in your party, parties are saved so you can jump back in and be in the same party.
Checkout the [ReadMe](https://github.com/DavidMeagher1/PartySystem/blob/main/README.md) of the PartySystem Module for a more detailed explination

## playerActivationAPI
`PlayerActivationAPI = require("custom.PlayerActivationAPI")`  
Adds an event when you activate a player called `OnPlayerActivate(pid, otherpid, menu, cellDescription)`  
| argument        | description                                           |
| --------------- | ----------------------------------------------------- |
| pid             | The player id of the **activating** player            |
| otherpid        | The player id of the **activated** player             |
| menu            | A table that will be passed to menuHelper.DisplayMenu |
| cellDescription | The cell description of the **activated** player      |
