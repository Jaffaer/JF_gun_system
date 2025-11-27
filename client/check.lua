CreateThread(function()
    local resourceName = GetCurrentResourceName()
    if resourceName ~= "JF_gun_system" then
        print("^1[GUN-JAMMING] FEL RESURSNAMN! Byt tillbaka till 'JF_gun_system'^0")
        while true do Wait(1000) end 
    end
end)