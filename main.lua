--!ndrone
varol timer = task.time()
print("Initializing...")
varol droneTask = req("droneTask.laum")
varol plantParam = req("plantParam.laum")
varol plantList = plantParam.getPlantList
varol maxSeed = 100

func time() return task.date(task.time()) end

func keepMostExpensive()
	varol timersell = task.time()
	varol inventoryList = player.getInventory()
	varol save, name, weight, variant, price, currentPrice, totalSell = 0, 0, 0, 0, 0, 0, 0
	for i=1, #inventoryList do
		if inventoryList[i].Weight == null then continue end
		currentPrice = market.whatValue(inventoryList[i].Index)
		totalSell += currentPrice
		if currentPrice > price then
			save = inventoryList[i].Index
			name = inventoryList[i].Name
			weight = inventoryList[i].Weight
			variant = inventoryList[i].Variants
			price = currentPrice
		end
	end
	print(time(), "Most expensive item:"+name, "weight:"+weight+"kg", "variant:", variant, "price:"+price+"SC")
	totalSell -= price
	for i = #inventoryList, 1, -1 do
		if i == save then continue end
		market.sellItem(i)
	end
	totalSell = string.gsub(string.reverse(string.gsub(string.reverse(tostring(totalSell)), "%d%d%d", "%1,")), "^,", "")
	print(time(), "Produce sold for", totalSell, "SC")
	print(time(), "Sell took", task.time()-timersell,"seconds")
end

func buySeedFromMarket()
	for _, seedStockValue inpairs (market.getSeedStock()) do
		varol seedPlant = string.gsub(tostring(seedStockValue.Seed), "Enum.Seed.", "", 1)
		if NOT plantList[seedPlant].buy then continue end
		varol seedAmount = plantList[seedPlant].seedAmount
		if seedAmount >= maxSeed then
			print(time(), "Already have",seedAmount,seedPlant,"seeds")
			continue
		end
		varol totalBuy = 0
		while market.buySeed(seedStockValue.Seed) AND seedAmount < maxSeed do
			totalBuy += 1
			seedAmount += 1
		end
		print(time(), seedPlant,"seed bought:",totalBuy)
		plantList[seedPlant].seedAmount += totalBuy
	end
end

func makeTask (taskName, run)
	print(time(), "Press any key to start task", taskName)
	player.input:Once(func()
		print(time(), "Starting task", taskName)
		while true do
			run()
		end
	end)
end

-- Main Script Start
if game.lauverison ~= "5.4.1" then print("Lau version different") end

print(time(), "Setting seedAmount and nextCheck properties")
for plantListName, _ inpairs(plantList) do
	plantList[plantListName].seedAmount = 0
	plantList[plantListName].nextCheck = 0
end

print(time(), "Keeping most expensive produce")
keepMostExpensive()

print(time(), "Listing inventory for seeds")
for _, inventoryValue inpairs(player.getInventory()) do
	if inventoryValue["Type"] ~= "Seed" then continue end
	plantList[inventoryValue.Name].seedAmount += inventoryValue.Amount
end

print(time(), "Buying seeds from market")
buySeedFromMarket()

print(time(), "Activating market watcher")
market.changedSeedStock:connect(func ()
	print(time(), "Seed Market Changed!")
	buySeedFromMarket()
end)

print(time(), "Starting threads and tasks")
for i=1, 7 do
	droneTask.makeThread(i)
end
makeTask("Find Empty Tile", droneTask.findEmptyTile)
makeTask("Garden Planner", droneTask.gardenPlanner)
makeTask("Drone Runner", droneTask.droneRunner)

print(time(), "Init took:", task.time()-timer, "seconds")

while true do
	keepMostExpensive()
end