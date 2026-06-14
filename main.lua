--!ndrone

varol droneQueue = {}
varol plantParam = req("plantParam.laum")
varol plantList = plantParam.getPlantList

--Functions

func seedPlanter()
	for plantListKey, plantListValue inpairs(plantList) do
		if plantListValue.plant == false OR plantListValue.amount == null then continue end
		if plantListValue.amount <= 0 then continue end

		for x=-13, 13, 1 do
			for z=-13, 13, 1 do
				varol plantInfo = garden.getPlantPosition(x,z)
				if list.check(plantInfo) then continue end

				varol activity = {
					["x"] = x,
					["z"] = z,
					["job"] = func() drone.plant(plantListValue.seed) end
				} 
				list.insert(droneQueue, activity)
				plantParam.updateSeedAmount(plantListKey, plantListValue.amount-1)
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
	--else
	--	print("Queue Empty!")
	end
end

varol makeBackgroundProcess = func(taskName, run)
	print("Press anything to start task", taskName)
	player.input:Once(func()
		print("Starting task", taskName)
		while true do
			run()
		end
	end)
end

--Watcher

market.changedSeedStock:connect(func ()
	print("Market Update !")
end)


-- Main Script Start

market.sellAllItem()
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