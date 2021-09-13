function CreateExtendedPlayer(playerId, identifier, group, accounts, inventory, weight, job, loadout, name, coords)
	local self = {}

	self.accounts = accounts
	self.coords = coords
	self.group = group
	self.identifier = identifier
	self.inventory = inventory
	self.job = job
	self.loadout = loadout
	self.name = name
	self.playerId = playerId
	self.source = playerId
	self.variables = {}
	self.src = source
	self.weight = weight
	self.maxWeight = Config.MaxWeight
	print(self.group)
	ExecuteCommand(('add_principal identifier.license:%s group.%s'):format(self.identifier, self.group))

	self.triggerEvent = function(eventName, ...)
		TriggerClientEvent(eventName, self.source, ...)
	end

	self.updateData = function()
		TriggerClientEvent("qb_inventory:update",self.source,self.inventory)
	end

	self.setCoords = function(coords)
		self.updateCoords(coords)
		self.triggerEvent('esx:teleport', coords)
	end

	self.updateCoords = function(coords)
		self.coords = {x = ESX.Math.Round(coords.x, 1), y = ESX.Math.Round(coords.y, 1), z = ESX.Math.Round(coords.z, 1), heading = ESX.Math.Round(coords.heading or 0.0, 1)}
	end

	self.getCoords = function(vector)
		if vector then
			return vector3(self.coords.x, self.coords.y, self.coords.z)
		else
			return self.coords
		end
	end

	self.kick = function(reason)
		DropPlayer(self.source, reason)
	end

	self.setMoney = function(money)
		money = ESX.Math.Round(money)
		self.setAccountMoney('money', money)
	end

	self.getMoney = function()
		--return self.getAccount('money').money
		return self.getQuantity('cash')
	end

	self.addMoney = function(money)
		money = ESX.Math.Round(money)
	--	self.addAccountMoney('money', money)
		self.addInventoryItem('cash', money)
		TriggerEvent('inventory:client:ItemBox', source, ESX.GetItems()['cash'],'add', money)
	end

	self.removeMoney = function(money)
		money = ESX.Math.Round(money)
		--self.removeAccountMoney('money', money)
		self.removeInventoryItem('cash', money)
		TriggerEvent('inventory:client:ItemBox', source, ESX.Items['cash'],'remove', money)
	end

	self.getIdentifier = function()
		return self.identifier
	end

	self.getQuantity = function(item)
        if item ~= nil then
            local inv = self.inventory
            local count = 0
            for k,v in pairs(inv) do
                if v.name == item then
                    count = count + v.count
                end
            end
            return count
        end
    end

	self.setGroup = function(newGroup)
		ExecuteCommand(('remove_principal identifier.license:%s group.%s'):format(self.identifier, self.group))
		self.group = newGroup
		ExecuteCommand(('add_principal identifier.license:%s group.%s'):format(self.identifier, self.group))
	end

	self.getGroup = function()
		return self.group
	end

	self.set = function(k, v)
		self.variables[k] = v
	end

	self.get = function(k)
		return self.variables[k]
	end

	self.getAccounts = function(minimal)
		if minimal then
			local minimalAccounts = {}

			for k,v in ipairs(self.accounts) do
				minimalAccounts[v.name] = v.money
			end

			return minimalAccounts
		else
			return self.accounts
		end
	end

	self.getAccount = function(account)
		for k,v in ipairs(self.accounts) do
			if v.name == account then
				return v
			end
		end
	end

	self.getInventory2 = function()
		return self.inventory

	end

	self.getInventory = function(minimal)
		local ItemsJson = {}
		local items = self.inventory
		if items ~= nil and next(items) ~= nil then
			for slot, item in pairs(items) do
				if items[slot] ~= nil then
					table.insert(ItemsJson, {
						name = item.name,
						count = item.count,
						info = item.info,
						type = item.type,
						slot = slot,
					})
				end
			end
		end
		return ItemsJson
	end

	self.getJob = function()
		return self.job
	end

	self.getLoadout = function(minimal)
		if minimal then
			local minimalLoadout = {}

			for k,v in ipairs(self.loadout) do
				minimalLoadout[v.name] = {ammo = v.ammo}
				if v.tintIndex > 0 then minimalLoadout[v.name].tintIndex = v.tintIndex end

				if #v.components > 0 then
					local components = {}

					for k2,component in ipairs(v.components) do
						if component ~= 'clip_default' then
							table.insert(components, component)
						end
					end

					if #components > 0 then
						minimalLoadout[v.name].components = components
					end
				end
			end

			return minimalLoadout
		else
			return self.loadout
		end
	end

	self.getName = function()
		return self.name
	end

	self.setName = function(newName)
		self.name = newName
	end

	self.setAccountMoney = function(accountName, money)
		if money >= 0 then
			local account = self.getAccount(accountName)

			if account then
				local prevMoney = account.money
				local newMoney = ESX.Math.Round(money)
				account.money = newMoney

				self.triggerEvent('esx:setAccountMoney', account)
			end
		end
	end

	self.addAccountMoney = function(accountName, money)
		if money > 0 then
			local account = self.getAccount(accountName)

			if account then
				local newMoney = account.money + ESX.Math.Round(money)
				account.money = newMoney

				self.triggerEvent('esx:setAccountMoney', account)
			end
		end
	end

	self.removeAccountMoney = function(accountName, money)
		if money > 0 then
			local account = self.getAccount(accountName)

			if account then
				local newMoney = account.money - ESX.Math.Round(money)
				account.money = newMoney

				self.triggerEvent('esx:setAccountMoney', account)
			end
		end
	end

	self.getInventoryItem = function(name)
		for k,v in ipairs(self.inventory) do
			if v.name == name then
				return v
			end
		end

		return
	end

	-- self.addInventoryItem = function(name, count)
	-- 	local item = self.getInventoryItem(name)

	-- 	if item then
	-- 		count = ESX.Math.Round(count)
	-- 		item.count = item.count + count
	-- 		self.weight = self.weight + (item.weight * count)

	-- 		TriggerEvent('esx:onAddInventoryItem', self.source, item.name, item.count)
	-- 		self.triggerEvent('esx:addInventoryItem', item.name, item.count)
	-- 	end
	-- end

	self.addInventoryItem = function(item, amount, slot, info)
		local totalWeight = ESX.GetTotalWeight(self.inventory)
		local itemInfo = ESX.Items[tostring(item)]
		if itemInfo == nil then TriggerClientEvent('okokNotify:Alert',self.source, "1000RP - Envanter", "Üzerinize almaya çalıştığınız item bulunamadı. Sunucu Sahibi ile iletişime geçin", 2000, 'error')
			
			return end

		local amount = tonumber(amount)
		local slot = tonumber(slot) ~= nil and tonumber(slot) or ESX.GetFirstSlotByItem(self.inventory, item)
		if itemInfo.type == "weapon" and info == nil then
			info = {
				serie = tostring(RandomInt(2) .. RandomStr(3) .. RandomInt(1) .. RandomStr(2) .. RandomInt(3) .. RandomStr(4)),
			}
		end
		if (totalWeight + (itemInfo.weight * amount)) <= self.maxWeight then
			if (slot ~= nil and self.inventory[slot] ~= nil) and (self.inventory[slot].name:lower() == item:lower()) and (itemInfo.type == "item" and not itemInfo.unique) then
				self.inventory[slot].count = self.inventory[slot].count + amount
				--TriggerEvent('esx:onAddInventoryItem', self.source, item, amount)
			--TriggerClientEvent('esx:AddInventoryItem', self.source, item, amount)
			self.weight = self.weight + (itemInfo.weight * amount)
			self.updateData()
				--self.Functions.UpdatePlayerData()
				--TriggerEvent("qb-log:server:sendLog", self.PlayerData.citizenid, "itemadded", {name= self.inventory[slot].name, amount=amount, slot=slot, newamount=self.inventory[slot].count, reason="unkown"})
				--TriggerEvent("qb-log:server:CreateLog", "playerinventory", "AddItem", "green", "**"..GetPlayerName(self.PlayerData.source) .. " (citizenid: "..self.PlayerData.citizenid.." | id: "..self.PlayerData.source..")** get item: [slot:" ..slot.."], itemname: " .. self.inventory[slot].name .. ", added amount: " .. amount ..", new total amount: ".. self.inventory[slot].count)
				--TriggerClientEvent('QBCore:Notify', self.PlayerData.source, itemInfo.label.. " toegevoegd!", "success")
				return true
			elseif (not itemInfo.unique and slot or slot ~= nil and self.inventory[slot] == nil) then
				self.inventory[slot] = {name = itemInfo.name, count = amount, info = info ~= nil and info or "", label = itemInfo.label, description = itemInfo.description ~= nil and itemInfo.description or "", weight = itemInfo.weight, type = itemInfo.type, unique = itemInfo.unique, usable = ESX.UsableItemsCallbacks[itemInfo.name] ~= nil, image = itemInfo.image, shouldClose = itemInfo.shouldClose, slot = slot, combinable = itemInfo.combinable}
				TriggerEvent('esx:onAddInventoryItem', self.source, item, amount)
				TriggerClientEvent('esx:AddInventoryItem', self.source, item, amount)
				self.weight = self.weight + (itemInfo.weight * amount)
				self.updateData()
				--self.Functions.UpdatePlayerData()
				--TriggerEvent("qb-log:server:sendLog", self.PlayerData.citizenid, "itemadded", {name=self.inventory[slot].name, amount=amount, slot=slot, newamount=self.inventory[slot].count, reason="unkown"})
				--TriggerEvent("qb-log:server:CreateLog", "playerinventory", "AddItem", "green", "**"..GetPlayerName(self.PlayerData.source) .. " (citizenid: "..self.PlayerData.citizenid.." | id: "..self.PlayerData.source..")** get item: [slot:" ..slot.."], itemname: " .. self.inventory[slot].name .. ", added amount: " .. amount ..", new total amount: ".. self.inventory[slot].count)
				--TriggerClientEvent('QBCore:Notify', self.PlayerData.source, itemInfo.label.. " toegevoegd!", "success")
				return true
			elseif (itemInfo.unique) or (not slot or slot == nil) or (itemInfo.type == "weapon") then
				for i = 1, 41, 1 do
					if self.inventory[i] == nil then
						self.inventory[i] = {name = itemInfo.name, count = amount, info = info ~= nil and info or "", label = itemInfo.label, description = itemInfo.description ~= nil and itemInfo.description or "", weight = itemInfo.weight, type = itemInfo.type, unique = itemInfo.unique, usable = ESX.UsableItemsCallbacks[itemInfo.name] ~= nil, image = itemInfo.image, shouldClose = itemInfo.shouldClose, slot = i, combinable = itemInfo.combinable}
						--TriggerEvent('esx:onAddInventoryItem', self.source, item, amount)
						--TriggerClientEvent('esx:AddInventoryItem', self.source, item, amount)
						self.weight = self.weight + (itemInfo.weight * amount)
						self.updateData()
						--self.Functions.UpdatePlayerData()
						--TriggerEvent("qb-log:server:sendLog", self.PlayerData.citizenid, "itemadded", {name=self.inventory[i].name, amount=amount, slot=i, newamount=self.inventory[i].count, reason="unkown"})
						--TriggerEvent("qb-log:server:CreateLog", "playerinventory", "AddItem", "green", "**"..GetPlayerName(self.PlayerData.source) .. " (citizenid: "..self.PlayerData.citizenid.." | id: "..self.PlayerData.source..")** get item: [slot:" ..i.."], itemname: " .. self.inventory[i].name .. ", added amount: " .. amount ..", new total amount: ".. self.inventory[i].count)
						--TriggerClientEvent('QBCore:Notify', self.PlayerData.source, itemInfo.label.. " toegevoegd!", "success")
						return true
					end
				end
			end
		else
			TriggerClientEvent('okokNotify:Alert',self.source, "1000RP - Envanter", "Maksimum Ağırlığa ulaştınız!"..self.maxWeight..' kg', 5000, 'error')


		end
		return false
	end

	self.removeInventoryItem = function(item, amount, slot)
		local itemInfo = ESX.Items[item:lower()]
		local amount = tonumber(amount)
		local slot = tonumber(slot)
		if slot ~= nil then
			if self.inventory[slot].count > amount then
				self.inventory[slot].count = self.inventory[slot].count - amount
				self.updateData()
				--TriggerEvent("qb-log:server:sendLog", self..PlayerData.citizenid, "itemremoved", {name=self.PlayerData.inventory[slot].name, amount=amount, slot=slot, newamount=self.PlayerData.inventory[slot].amount, reason="unkown"})
				--TriggerEvent("qb-log:server:CreateLog", "playerinventory", "RemoveItem", "red", "**"..GetPlayerName(self.source) .. " (citizenid: "..self..PlayerData.citizenid.." | id: "..self.source..")** lost item: [slot:" ..slot.."], itemname: " .. self.PlayerData.inventory[slot].name .. ", removed amount: " .. amount ..", new total amount: ".. self.PlayerData.inventory[slot].amount)
				--TriggerClientEvent('QBCore:Notify', self.source, itemInfo["label"].. " verwijderd!", "error")
				return true
			else
				self.inventory[slot] = nil
				self.updateData()
				--TriggerEvent("qb-log:server:sendLog", self..PlayerData.citizenid, "itemremoved", {name=item, amount=amount, slot=slot, newamount=0, reason="unkown"})
				--TriggerEvent("qb-log:server:CreateLog", "playerinventory", "RemoveItem", "red", "**"..GetPlayerName(self.source) .. " (citizenid: "..self..PlayerData.citizenid.." | id: "..self.source..")** lost item: [slot:" ..slot.."], itemname: " .. item .. ", removed amount: " .. amount ..", item removed")
				--TriggerClientEvent('QBCore:Notify', self.source, itemInfo["label"].. " verwijderd!", "error")
				return true
			end
		else
			local slots = ESX.GetSlotsByItem(self.inventory, item)
			local amountToRemove = amount
			for _, itemFor in pairs(slots) do
				if itemFor ~= nil then
					if itemFor.count - amount < 0 then
						local tempCount = self.inventory[itemFor.slot].count
						self.inventory[itemFor.slot] = nil
						amount = amount - tempCount
						self.updateData()
					elseif itemFor.count - amount > 0 then
						self.inventory[itemFor.slot].count = self.inventory[itemFor.slot].count - amount
						self.updateData()
						return true
					elseif itemFor.count - amount == 0 then
						self.inventory[itemFor.slot] = nil
						self.updateData()
						return true
					else
						print("missing condition: ".. self.identifier)
					end
					
				end
			end
			
		end
		return false
	end

	self.setInventoryItem = function(name, count)
		self.inventory = {}
		self.updateData()
	end

	self.getWeight = function()
		return self.weight
	end

	self.getMaxWeight = function()
		return self.maxWeight
	end

	self.canCarryItem = function(name, count)
		local currentWeight, itemWeight = self.weight, ESX.Items[name].weight
		local newWeight = currentWeight + (itemWeight * count)

		return newWeight <= self.maxWeight
	end

	self.canSwapItem = function(firstItem, firstItemCount, testItem, testItemCount)
		local firstItemObject = self.getInventoryItem(firstItem)
		local testItemObject = self.getInventoryItem(testItem)

		if firstItemObject.count >= firstItemCount then
			local weightWithoutFirstItem = ESX.Math.Round(self.weight - (firstItemObject.weight * firstItemCount))
			local weightWithTestItem = ESX.Math.Round(weightWithoutFirstItem + (testItemObject.weight * testItemCount))

			return weightWithTestItem <= self.maxWeight
		end

		return false
	end

	self.setMaxWeight = function(newWeight)
		self.maxWeight = newWeight
		self.triggerEvent('esx:setMaxWeight', self.maxWeight)
	end

	self.setJob = function(job, grade)
		grade = tostring(grade)
		local lastJob = json.decode(json.encode(self.job))

		if ESX.DoesJobExist(job, grade) then
			local jobObject, gradeObject = ESX.Jobs[job], ESX.Jobs[job].grades[grade]

			self.job.id    = jobObject.id
			self.job.name  = jobObject.name
			self.job.label = jobObject.label

			self.job.grade        = tonumber(grade)
			self.job.grade_name   = gradeObject.name
			self.job.grade_label  = gradeObject.label
			self.job.grade_salary = gradeObject.salary

			if gradeObject.skin_male then
				self.job.skin_male = json.decode(gradeObject.skin_male)
			else
				self.job.skin_male = {}
			end

			if gradeObject.skin_female then
				self.job.skin_female = json.decode(gradeObject.skin_female)
			else
				self.job.skin_female = {}
			end

			TriggerEvent('esx:setJob', self.source, self.job, lastJob)
			self.triggerEvent('esx:setJob', self.job)
		else
			print(('[es_extended] [^3WARNING^7] Ignoring invalid .setJob() usage for "%s"'):format(self.identifier))
		end
	end

	self.addWeapon = function(weaponName, ammo)
		if not self.hasWeapon(weaponName) then
			local weaponLabel = ESX.GetWeaponLabel(weaponName)

			table.insert(self.loadout, {
				name = weaponName,
				ammo = ammo,
				label = weaponLabel,
				components = {},
				tintIndex = 0
			})

			self.triggerEvent('esx:addWeapon', weaponName, ammo)
			self.triggerEvent('esx:addInventoryItem', weaponLabel, false, true)
		end
	end

	self.addWeaponComponent = function(weaponName, weaponComponent)
		local loadoutNum, weapon = self.getWeapon(weaponName)

		if weapon then
			local component = ESX.GetWeaponComponent(weaponName, weaponComponent)

			if component then
				if not self.hasWeaponComponent(weaponName, weaponComponent) then
					table.insert(self.loadout[loadoutNum].components, weaponComponent)
					self.triggerEvent('esx:addWeaponComponent', weaponName, weaponComponent)
					self.triggerEvent('esx:addInventoryItem', component.label, false, true)
				end
			end
		end
	end

	self.addWeaponAmmo = function(weaponName, ammoCount)
		local loadoutNum, weapon = self.getWeapon(weaponName)

		if weapon then
			weapon.ammo = weapon.ammo + ammoCount
			self.triggerEvent('esx:setWeaponAmmo', weaponName, weapon.ammo)
		end
	end

	self.updateWeaponAmmo = function(weaponName, ammoCount)
		local loadoutNum, weapon = self.getWeapon(weaponName)

		if weapon then
			if ammoCount < weapon.ammo then
				weapon.ammo = ammoCount
			end
		end
	end

	self.setWeaponTint = function(weaponName, weaponTintIndex)
		local loadoutNum, weapon = self.getWeapon(weaponName)

		if weapon then
			local weaponNum, weaponObject = ESX.GetWeapon(weaponName)

			if weaponObject.tints and weaponObject.tints[weaponTintIndex] then
				self.loadout[loadoutNum].tintIndex = weaponTintIndex
				self.triggerEvent('esx:setWeaponTint', weaponName, weaponTintIndex)
				self.triggerEvent('esx:addInventoryItem', weaponObject.tints[weaponTintIndex], false, true)
			end
		end
	end

	self.getWeaponTint = function(weaponName)
		local loadoutNum, weapon = self.getWeapon(weaponName)

		if weapon then
			return weapon.tintIndex
		end

		return 0
	end

	self.removeWeapon = function(weaponName)
		local weaponLabel

		for k,v in ipairs(self.loadout) do
			if v.name == weaponName then
				weaponLabel = v.label

				for k2,v2 in ipairs(v.components) do
					self.removeWeaponComponent(weaponName, v2)
				end

				table.remove(self.loadout, k)
				break
			end
		end

		if weaponLabel then
			self.triggerEvent('esx:removeWeapon', weaponName)
			self.triggerEvent('esx:removeInventoryItem', weaponLabel, false, true)
		end
	end

	self.removeWeaponComponent = function(weaponName, weaponComponent)
		local loadoutNum, weapon = self.getWeapon(weaponName)

		if weapon then
			local component = ESX.GetWeaponComponent(weaponName, weaponComponent)

			if component then
				if self.hasWeaponComponent(weaponName, weaponComponent) then
					for k,v in ipairs(self.loadout[loadoutNum].components) do
						if v == weaponComponent then
							table.remove(self.loadout[loadoutNum].components, k)
							break
						end
					end

					self.triggerEvent('esx:removeWeaponComponent', weaponName, weaponComponent)
					self.triggerEvent('esx:removeInventoryItem', component.label, false, true)
				end
			end
		end
	end

	self.removeWeaponAmmo = function(weaponName, ammoCount)
		local loadoutNum, weapon = self.getWeapon(weaponName)

		if weapon then
			weapon.ammo = weapon.ammo - ammoCount
			self.triggerEvent('esx:setWeaponAmmo', weaponName, weapon.ammo)
		end
	end

	self.hasWeaponComponent = function(weaponName, weaponComponent)
		local loadoutNum, weapon = self.getWeapon(weaponName)

		if weapon then
			for k,v in ipairs(weapon.components) do
				if v == weaponComponent then
					return true
				end
			end

			return false
		else
			return false
		end
	end

	self.hasWeapon = function(weaponName)
		for k,v in ipairs(self.loadout) do
			if v.name == weaponName then
				return true
			end
		end

		return false
	end

	self.getWeapon = function(weaponName)
		for k,v in ipairs(self.loadout) do
			if v.name == weaponName then
				return k, v
			end
		end

		return
	end

	self.GetItemByName = function(item)
		local item = tostring(item):lower()
		local slot = ESX.GetFirstSlotByItem(self.inventory, item)
		if slot ~= nil then
			return self.inventory[slot]
		end
		return nil
	end

	self.SetInventory = function(items)
		self.inventory = items
		self.updateData()
	end

	self.GetItemBySlot = function(slot)
		local slot = tonumber(slot)
		if self.inventory[slot] ~= nil then
			return self.inventory[slot]
		end
		return nil
	end

	self.showNotification = function(msg)
		self.triggerEvent('esx:showNotification', msg)
	end

	self.showHelpNotification = function(msg, thisFrame, beep, duration)
		self.triggerEvent('esx:showHelpNotification', msg, thisFrame, beep, duration)
	end

	return self
end


local StringCharset = {}
local NumberCharset = {}

for i = 48,  57 do table.insert(NumberCharset, string.char(i)) end
for i = 65,  90 do table.insert(StringCharset, string.char(i)) end
for i = 97, 122 do table.insert(StringCharset, string.char(i)) end

RandomStr = function(length)
	if length > 0 then
		return RandomStr(length-1) .. StringCharset[math.random(1, #StringCharset)]
	else
		return ''
	end
end
RandomInt = function(length)
	if length > 0 then
		return RandomInt(length-1) .. NumberCharset[math.random(1, #NumberCharset)]
	else
		return ''
	end
end

SplitStr = function(str, delimiter)
	local result = { }
	local from  = 1
	local delim_from, delim_to = string.find( str, delimiter, from  )
	while delim_from do
		table.insert( result, string.sub( str, from , delim_from-1 ) )
		from  = delim_to + 1
		delim_from, delim_to = string.find( str, delimiter, from  )
	end
	table.insert( result, string.sub( str, from  ) )
	return result
end





ESX.GetTotalWeight = function(items)
	local weight = 0
	if items ~= nil then
		for slot, item in pairs(items) do
			weight = weight + (item.weight * item.count)
		end
	end
	return tonumber(weight)
end

-- ESX.GetSlotsByItem = function(items, itemName)
-- 	local slotsFound = {}
-- 	if items ~= nil then
-- 		for slot, item in pairs(items) do
-- 			if item.name:lower() == itemName:lower() then
-- 				table.insert(slotsFound, slot)
-- 			end
-- 		end
-- 	end
-- 	return slotsFound
-- end

ESX.GetSlotsByItem = function(items, itemName)
    local slotsFound = {}
    if items ~= nil then
        for k, v in pairs(items) do
            if v.name:lower() == itemName:lower() then
				table.insert(slotsFound, v)
            end
		end
    end
	return slotsFound
end

ESX.GetFirstSlotByItem = function(items, itemName)
	if items ~= nil then
		for slot, item in pairs(items) do
			if item.name:lower() == itemName:lower() then
				return tonumber(slot)
			end
		end
	end
	return nil
end



ESX.EscapeSqli = function(str)
    local replacements = { ['"'] = '\\"', ["'"] = "\\'" }
    return str:gsub( "['\"]", replacements ) -- or string.gsub( source, "['\"]", replacements )
end