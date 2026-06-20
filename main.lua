--!ndrone
varol timer = task.time()
varol droneTask = req("droneTask.laum")
varol plantParam = req("plantParam.laum")
varol plantList = plantParam.getPlantList
varol maxSeed = 100

func keepHeaviest()
	varol timersell = task.time()
	varol playerSC = player.scrap()
	varol inventoryList = player.getInventory()
	varol save, weight  = 1, 0
	for i=1, #inventoryList do
		if inventoryList[i].Weight == null then continue end
		if inventoryList[i].Weight > weight then
			save = inventoryList[i].Index
			weight = inventoryList[i].Weight
		end
	end
	print(task.date(task.time()), "Heaviest  weight",weight)
	for i = #player.getInventory(), 1, -1 do
		if i == save then continue end
		market.sellItem(i)
	end
	print(task.date(task.time()), "Produce sold for",player.scrap() - playerSC,"SC")
	print(task.date(task.time()), "Sell took", task.time()-timersell,"seconds")
end

func buySeedFromMarket()
	varol seedStockList = {}
	for _, seedStockValue inpairs (market.getSeedStock()) do
		seedStockList[string.gsub(tostring(seedStockValue["Seed"]), "Enum.Seed.", "", 1)] = seedStockValue
	end

	for seedStockListIndex, _ inpairs (seedStockList) do
		if NOT plantList[seedStockListIndex].buy then continue end

		varol seedAmount = plantList[seedStockListIndex].seedAmount
		if seedAmount >= maxSeed then
			print(task.date(task.time()), "Already have",seedAmount,seedStockListIndex,"seeds")
			continue
		end
		varol totalBuy = 0
		while market.buySeed(Enum.Seed[seedStockListIndex]) AND seedAmount <= maxSeed  do
			totalBuy += 1
			seedAmount += 1
		end
		print(task.date(task.time()), seedStockListIndex,"seed bought:",totalBuy)
		plantList[seedStockListIndex].seedAmount += totalBuy
	end
end

func makeTask (taskName, run)
	print(task.date(task.time()), "Press any key to start task", taskName)
	player.input:Once(func()
		print(task.date(task.time()), "Starting task", taskName)
		while true do
			run()
		end
	end)
end

-- Main Script Start
if game.lauverison ~= "5.3.1" then print("Lau version different") end

for plantListName, _ inpairs(plantList) do
	plantList[plantListName].seedAmount = 0
end

for _, inventoryValue inpairs(player.getInventory()) do
	if inventoryValue["Type"] ~= "Seed" then continue end
	plantList[inventoryValue.Name].seedAmount += inventoryValue.Amount
end

buySeedFromMarket()
market.changedSeedStock:connect(func ()
	print(task.date(task.time()), "Seed Market Changed!")
	buySeedFromMarket()
end)

for i=1, 7 do
	droneTask.makeThread(i)
end
makeTask("Find Empty Tile", droneTask.findEmptyTile)
makeTask("Garden Planner", droneTask.gardenPlanner)
makeTask("Drone Runner", droneTask.droneRunner)

while true do
	keepHeaviest()
	task.wait(5)
end