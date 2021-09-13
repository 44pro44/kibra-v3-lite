AddEventHandler('esx:onRemoveInventoryItem', function(source, item, count)
    if item == "harness" and count < 1 then
        TriggerClientEvent('remove:harness', source)
    end
end)
