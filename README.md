# PartySystem
 a customizeable party system for tes3mp
 This requires Two other modules. To install this module just go to your `server/scripts/custom` folder and clone this repo.

 Then add `PartySystem = require("custom.PartySystem.main")` to your customScripts.lua after [Urm's DataManager](https://github.com/tes3mp-scripts/DataManager)

# Important!
before you use the party system, it changes how journal updates and topic updates work and will give you some strange erros if your config.lua has `shareJournal` and `shareTopics` set to true.

This might be because the sharing makes players look at the *World Journal* and this will get fixed eventually to not be so introusive.

 We recommend turning all sharing features off for the best expieriance though those are the two that must be.

# PlayerActivateApi
 [PlayerActivateApi](https://github.com/DavidMeagher1/TES3MP_SingleScripts/blob/main/playerActivateAPI.lua) introduces an "OnPlayerActivate" event that allows you to know when one player has "activated" another and has a simple option to show a menu of your choosing

# Urm's DataManager
[Urm's DataManager script](https://github.com/tes3mp-scripts/DataManager) helps us handle managing the parties server side and keeping track of them in a very simple way. you should if you haven't already check out his other scripts

# Default Configuration
  ### `inviteTimeout` = time.minutes(1)
  this is how long a invitation to join a party will last, if set to nil invitations will never expire

  ### `shareJournal` = true
  this tells the party system to update all party members journals 

  ### `shareTopics` = true
  this tells the party system to update all party members topics 
  ***Note***: This wont visually update when you are in a conversation visually until you click on something
  
  ### `sendChatmessages` = true
  ***Not implemented yet***

  ### `allowNamedParties` = true
  This will make it so when you invite a player to a party for the first time it will pop up an input dialog and that will be your parties name
  
  ### `showPartyNameInChat` = true
  This requires `allowNamedParties` to be true and makes it so your party name shows up in the chatbox

  ### `partyNameMenuId` = 12859
  This is the menu id for the party name menu, you really don't need to change this unless some other script uses this id for their menus

  after you run the script on your server for the first time you can find the config file you want to change under `server/data/custom/__config_PartySystem.json`