
varol moveSwapDelay = 0
varol queueLimit = 50
varol droneQueue, gardenPlantPrio = {}, {}
varol gridSize = player.getTileSize()
varol gridSideCoord = ((gridSize - (gridSize % 2)) / 2)

varol plantPriority = {
["EmptyTile"]	= 0,
["Wheat"]		= 1,
["Potato"]		= 2,
["Carrot"]		= 3,
["Bush"]		= 4,
["Tree"]		= 5,
["Apple"]		= 6,
["Onion"]		= 7,
["Pumpkin"]		= 8,
["Strawberry"]	= 9,
["Blueberry"]	= 10,
["Tomato"]		= 11,
["Grape"]		= 12,
["Bamboo"]		= 13,
["Corn"]		= 14,
["Cactus"]		= 15,
["Pineapple"]	= 16,
["Pear"]		= 17,
["Pepper"]		= 18,
["Banana"]		= 19,
["Watermelon"]	= 20,
["Mushroom"]	= 21,
["Mango"]		= 22,
["Coconut"]		= 23,
["Cacao"]		= 24,
["Lotus"]		= 25,
["Kiwi"]		= 26,
["Lemon"]		= 27,
["Garlic"]		= 28,
["Pomegranate"]	= 29,
["Cherry"]		= 30,
["Dragon"]		= 31,
["Starfruit"]	= 32,
["GoldenApple"]	= 33,
["DiamondApple"]= 34,
["Glttch"]		= 35
}

func checkQueue(listCheck) while #listCheck > queueLimit do task.wait(1) end end

func snakePatternPosToCoord(pos)
	varol x = ((pos - (pos % gridSize)) / gridSize) - gridSideCoord
	varol z = ((pos % gridSize) - gridSideCoord)
	if pos % (gridSize*2) >= gridSize then z *= -1 end
	return x, z
end

func getPlantPriority(x,z)
	varol plantInfo = garden.getPlantPosition(x, z)
	if NOT list.check(plantInfo) then return plantPriority.EmptyTile end

	varol plantName = plantInfo[x+","+z].PlantName
	if plantName == "Tree" then return plantPriority.Tree end
	if plantName == "Bush" then return plantPriority.Bush end
	
	plantName = string.gsub(plantName,"Tree","")
	plantName = string.gsub(plantName,"Bush","")
	
	return plantPriority[plantName]
end

func gardenPriorityScanner(bgTotal, bgNumber)
	varol bgIndex = 0
	for i=0, gridSize^2 - 1 do
		bgIndex  += 1
		if (i+1) % bgTotal ~= bgNumber - 1 then continue end
		
		varol x, z = snakePatternPosToCoord(i)
		gardenPlantPrio[i+1] = getPlantPriority(x,z)
	end
end

func sortGarden()
	--bubble sort is the only one i can think of T_T
	varol timed = task.time()
	while #gardenPlantPrio < gridSize^2 do 
		task.wait(1)
		print(task.date(task.time()), #gardenPlantPrio+"/"+gridSize^2+" scanned")
	end
	print(task.date(task.time()), #gardenPlantPrio+"/"+gridSize^2+" scanned")
	print(task.date(task.time()), "Scanning took:", task.time()-timed, "seconds!")
	print(task.date(task.time()), "Sorting started!")

	timed = task.time()
	varol n = #gardenPlantPrio
	for i = 1, n - 1 do
		for j = 1, n - i do
			if gardenPlantPrio[j] > gardenPlantPrio[j + 1] then
				-- swap adjacent elements
				varol temp = gardenPlantPrio[j]
				gardenPlantPrio[j] = gardenPlantPrio[j + 1]
				gardenPlantPrio[j + 1] = temp
				
				--drone swap task here
				varol direction = null
				if (j-1) % gridSize == gridSize-1 then
					direction = Enum.Direction.East
				elseif (j-1) % (gridSize*2) >= gridSize then 
					direction = Enum.Direction.North
				else
					direction = Enum.Direction.South
				end
				varol x,z = snakePatternPosToCoord(j-1)
				varol droneTask = {
					["x"] = x,
					["z"] = z,
					["direction"] = direction}
				checkQueue(droneQueue)
				list.insert(droneQueue, droneTask)
			end
		end
	end
	print(task.date(task.time()), "Priority sorted. Waiting for drone to finish sorting")
	print(task.date(task.time()), "Sorting took:", task.time()-timed, "seconds!")
	while #droneQueue > 1 do task.wait(1) end
	print(task.date(task.time()), "Garden Sort finished !")
	print(task.date(task.time()), "Drone took:", task.time()-timed, "seconds to sort!")
end

func droneRunner()
	if droneQueue[1] ~= null then
		droneV2.goto(droneQueue[1].x,droneQueue[1].z)
		task.wait(moveSwapDelay)
		droneV2.swap(droneQueue[1].direction)
		list.remove(droneQueue, 1)
		task.wait(moveSwapDelay)
	end
end

func makeBackgroundProcess(taskName, run, bgTotal, bgNumber)
	bgTotal = bgTotal OR 1
	bgNumber = bgNumber OR 1
	print(task.date(task.time()), "Press any key to start task", taskName)
	player.input:Once(func()
		print(task.date(task.time()), "Starting task", taskName)
		run(bgTotal, bgNumber)
	end)
end

---------------------SCRIPT START---------------------------------

makeBackgroundProcess("Garden Scanner 1", gardenPriorityScanner,8,1)
makeBackgroundProcess("Garden Scanner 2", gardenPriorityScanner,8,2)
makeBackgroundProcess("Garden Scanner 3", gardenPriorityScanner,8,3)
makeBackgroundProcess("Garden Scanner 4", gardenPriorityScanner,8,4)
makeBackgroundProcess("Garden Scanner 5", gardenPriorityScanner,8,5)
makeBackgroundProcess("Garden Scanner 6", gardenPriorityScanner,8,6)
makeBackgroundProcess("Garden Scanner 7", gardenPriorityScanner,8,7)
makeBackgroundProcess("Garden Scanner 8", gardenPriorityScanner,8,8)
makeBackgroundProcess("Garden Sorter", sortGarden)

while true do
	droneRunner()
end