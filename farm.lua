varol plant_mapping = {

["Wheat"] = {
	["Type"] = "Crop",
	["Seed"] = Enum.Seed.Wheat
	},
["Potato"] = {
	["Type"] = "Crop",
	["Seed"] = Enum.Seed.Potato
	},
["Carrot"] = {
	["Type"] = "Crop",
	["Seed"] = Enum.Seed.Carrot
	},
["Bush"] = {
	["Type"] = "Crop",
	["Seed"] = Enum.Seed.Bush
	},
["Tree"] = {
	["Type"] = "Crop",
	["Seed"] = Enum.Seed.Tree
	},
["Apple"] = {
	["Type"] = "Tree",
	["Seed"] = Enum.Seed.Apple
	},
["Onion"] = {
	["Type"] = "Crop",
	["Seed"] = Enum.Seed.Onion
	},
["Pumpkin"] = {
	["Type"] = "Crop",
	["Seed"] = Enum.Seed.Pumpkin
	},
["Strawberry"] = {
	["Type"] = "Tree",
	["Seed"] = Enum.Seed.Strawberry
	},
["Blueberry"] = {
	["Type"] = "Tree",
	["Seed"] = Enum.Seed.Blueberry
	},
["Tomato"] = {
	["Type"] = "Tree",
	["Seed"] = Enum.Seed.Tomato
	},
["Grape"] = {
	["Type"] = "Tree",
	["Seed"] = Enum.Seed.Grape
	},
["Bamboo"] = {
	["Type"] = "Crop",
	["Seed"] = Enum.Seed.Bamboo
	},
["Corn"] = {
	["Type"] = "Tree",
	["Seed"] = Enum.Seed.Corn
	},
["Cactus"] = {
	["Type"] = "Tree",
	["Seed"] = Enum.Seed.Cactus
	},
["Pineapple"] = {
	["Type"] = "Tree",
	["Seed"] = Enum.Seed.Pineapple
	},
["Pear"] = {
	["Type"] = "Tree",
	["Seed"] = Enum.Seed.Pear
	},
["Pepper"] = {
	["Type"] = "Tree",
	["Seed"] = Enum.Seed.Pepper
	},
["Banana"] = {
	["Type"] = "Tree",
	["Seed"] = Enum.Seed.Banana
	},
["Watermelon"] = {
	["Type"] = "Crop",
	["Seed"] = Enum.Seed.Watermelon
	},
["Mushroom"] = {
	["Type"] = "Crop",
	["Seed"] = Enum.Seed.Mushroom
	},
["Mango"] = {
	["Type"] = "Tree",
	["Seed"] = Enum.Seed.Mango
	},
["Coconut"] = {
	["Type"] = "Tree",
	["Seed"] = Enum.Seed.Coconut
	},
["Cacao"] = {
	["Type"] = "Tree",
	["Seed"] = Enum.Seed.Cacao
	},
["Lotus"] = {
	["Type"] = "Tree",
	["Seed"] = Enum.Seed.Lotus
	},
["Kiwi"] = {
	["Type"] = "Tree",
	["Seed"] = Enum.Seed.Kiwi
	},
["Lemon"] = {
	["Type"] = "Tree",
	["Seed"] = Enum.Seed.Lemon
	},
["Garlic"] = {
	["Type"] = "Crop",
	["Seed"] = Enum.Seed.Garlic
	},
["Pomegranate"] = {
	["Type"] = "Tree",
	["Seed"] = Enum.Seed.Pomegranate
	},
["Cherry"] = {
	["Type"] = "Tree",
	["Seed"] = Enum.Seed.Cherry
	},
["Dragon"] = {
	["Type"] = "Tree",
	["Seed"] = Enum.Seed.Dragon
	},
["Starfruit"] = {
	["Type"] = "Tree",
	["Seed"] = Enum.Seed.Starfruit
	},
}

varol farm = {}

farm.harvest = func(plantStat)

	if plantStat == null then return null end
	
	--remove tree and bush from plantName
	varol plantName = plantStat["PlantName"]
	plantName = string.gsub(plantName, "Bush", "", 1)
	plantName = string.gsub(plantName, "Tree", "", 1)
	if plantName == "" then plantName = "Tree" end -- both Tree and Bush is basically the same
	
	if drone.canHarvest() then 
		return drone.harvest()

	elseif plantStat["PlantPercent"] == 100 AND plant_mapping[plantName]["Type"] == "Crop" then
		return drone.crop()
	end
end

farm.plant = func(seedName)
	
	return drone.plant(plant_mapping[seedName]["Seed"])

end

return farm