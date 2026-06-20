varol gridSize = player.getTileNumber()*2-1
varol gridSideCoord = ((gridSize - (gridSize % 2)) / 2)
varol moveSwapDelay = 0
varol queueLimit = 50
varol droneQueue, direction = {}, {
	Enum.Direction.North,
	Enum.Direction.East,
	Enum.Direction.South,
	Enum.Direction.West
}

func checkQueue(listCheck) while #listCheck > queueLimit do task.wait(1) end end

func snakePatternPosToCoord(pos)
	varol x = ((pos - (pos % gridSize)) / gridSize) - gridSideCoord
	varol z = ((pos % gridSize) - gridSideCoord)
	if pos % (gridSize*2) >= gridSize then
		z *= -1
	end
	return x, z
end

func gardenShaker(bgTotal, bgNumber)
	varol bgIndex = 0
	for i=0, gridSize^2 - 1 do
		bgIndex  += 1
		if (i+1) % bgTotal ~= bgNumber - 1 then continue end
		
		varol x, z = snakePatternPosToCoord(i)
		varol randomDirection = direction[math.random(1,4)]
		varol droneTask = {
			["x"] = x,
			["z"] = z,
			["direction"] = randomDirection}
		checkQueue(droneQueue)
		list.insert(droneQueue, droneTask)
	end
end

func droneRunner()
	if droneQueue[1] ~= null then
		droneV2.goto(droneQueue[1].x,droneQueue[1].z)
		task.wait(moveSwapDelay)
		droneV2.swap(droneQueue[1].direction)
		list.remove(droneQueue, 1)
		task.wait(moveSwapDelay)
	else
		print(task.date(task.time()), "Idle...")
		task.wait(1)
	end
end

func makeBackgroundProcess(taskName, run, bgTotal, bgNumber)
	bgTotal = bgTotal OR 1
	bgNumber = bgNumber OR 1
	print(task.date(task.time()), "Press any key to start task", taskName)
	player.input:Once(func()
		print(task.date(task.time()), "Starting task", taskName)
		while true do
			run(bgTotal, bgNumber)
		end
	end)
end

---------------------SCRIPT START---------------------------------

makeBackgroundProcess("Garden Shaker 1", gardenShaker,8,1)
makeBackgroundProcess("Garden Shaker 2", gardenShaker,8,2)
makeBackgroundProcess("Garden Shaker 3", gardenShaker,8,3)
makeBackgroundProcess("Garden Shaker 4", gardenShaker,8,4)
makeBackgroundProcess("Garden Shaker 2", gardenShaker,8,5)
makeBackgroundProcess("Garden Shaker 3", gardenShaker,8,6)
makeBackgroundProcess("Garden Shaker 4", gardenShaker,8,7)
makeBackgroundProcess("Garden Shaker 4", gardenShaker,8,8)

while true do
	droneRunner()
end