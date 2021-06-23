RegisterServerEvent('orp:bank:deposit')
AddEventHandler('orp:bank:deposit', function(depositAmount, depositDate)
    local _depositAmount = tonumber(depositAmount)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local _identifier = xPlayer.getIdentifier()
	if depositAmount == nil or depositAmount <= 0 or depositAmount > xPlayer.getMoney() then
		TriggerClientEvent('orp:bank:notify', _source, "error", "Invalid Amount")
	else
		xPlayer.removeMoney(depositAmount)
		xPlayer.addAccountMoney('bank', tonumber(depositAmount))
		TriggerClientEvent('orp:bank:notify', _source, "success", "You successfully deposit $" .. depositAmount)
		exports.ghmattimysql:execute("INSERT INTO transactions (`identifier`, `type`, `amount`, `date`) VALUES (@identifier, @type, @amount, @date);",
		{
			identifier = _identifier,
			type = "Deposit",
			amount = _depositAmount,
			date = depositDate

		}, function()
	end)
	end
end)

RegisterServerEvent('orp:bank:withdraw')
AddEventHandler('orp:bank:withdraw', function(_withdrawAmount, withdrawDate)
    local _withdrawAmount = tonumber(_withdrawAmount)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local _identifier = xPlayer.getIdentifier()
	local min = 0
	_withdrawAmount = tonumber(_withdrawAmount)
	min = xPlayer.getAccount('bank').money
	if _withdrawAmount == nil or _withdrawAmount <= 0 or _withdrawAmount > min then
		TriggerClientEvent('orp:bank:notify', _source, "error", "Invalid Amount")
	else
		xPlayer.removeAccountMoney('bank', _withdrawAmount)
		xPlayer.addMoney(_withdrawAmount)
		TriggerClientEvent('orp:bank:notify', _source, "success", "You successfully withdrew $" .. _withdrawAmount)
		exports.ghmattimysql:execute("INSERT INTO transactions (`identifier`, `type`, `amount`, `date`) VALUES (@identifier, @type, @amount, @date);", 
		{
			identifier = _identifier,
			type = "Withdraw",
			amount = _withdrawAmount,
			date = withdrawDate

		}, function()
	end)
	end
end)

RegisterServerEvent('orp:bank:balance')
AddEventHandler('orp:bank:balance', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local money = xPlayer.getAccount('bank').money
    local name = xPlayer.getName()
	balance = xPlayer.getAccount('bank').money
	TriggerClientEvent('orp:bank:info', _source, balance)
end)

RegisterServerEvent('orp:bank:transfer')
AddEventHandler('orp:bank:transfer', function(targetName,transferDate, transferAmount)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local _identifier = xPlayer.getIdentifier()
    local target = ESX.GetPlayerFromId(transferName)
	local amount = transferAmount
	local balance = 0

	if(xTarget == nil or xTarget == -1) then
		TriggerClientEvent('orp:bank:notify', _source, "error", "Recipient not found")
	else
		balance = xPlayer.getAccount('bank').money
		zbalance = xTarget.getAccount('bank').money
		
		if tonumber(_source) == tonumber(transferName) then
			TriggerClientEvent('orp:bank:notify', _source, "error", "You cannot transfer money to yourself")
		else
			if balance <= 0 or balance < tonumber(amount) or tonumber(amount) <= 0 then
				TriggerClientEvent('orp:bank:notify', _source, "error", "You don't have enough money for this transfer")
			else
				xPlayer.removeAccountMoney('bank', tonumber(amount))
				xTarget.addAccountMoney('bank', tonumber(amount))
				TriggerClientEvent('orp:bank:notify', _source, "success", "You successfully transfer $" .. amount)
				local targetName = target.getName();
				TriggerClientEvent('orp:bank:notify', targetName, "success", "You have just received $" .. amount .. ' via transfer')
				exports.ghmattimysql:execute("INSERT INTO transactions (`identifier`, `type`, `amount`, `date`) VALUES (@identifier, @type, @amount, @date);", 
				{
					identifier = _identifier,
					type = "Transfer to " .. targetName .. "",
					amount = transferAmount,
					date = transferDate
				}, function()
			end)
			end
		end
	end
end)

ESX.RegisterServerCallback('banking:get:transactions', function(source, cb)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local _identifier = xPlayer.getIdentifier()

    exports.ghmattimysql:execute("SELECT * FROM transactions WHERE identifier = @identifier ORDER BY id DESC" , 
        {
            ['@identifier'] = _identifier 
        }, function(transactions)
        cb(transactions)
    end)
end)

ESX.RegisterServerCallback('banking:canRob', function(source, cb)
    local xPlayers = ESX.GetPlayers()
    local cops = 0
    for i = 1, #xPlayers do
        if ESX.GetPlayerFromId(xPlayers[i]).job.name == 'police' then
            cops = cops + 1
        end
    end
    if cops >= 2 then
        if Config['Item']['Required'] then
            local xPlayer = ESX.GetPlayerFromId(source)
            if xPlayer.getInventoryItem(Config.Item.Name).count > 0 then
                if Config['Item']['Remove'] then
                    xPlayer.removeInventoryItem(Config.Item.Name, 1)
                end
                cb({true})
            else
                cb({false, (Strings['Item_Required']):format(Config['Item']['Label'])})
            end
        else
            cb({true})
        end
    else
        cb({false, 'Not enough cops online'})
    end
end)

RegisterServerEvent('banking:police')
AddEventHandler('banking:police', function(coords)
    local xPlayers = ESX['GetPlayers']()
    for i = 1, #xPlayers do
        if ESX['GetPlayerFromId'](xPlayers[i])['job']['name'] == 'police' then
            TriggerClientEvent('banking:alert', xPlayers[i], coords)
        end
    end
end)

RegisterServerEvent('banking:getMoney')
AddEventHandler('banking:getMoney', function()
    local src = source
    local random = math.random(Config['Cash']['Min'], Config['Cash']['Max'])
    ESX['GetPlayerFromId'](src)['addMoney'](random)
    TriggerClientEvent('mythic_notify:client:SendAlert', src, { type = 'inform', text = 'You stole $' ..random.. ' from the ATM', 6500 })
end)