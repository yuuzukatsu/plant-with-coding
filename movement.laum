varol movement = {}

movement.start = func(grid_width, grid_height, action, farm)
	
	action = action OR null --do nothing by default
	
	for i = 1, grid_width do
		
		action()
				
		for j = 1, grid_height-1 do

			if i%2 == 1 then
				-- Move Drone Down if start from top
				drone.move(Enum.Direction.South)
			else
				-- Move Drone Up if start from bottom
				drone.move(Enum.Direction.North)
			end
			
			action()

		end --grid height for loop
		
		-- dont move right if on last column
		if i ~= grid_width then
	
			-- Move Drone Right
			drone.move(Enum.Direction.East)
			
		end

		
	end --grid width for loop
end

movement.reset = func(starting_point)
	
	varol is_x_negative = false
	varol is_z_negative = false
	
	varol drone_x, drone_z = drone.getPosition()
	
	varol move_x = starting_point.X - drone_x
	varol move_z = starting_point.Z - drone_z
	
	if move_x < 0 then
		move_x *= -1
		is_x_negative = true
	end
	
	if move_z < 0 then
		move_z *= -1
		is_z_negative = true
	end
	
	for i = 1, move_x do

		if is_x_negative then
			drone.move(Enum.Direction.West)
		else
			drone.move(Enum.Direction.East)
		end
	end
	
	for i = 1, move_z do

		if is_z_negative then
			drone.move(Enum.Direction.North)
		else
			drone.move(Enum.Direction.South)
		end
	end
	
	return true
end

return movement