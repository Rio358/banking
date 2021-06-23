
local showBankBlips = true
local atBank = false
local bankMenu = true
local inMenu = false
local atATM = false
local bankColor = "green"

local bankLocations = {
--    {i = 108, c = 77, x = 241.727, y = 220.706, z = 106.286, s = 0.6, n = "Pacific Bank"}, -- blip id, blip color, x, y, z, scale, name/label
	{i = 108, c = 0, x = 150.266, y = -1040.203, z = 29.374, s = 0.6, n = "Fleeca Bank"},
	{i = 108, c = 0, x = -1212.980, y = -330.841, z = 37.787, s = 0.6, n = "Fleeca Bank"},
	{i = 108, c = 0, x = -2962.582, y = 482.627, z = 15.703, s = 0.6, n = "Fleeca Bank"},
	{i = 108, c = 0, x = -112.202, y = 6469.295, z = 31.626, s = 0.6, n = "Fleeca Bank"},
	{i = 108, c = 0, x = 314.187, y = -278.621, z = 54.170, s = 0.6, n = "Fleeca Bank"},
	{i = 108, c = 0, x = -351.534, y = -49.529, z = 49.042, s = 0.6, n = "Fleeca Bank"},
	{i = 108, c = 0, x = 1175.0643310547, y = 2706.6435546875, z = 38.094036102295, s = 0.6, n = "Fleeca Bank"}
}

function openPlayersBank(type, color)
    local dict = 'anim@amb@prop_human_atm@interior@male@enter'
    local anim = 'enter'
    local ped = PlayerPedId()
    local time = 2500

    RequestAnimDict(dict)

    while not HasAnimDictLoaded(dict) do
        Citizen.Wait(5)
    end

    TaskPlayAnim(ped, dict, anim, 8.0, 8.0, -1, 0, 0, 0, 0, 0)
    exports['progressBars']:startUI(time, "Inserting card...")
    Citizen.Wait(time)
    ClearPedTasks(ped)
    if type == 'bank' then
        inMenu = true
        SetNuiFocus(true, true)
        bankColor = "green"
        SendNUIMessage({type = 'openBank', color = bankColor})
        TriggerServerEvent('orp:bank:balance')
        atATM = false
    elseif type == 'atm' then
        inMenu = true
        SetNuiFocus(true, true)
        SendNUIMessage({type = 'openBank', color = bankColor})
        TriggerServerEvent('orp:bank:balance')
        atATM = true
    end
end

local blipsLoaded = false

Citizen.CreateThread(function() -- Add bank blips
    for k, v in ipairs(bankLocations) do
    local blip = AddBlipForCoord(v.x, v.y, v.z)
 		SetBlipSprite(blip, v.i)
 		SetBlipScale(blip, v.s)
 		SetBlipAsShortRange(blip, true)
 		SetBlipColour(blip, v.c)
 		BeginTextCommandSetBlipName("STRING")
 		AddTextComponentString(tostring(v.n))
 		EndTextCommandSetBlipName(blip)
        blipsLoaded = true
    end
end)

local atmFleeca = {
    -1126237515,
    506770882,
    -870868698,
    150237004,
    -239124254,
    -1364697528,
}

-- ATMs

exports['bt-target']:AddTargetModel(atmFleeca, {
    options = {
        {
            event = "banking:showMeMoney",
            icon = "fas fa-credit-card",
            label = "Use ATM",
        },
    },
    job = {["all"] = { grade = 0}},
    distance = 1.2
})

-- Fuck ass Legion Square ATM Zones
exports['bt-target']:AddBoxZone("FleecaLegionRight", vector3(145.8462, -1035.6, 29.33044), 0.5, 1.0, {
    name="FleecaLegionRight",
    debugPoly=false,
    heading=160.0,
    minZ=29.0,
    maxZ=30.5
    },{
    options = {
        {
            event = "banking:showMeMoney",
            icon = "fas fa-piggy-bank fa-lg",
            label = "Access Account",
        },
    },
    job = {["all"] = { grade = 0}},
    distance = 1.2
})

exports['bt-target']:AddBoxZone("FleecaLegionLeft", vector3(147.5, -1036.2, 29.33044), 0.5, 1.0, {
    name="FleecaLegionLeft",
    debugPoly=false,
    heading=160.0,
    minZ=29.0,
    maxZ=30.5
    },{
    options = {
        {
            event = "banking:showMeMoney",
            icon = "fas fa-piggy-bank fa-lg",
            label = "Access Account",
        },
    },
    job = {["all"] = { grade = 0}},
    distance = 1.2
})

-- Banks

exports['bt-target']:AddBoxZone("Pacific-standard", vector3(247.66, 223.78, 106.29), 0.5, 12.5, {
	name= "Pacific-standard",
	heading= 342.50,
	debugPoly= false,
	minZ= 105.29,
	maxZ= 106.99
}, {
	options = {
	{
	event = 'banking:showMeBankMoney',
	icon = "fas fa-money-bill-wave",
	label = "Access Bank Account.",
	},
},
job = {["all"] = { grade = 0}},
	distance = 3.0
})

exports['bt-target']:AddBoxZone("Hawick Avenu-Bank", vector3(313.84, -279.69, 53.37), 1.0, 3.8, {
	name= "bennys-shop",
	heading= 163.17,
	debugPoly= false,
	minZ= 53.27,
	maxZ= 54.99
}, {
	options = {
	{
	event = 'banking:showMeBankMoney',
	icon = "fas fa-money-bill-wave",
	label = "Access Bank Account.",
	},
},
job = {["all"] = { grade = 0}},
	distance = 2.5
})

exports['bt-target']:AddBoxZone("Hawick Avenue-Bank2", vector3(-351.82, -50.28, 48.54), 1.0, 3.8, {
	name= "Hawick Avenue-Bank2",
	heading= 180.00,
	debugPoly= false,
	minZ= 48.44,
	maxZ= 49.99
}, {
	options = {
	{
	event = 'banking:showMeBankMoney',
	icon = "fas fa-money-bill-wave",
	label = "Access Bank Account.",
	},
},
job = {["all"] = { grade = 0}},
	distance = 2.5
})

exports['bt-target']:AddBoxZone("Boulevard Del-Perro-Bank", vector3(-1212.96, -331.67, 37.79), 1.5, 4.0, {
	name= "Boulevard Del-Perro-Bank",
	heading= 207.85,
	debugPoly= false,
	minZ= 37.00,
	maxZ= 38.00
}, {
	options = {
	{
	event = 'banking:showMeBankMoney',
	icon = "fas fa-money-bill-wave",
	label = "Access Bank Account.",
	},
},
job = {["all"] = { grade = 0}},
	distance = 3.5
})

exports['bt-target']:AddBoxZone("Vespucci Boulevard-Bank", vector3(149.06, -1041.02, 28.47), 1.0, 3.8, {
	name= "Vespucci Boulevard-Bank",
	heading= 160.00,
	debugPoly= false,
	minZ= 28.44,
	maxZ= 29.99
}, {
	options = {
	{
	event = 'banking:showMeBankMoney',
	icon = "fas fa-money-bill-wave",
	label = "Access Bank Account.",
	},
},
	job = {["all"] = { grade = 0}},
	distance = 2.5
})

exports['bt-target']:AddBoxZone("Great Ocean Highway-Bank", vector3(-2962.18, 482.17, 15.5), 1.0, 3.8, {
	name= "Great Ocean Highway-Bank",
	heading= 269.57,
	debugPoly= false,
	minZ= 14.44,
	maxZ= 15.99
}, {
	options = {
	{
	event = 'banking:showMeBankMoney',
	icon = "fas fa-money-bill-wave",
	label = "Access Bank Account.",
	},
},
	job = {["all"] = { grade = 0}},
	distance = 2.5
})

exports['bt-target']:AddBoxZone("Route 68-Bank", vector3(1175.67, 2707.55, 37.89), 1.0, 3.8, {
	name= "Route 68-Bank",
	heading= 0.57,
	debugPoly= false,
	minZ= 37.19,
	maxZ= 38.99
}, {
	options = {
	{
	event = 'banking:showMeBankMoney',
	icon = "fas fa-money-bill-wave",
	label = "Access Bank Account.",
	},
},
	job = {["all"] = { grade = 0}},
	distance = 2.5
})

exports['bt-target']:AddBoxZone("Grapeseed-Bank", vector3(1652.55, 4851.05, 41.82), 1.0, 3.8, {
	name= "Grapeseed-Bank",
	heading= 97.14,
	debugPoly= false,
	minZ= 41.69,
	maxZ= 42.99
}, {
	options = {
	{
	event = 'banking:showMeBankMoney',
	icon = "fas fa-money-bill-wave",
	label = "Access Bank Account.",
	},
},
	job = {["all"] = { grade = 0}},
	distance = 2.5
})

exports['bt-target']:AddBoxZone("Blaine County Savings-Bank", vector3(-112.07, 6470.23, 30.82), 1.0, 3.8, {
	name= "Blaine County Savings-Bank",
	heading= 316.09,
	debugPoly= false,
	minZ= 30.69,
	maxZ= 31.99
}, {
	options = {
	{
	event = 'banking:showMeBankMoney',
	icon = "fas fa-money-bill-wave",
	label = "Access Bank Account.",
	},
},
	job = {["all"] = { grade = 0}},
	distance = 2.5
})
-- Banks
RegisterNetEvent('banking:showMeMoney')
AddEventHandler('banking:showMeMoney', function()
    local dict = 'anim@amb@prop_human_atm@interior@male@enter'
    local anim = 'enter'
    local ped = PlayerPedId()
    local time = 2500

    RequestAnimDict(dict)

    while not HasAnimDictLoaded(dict) do
        Citizen.Wait(7)
    end

    TaskPlayAnim(ped, dict, anim, 8.0, 8.0, -1, 0, 0, 0, 0, 0)
    exports['progressBars']:startUI(time, "Inserting card...")
    Citizen.Wait(time)
    ClearPedTasks(ped)
    inMenu = true
    SetNuiFocus(true, true)
    SendNUIMessage({type = 'openBank', color = bankColor})
    TriggerServerEvent('orp:bank:balance')
    atATM = true
    exports['mythic_notify']:SendAlert('inform', 'A reminder that deposits are disabled for your safety and those around you.', 3000)

end)

RegisterNetEvent('banking:showMeBankMoney')
AddEventHandler('banking:showMeBankMoney', function()
    local dict = 'anim@amb@prop_human_atm@interior@male@enter'
    local anim = 'enter'
    local ped = PlayerPedId()
    local time = 2500

    RequestAnimDict(dict)

    while not HasAnimDictLoaded(dict) do
        Citizen.Wait(7)
    end

    TaskPlayAnim(ped, dict, anim, 8.0, 8.0, -1, 0, 0, 0, 0, 0)
    exports['progressBars']:startUI(time, "Inserting card...")
    Citizen.Wait(time)
    ClearPedTasks(ped)
    inMenu = true
    SetNuiFocus(true, true)
    SendNUIMessage({type = 'openBank', color = bankColor})
    TriggerServerEvent('orp:bank:balance')
    atATM = false
end)

RegisterNetEvent('orp:bank:info')
AddEventHandler('orp:bank:info', function(balance)
    local id = PlayerId()
    local playerName = GetPlayerName(id)

    SendNUIMessage({
		type = "updateBalance",
		balance = balance,
        player = playerName,
		})
end)

RegisterNUICallback('deposit', function(data)
    if not atATM then
        TriggerServerEvent('orp:bank:deposit', tonumber(data.amount))
        TriggerServerEvent('orp:bank:balance')
    else
        exports['mythic_notify']:DoHudText('error', 'You cannot deposit money at an ATM')
    end
end)

RegisterNUICallback('withdrawl', function(data)
    TriggerServerEvent('orp:bank:withdraw', tonumber(data.amountw))
    TriggerServerEvent('orp:bank:balance')
end)

RegisterNUICallback('balance', function()
    TriggerServerEvent('orp:bank:balance')
end)

RegisterNetEvent('orp:balance:back')
AddEventHandler('orp:balance:back', function(balance)
    SendNUIMessage({type = 'balanceReturn', bal = balance})
end)

function closePlayersBank()
    local dict = 'anim@amb@prop_human_atm@interior@male@exit'
    local anim = 'exit'
    local ped = PlayerPedId()
    local time = 1800

    RequestAnimDict(dict)

    while not HasAnimDictLoaded(dict) do
        Citizen.Wait(7)
    end

    SetNuiFocus(false, false)
    SendNUIMessage({type = 'closeAll'})
    TaskPlayAnim(ped, dict, anim, 8.0, 8.0, -1, 0, 0, 0, 0, 0)
    exports['progressBars']:startUI(time, "Retrieving card...")
    Citizen.Wait(time)
    ClearPedTasks(ped)
    inMenu = false
end

RegisterNUICallback('transfer', function(data)
    TriggerServerEvent('orp:bank:transfer', data.to, data.amountt)
    TriggerServerEvent('orp:bank:balance')
end)

RegisterNetEvent('orp:bank:notify')
AddEventHandler('orp:bank:notify', function(type, message)
    exports['mythic_notify']:DoLongHudText(type, message)
end)

AddEventHandler('onResourceStop', function(resource)
    inMenu = false
    SetNuiFocus(false, false)
    SendNUIMessage({type = 'closeAll'})
end)

RegisterNUICallback('NUIFocusOff', function()
    closePlayersBank()
end)

function DisplayHelpText(str)
    SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end
