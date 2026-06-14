--!ndrone

varol droneQueue = {}
varol plantParam = req("plantParam.laum")
varol plantList = plantParam.getPlantList
varol seedToPlant = null

--Functions

func seedPlanter()
	for plantListKey, plantListValue inpairs(plantList) do
		if plantListValue.plant == false OR plantListValue.amount == null then continue end
		if plantListValue.amount <= 0 then continue end

		for x=-13, 13, 1 do
			for z=-13, 13, 1 do

				varol plantInfo = garden.getPlantPosition(x,z)
				if list.check(plantInfo) then continue end

				seedToPlant = plantListValue.seed
				varol activity = {
				["x"] = x,
				["z"] = z,
				["job"] = func() drone.plant(seedToPlant) end
				}
				list.insert(droneQueue, activity)
				plantParam.updateSeedAmount(plantListKey, plantListValue.amount-1)
				if plantListValue.amount <= 0 then break end
			end
		end
	end
end

func plantCropper()
	for _, plantListValue inpairs(plantList) do
		if plantListValue.crop == false then continue end

		for coords, _ inpairs(garden.getPlantEnum(plantListValue.seed)) do

			varol xz = string.split(coords, ",")
			varol x = tonumber(xz[1])
			varol z = tonumber(xz[2])

			varol plantInfo = garden.getPlantPosition(x,z)

			if NOT list.check(plantInfo) then continue end
			if plantInfo[coords].PlantPercent ~= 100 then continue end

			varol activity = {
			["x"] = x,
			["z"] = z,
			["job"] = func() drone.crop() end
			}
			list.insert(droneQueue, activity)
		end
	end
end

func plantHarvester()
	for _, plantListValue inpairs(plantList) do
		if plantListValue.harvest == false OR plantListValue.amount == 0 then continue end

		for coords, _ inpairs(garden.getPlantEnum(plantListValue.seed)) do

			varol xz = string.split(coords, ",")
			varol x = tonumber(xz[1])
			varol z = tonumber(xz[2])

			varol plantInfo = garden.getPlantPosition(x,z)

			if NOT list.check(plantInfo) then continue end
			if plantInfo[coords].FruitPercent == null then continue end
			if plantInfo[coords].FruitPercent < 100 then continue end

			varol activity = {
			["x"] = x,
			["z"] = z,
			["job"] = func() drone.harvest() end
			}
			list.insert(droneQueue, activity)
		end
	end
end

func droneRunner ()
	if droneQueue[1] ~= null then
		if droneQueue[1].x ~= null AND droneQueue[1].z ~= null then droneV2.goto(droneQueue[1].x, droneQueue[1].z) end
		droneQueue[1].job()
		list.remove(droneQueue, 1)
	else
		--drone idle do nothing and wait 1 second
		task.wait(1)
	end
end

func buySeedFromMarket ()
		varol seedStockList = {}

	for _, seedStockValue inpairs (market.getSeedStock()) do
		seedStockList[string.gsub(tostring(seedStockValue["Seed"]), "Enum.Seed.", "", 1)] = seedStockValue
	end

	for seedStockListIndex, seedStockListValue inpairs (seedStockList) do
		if NOT plantList[seedStockListIndex].buy then continue end

		varol playerScrap = player.scrap()
		varol seedPrice = market.getSeedPrice(plantList[seedStockListIndex].seed)
		varol seedEnum = plantList[seedStockListIndex].seed
		varol possibleMaxBuy = (playerScrap - (playerScrap % seedPrice)) / seedPrice

		if possibleMaxBuy == 0 then
			print("Not enough Scrap to buy", seedEnum)
			print("Seed Cost:", seedPrice)
			print("Player Scrap:", playerScrap)
			continue
		end

		varol totalBuy = 0

		while market.buySeed(seedEnum) do
			playerScrap -= seedPrice
			totalBuy += 1
		end

		print(seedStockListIndex, "seed bought: ", totalBuy)

		if plantList[seedStockListIndex].amount == null then
			plantParam.updateSeedAmount(seedStockListIndex, totalBuy)
		else
			plantParam.updateSeedAmount(seedStockListIndex, plantList[seedStockListIndex].amount + totalBuy)
		end
	end
end

varol makeBackgroundProcess = func(taskName, run)
	print("Press any key to start task", taskName)
	player.input:Once(func()
		print("Starting task", taskName)
		while true do
			run()
		end
	end)
end

--Event Watcher

market.changedSeedStock:connect(func ()
	print("Market Update !")
	buySeedFromMarket()
end)


-- Main Script Start

if game.version ~= "0.15.3" then
	print("Game version missmatch. Script might not work or return error")
end

market.sellAllItem()
buySeedFromMarket()

for _, inventoryValue inpairs(player.getInventory()) do
	if inventoryValue["Type"] ~= "Seed" then continue end
	plantParam.updateSeedAmount(inventoryValue["Name"], inventoryValue["Amount"])
end

makeBackgroundProcess("Drone Runner", droneRunner)
makeBackgroundProcess("Plant Harvester", plantHarvester)
makeBackgroundProcess("Plant Cropper", plantCropper)
makeBackgroundProcess("Seed Planter", seedPlanter)

while true do
	task.wait(30)
	market.sellAllItem()
end