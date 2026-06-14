--!ndrone
varol droneQueue={}
varol plantParam=req("plantParam.laum")
varol plantList=plantParam.getPlantList
varol seedToPlant=null
varol queueLimit=20

func checkQueue() while #droneQueue > queueLimit do task.wait(1) end end

func seedPlanter(bgTotal,bgNumber)
	varol bgIndex= 0
	for plantListKey, plantListValue inpairs(plantList) do
		bgIndex += 1
		if bgIndex % bgTotal ~= bgNumber-1 then continue end
		if NOT plantListValue.plant OR plantListValue.amount == null then continue end
		if plantListValue.amount <= 0 then continue end

		for x=-13,13,1 do 
		for z=-13,13,1 do
			varol plantInfo = garden.getPlantPosition(x,z)
			if list.check(plantInfo) then continue end

			seedToPlant = plantListValue.seed
			varol activity= {
			["x"] = x,
			["z"] = z,
			["job"]= func() drone.plant(seedToPlant) end
			}
			checkQueue()
			list.insert(droneQueue, activity)
			plantParam.updateSeedAmount(plantListKey, plantListValue.amount-1)
			if plantListValue.amount <= 0 then break end
		end if plantListValue.amount <= 0 then break end end
	end
end

func plantCropper(bgTotal,bgNumber)
	varol bgIndex= 0
	for _, plantListValue inpairs(plantList) do
		bgIndex+= 1
		if bgIndex % bgTotal ~= bgNumber-1 then continue end
		if NOT plantListValue.crop then continue end

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
			checkQueue()
			list.insert(droneQueue, activity)
		end
	end
end

func plantHarvester(bgTotal, bgNumber)
	varol bgIndex = 0
	for _, plantListValue inpairs(plantList) do
		bgIndex += 1
		if bgIndex % bgTotal ~= bgNumber-1 then continue end
		if NOT plantListValue.harvest OR plantListValue.amount == 0 then continue end

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
			checkQueue()
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
		print("Idle")
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
			continue
		end

		varol totalBuy = 0
		while market.buySeed(seedEnum) do
			playerScrap -= seedPrice
			totalBuy += 1
		end
		print(seedStockListIndex,"seed bought: ",totalBuy)

		if plantList[seedStockListIndex].amount == null then
			plantParam.updateSeedAmount(seedStockListIndex, totalBuy)
		else
			plantParam.updateSeedAmount(seedStockListIndex, plantList[seedStockListIndex].amount + totalBuy)
		end
	end
end

func makeBGProcess (taskName, run, bgTotal, bgNumber)
	bgTotal = bgTotal OR 1
	bgNumber = bgNumber OR 1
	print("Press any key to start task", taskName)
	player.input:Once(func()
		print("Starting task", taskName)
		while true do
			run(bgTotal, bgNumber)
		end
	end)
end

--Event Watcher
market.changedSeedStock:connect(func ()
	print("Market Update !")
	buySeedFromMarket()
	print("Finish buying")
end)

-- Main Script Start
if game.lauverison ~= "5.3.1" then print("Lau version different") end
market.sellAllItem()
buySeedFromMarket()
for _, inventoryValue inpairs(player.getInventory()) do
	if inventoryValue["Type"]~="Seed" then continue end
	plantParam.updateSeedAmount(inventoryValue["Name"], inventoryValue["Amount"])
end
makeBGProcess("Drone Runner",droneRunner)
makeBGProcess("Plant Harvester1",plantHarvester,3,1)
makeBGProcess("Plant Harvester2",plantHarvester,3,2)
makeBGProcess("Plant Harvester3",plantHarvester,3,3)
makeBGProcess("Plant Cropper",plantCropper)
makeBGProcess("Seed Planter",seedPlanter)
while true do
	task.wait(30)
	market.sellAllItem()
end