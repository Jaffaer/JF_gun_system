RegisterNetEvent("jf:Sync")
AddEventHandler("jf:Sync", function(sourcePlayer, flashlightState)
    TriggerClientEvent("jf:SyncClient", -1, sourcePlayer, flashlightState)
end)