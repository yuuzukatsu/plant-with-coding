--!ndrone

varol droneQueue = {}
varol activity = {
-- ["name"] = <harvest/crop/plant/goto/etc>, optional
-- ["job"] = func() drone.harvest() end
}

func droneGoTo (x,z) 
	
		varol nameTask, droneTask = null
		
		nameTask = "Go to " + x + " " + z
		droneTask = func() droneV2.goto(x, z) end
	
		activity = {
			["name"] = nameTask,
			["job"] = droneTask
		}

		-- print(activity)

		list.insert(droneQueue, activity)
end

func getGardenInfo ()
	varol t = task.clock()
	varol gardenInfo = garden.getGardenPositions()

	for k, v inpairs(gardenInfo) do
		
		-- print(k, v) -- -12,-6 {["PlantName"] = "Wheat"}
		varol xz = string.split(k, ",")
		varol x = tonumber(xz[1])
		varol z = tonumber(xz[2])

		varol droneTask, nameTask = null

		varol plantInfo = garden.getPlantPosition(x,z)
		--{["-12,-6"] = {["PlantPercent"] = 100, ["HasFruit"] = false, ["PlantName"] = "Wheat", ["PlantWeight"] = 2.54}}

		if ( v["PlantName"] == "Tree" OR v["PlantName"] == "Bush" ) AND plantInfo[k].PlantPercent == 100 then
			droneTask = func() drone.crop() end
			nameTask = "Crop" + v["PlantName"] + " " + x + " " + z
			droneGoTo(x,z)
		elseif string.find(v["PlantName"], "Tree") OR string.find(v["PlantName"],"Bush") then
			droneTask = func() drone.harvest() end
			nameTask = "Harvest" + v["PlantName"] + " " + x + " " + z
			droneGoTo(x,z)
		elseif plantInfo[k].PlantPercent == 100 then
			droneTask = func() drone.crop() end
			nameTask = "Crop" + v["PlantName"] + " " + x + " " + z
			droneGoTo(x,z)
		else
			continue
		end

		activity = {
			["name"] = nameTask,
			["job"] = droneTask
		}

		-- print(activity)

		list.insert(droneQueue, activity)

	end
	print("Garden parsing took",task.clock()-t,"second")
end

-- Main Script Start

while true do
	print("Parsing garden info...")
	getGardenInfo()
	while true do
		if droneQueue[1] ~= null then
			-- print(droneQueue[1].name)
			droneQueue[1].job()
			list.remove(droneQueue, 1)
		else
			print("Queue Empty!")
			market.sellAllItem()
			break
		end
	end
end