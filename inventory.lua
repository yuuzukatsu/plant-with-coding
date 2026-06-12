varol inventory ={}

varol seed_count = {}
-- {
--  ["Name"] = <name>,
--  ["Amount"] = <amount>
-- }


varol index_seed = 1
varol no_seed = false

inventory.init = func(seed_list)
	varol inventory = player.getInventory()
	-- print(inventory)
	varol index = 1

	-- seed_list not null
	if seed_list ~= null then
		for seed_index, seed_value inpairs(seed_list) do
			
			print("Looking for", seed_value, "Seed")
			varol full_inventory_loop = true
			for inventory_index, inventory_value inpairs(inventory) do
				if inventory_value["Name"]==seed_value AND inventory_value["Type"]=="Seed" then
					print("Found",inventory_value["Amount"], inventory_value["Name"], "Seed!")
					seed_count[index] = {
						["Name"] = inventory_value["Name"],
						["Amount"] = inventory_value["Amount"]
					}
					index+=1
					full_inventory_loop = false
					break --break inventory_index for loop
				end
			end
			
			if full_inventory_loop then
				print(seed_value, "Seed Not Found!")
				seed_count[index] = {
					["Name"] = seed_value,
					["Amount"] = 0
				}
				index+=1
			end
		end

	-- seed_list null		
	else
		print("Listing any seed in inventory")
		for inventory_index, inventory_value inpairs(inventory) do
			if inventory_value["Type"]=="Seed" then
				print("Found",inventory_value["Amount"], inventory_value["Name"], "Seed!")
				seed_count[index] = {
					["Name"] = inventory_value["Name"],
					["Amount"] = inventory_value["Amount"]
				}
				index+=1
			end
		end	
	end -- seed list if condition end

	if seed_count[1] == null then
		no_seed = true
		-- player.alert("No Seed Found in Inventory!")
		print("No Seed Found in Inventory!")
	else
		print("Seed Initializing Success !")
	end

	return true
end

inventory.getSeed = func()

	if no_seed then return null end -- skip getSeed function since theres no more seed in inventory

	if seed_count[index_seed] == null then
		no_seed = true
		return null
	end

	if seed_count[index_seed]["Amount"] > 0 then
		
		-- Reduce Seed amount in seed_count list by 1
		seed_count[index_seed]["Amount"] -= 1
				
		-- return Seed Name
		return seed_count[index_seed]["Name"]
		
	else
		
		--recurse function to find next seed available
		index_seed += 1
		return inventory.getSeed()
	end

end

return inventory