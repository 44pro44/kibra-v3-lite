ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('esx_billing:sendBill')
AddEventHandler('esx_billing:sendBill', function(playerId, sharedAccountName, label, amount)
	local xPlayer = ESX.GetPlayerFromId(source)
	local xTarget = ESX.GetPlayerFromId(playerId)
	amount = ESX.Math.Round(amount)

	if amount > 0 and xTarget then
		TriggerEvent('esx_addonaccount:getSharedAccount', sharedAccountName, function(account)
			if account then
				exports.ghmattimysql:execute('INSERT INTO billing (identifier, sender, target_type, target, label, amount) VALUES (@identifier, @sender, @target_type, @target, @label, @amount)', {
					['@identifier'] = xTarget.identifier,
					['@sender'] = xPlayer.identifier,
					['@target_type'] = 'society',
					['@target'] = sharedAccountName,
					['@label'] = label,
					['@amount'] = amount
				}, function(rowsChanged)
					TriggerClientEvent('okokNotify:Alert', xTarget.source, "Bildiri", 'Yeni Bir Fatura Aldınız', 4000, 'info')
				end)
			else
				exports.ghmattimysql:execute('INSERT INTO billing (identifier, sender, target_type, target, label, amount) VALUES (@identifier, @sender, @target_type, @target, @label, @amount)', {
					['@identifier'] = xTarget.identifier,
					['@sender'] = xPlayer.identifier,
					['@target_type'] = 'player',
					['@target'] = xPlayer.identifier,
					['@label'] = label,
					['@amount'] = amount
				}, function(rowsChanged)
					TriggerClientEvent('okokNotify:Alert', xTarget.source, "Bildiri", 'Yeni Bir Fatura Aldınız', 4000, 'info')

				end)
			end
		end)
	end
end)

ESX.RegisterServerCallback('esx_billing:getBills', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	exports.ghmattimysql:execute('SELECT amount, id, label FROM billing WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier
	}, function(result)
		cb(result)
	end)
end)

ESX.RegisterServerCallback('esx_billing:getTargetBills', function(source, cb, target)
	local xPlayer = ESX.GetPlayerFromId(target)

	if xPlayer then
		exports.ghmattimysql:execute('SELECT amount, id, label FROM billing WHERE identifier = @identifier', {
			['@identifier'] = xPlayer.identifier
		}, function(result)
			cb(result)
		end)
	else
		cb({})
	end
end)

ESX.RegisterServerCallback('esx_billing:payBill', function(source, cb, billId)
	local xPlayer = ESX.GetPlayerFromId(source)

	exports.ghmattimysql:execute('SELECT sender, target_type, target, amount FROM billing WHERE id = @id', {
		['@id'] = billId
	}, function(result)
		if result[1] then
			local amount = result[1].amount
			local xTarget = ESX.GetPlayerFromIdentifier(result[1].sender)

			if result[1].target_type == 'player' then
				if xTarget then
					if xPlayer.getMoney() >= amount then
						exports.ghmattimysql:execute('DELETE FROM billing WHERE id = @id', {
							['@id'] = billId
						}, function(rowsChanged)
							if rowsChanged == 1 then
								xPlayer.removeMoney(amount)
								xTarget.addMoney(amount)

								TriggerClientEvent('okokNotify:Alert', xPlayer.source, "Fatura Ödendi", '$'..amount.."'lık faturanız ödendi.", 4000, 'success')
								TriggerClientEvent('okokNotify:Alert', xTarget.source, "Kazancınız", 'Kestiğiniz faturadan $'..amount..' pay kazandınız', 4000, 'success')
							end

							cb()
						end)
					elseif xPlayer.getAccount('bank').money >= amount then
						exports.ghmattimysql:execute('DELETE FROM billing WHERE id = @id', {
							['@id'] = billId
						}, function(rowsChanged)
							if rowsChanged == 1 then
								xPlayer.removeAccountMoney('bank', amount)
								xTarget.addAccountMoney('bank', amount)

								TriggerClientEvent('okokNotify:Alert', xPlayer.source, "Fatura Ödendi", '$'..amount.."'lık faturanız ödendi.", 4000, 'success')

								TriggerClientEvent('okokNotify:Alert', xTarget.source, "Kazancınız", 'Kestiğiniz faturadan $'..amount..' pay kazandınız', 4000, 'success')

							end

							cb()
						end)
					else
						TriggerClientEvent('okokNotify:Alert', xTarget.source, "Geçersiz", "Kişinin faturayı ödeyecek parası yok!", 4000, 'error')


						TriggerClientEvent('okokNotify:Alert', xPlayer.source, "Geçersiz", "Faturayı ödeyecek kadar paranız yok!", 4000, 'error')
						cb()
					end
				else
					TriggerClientEvent('okokNotify:Alert', xPlayer.source, "Geçersiz", "Oyuncu şehirde değil!", 4000, 'error')
					cb()
				end
			else
				TriggerEvent('esx_addonaccount:getSharedAccount', result[1].target, function(account)
					if xPlayer.getMoney() >= amount then
						exports.ghmattimysql:execute('DELETE FROM billing WHERE id = @id', {
							['@id'] = billId
						}, function(rowsChanged)
							if rowsChanged == 1 then
								xPlayer.removeMoney(amount)
								account.addMoney(amount)

								xPlayer.showNotification(_U('paid_invoice', ESX.Math.GroupDigits(amount)))
								if xTarget then
									xTarget.showNotification(_U('received_payment', ESX.Math.GroupDigits(amount)))
								end
							end

							cb()
						end)
					elseif xPlayer.getAccount('bank').money >= amount then
						exports.ghmattimysql:execute('DELETE FROM billing WHERE id = @id', {
							['@id'] = billId
						}, function(rowsChanged)
							if rowsChanged == 1 then
								xPlayer.removeAccountMoney('bank', amount)
								account.addMoney(amount)
								TriggerClientEvent('okokNotify:Alert', xPlayer.source, "Bildiri", '$'..amount.."'lık faturanız ödendi", 4000, 'success')


								if xTarget then
									TriggerClientEvent('okokNotify:Alert', xPlayer.source, "Bildiri", 'Kestiğiniz faturadan $'..amount..'lık pay aldınız', 4000, 'success')
								end
							end

							cb()
						end)
					else
						if xTarget then
							TriggerClientEvent('okokNotify:Alert', xTarget.source, "Geçersiz", "Kişinin faturayı ödeyecek parası yok!", 4000, 'error')
						end

						TriggerClientEvent('okokNotify:Alert', xPlayer.source, "Geçersiz", "Bu faturayı ödeyecek kadar paranız yok!", 4000, 'error')
						cb()
					end
				end)
			end
		end
	end)
end)
