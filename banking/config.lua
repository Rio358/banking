Config = {}

Strings = {
    ['Item_Required'] = 'You need the item ~r~%s~w~ to hack the ATM!',
    ['Rob'] = '~r~[~w~G~r~] ~w~Rob the ATM',
    ['Police'] = 'An ATM is being robbed!\n~INPUT_DETONATE~ to set a waypoint.',
    ['Stole'] = 'You stole ~r~$%s'
}

Config['CopsRequired'] = 0

Config['Cash'] = {
    ['Min'] = 534,
    ['Max'] = 2414
}

Config['Item'] = {
    ['Required'] = true,
    ['Name'] = 'hacktool',
    ['Remove'] = true,
    ['Label'] = 'Hacking Tablet'
}

Config['ATM'] = {
    'prop_atm_02',
    'prop_atm_03',
    'prop_fleeca_atm'
}

Config['3DText'] = function(coords, text)
    local StringRemove = {
        '~r~',
        '~w~',
        '~y~',
        '~b~',
        '~g~'
    }

    local OnScreen, x, y = World3dToScreen2d(table.unpack(coords))
    if OnScreen then
        SetTextScale(0.35, 0.35)
        SetTextFont(4)
        SetTextEntry('STRING')
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(x, y)
        for k, v in pairs(StringRemove) do
            text = text:gsub(v, '')
        end
    --    DrawRect(x, y + 0.0125, 0.015 + string.len(text) / 370, 0.03, 45, 45, 45, 150)
    end
end