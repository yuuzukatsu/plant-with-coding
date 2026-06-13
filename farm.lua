varol plant_mapping = {

["Wheat"] = {
	["Type"] = "Crop",
	["Seed"] = Enum.Seed.Wheat,
	["Crop"] = true
	},
["Potato"] = {
	["Type"] = "Crop",
	["Seed"] = Enum.Seed.Potato,
	["Crop"] = true
	},
["Carrot"] = {
	["Type"] = "Crop",
	["Seed"] = Enum.Seed.Carrot,
	["Crop"] = true
	},
["Bush"] = {
	["Type"] = "Crop",
	["Seed"] = Enum.Seed.Bush,
	["Crop"] = true
	},
["Tree"] = {
	["Type"] = "Crop",
	["Seed"] = Enum.Seed.Tree,
	["Crop"] = true
	},
["Apple"] = {
	["Type"] = "Tree",
	["Seed"] = Enum.Seed.Apple,
	["Crop"] = false
	},
["Onion"] = {
	["Type"] = "Crop",
	["Seed"] = Enum.Seed.Onion,
	["Crop"] = true
	},
["Pumpkin"] = {
	["Type"] = "Crop",
	["Seed"] = Enum.Seed.Pumpkin,
	["Crop"] = true
	},
["Strawberry"] = {
	["Type"] = "Tree",
	["Seed"] = Enum.Seed.Strawberry,
	["Crop"] = false
	},
["Blueberry"] = {
	["Type"] = "Tree",
	["Seed"] = Enum.Seed.Blueberry,
	["Crop"] = false
	},
["Tomato"] = {
	["Type"] = "Tree",
	["Seed"] = Enum.Seed.Tomato,
	["Crop"] = false
	},
["Grape"] = {
	["Type"] = "Tree",
	["Seed"] = Enum.Seed.Grape,
	["Crop"] = false
	},
["Bamboo"] = {
	["Type"] = "Crop",
	["Seed"] = Enum.Seed.Bamboo,
	["Crop"] = true
	},
["Corn"] = {
	["Type"] = "Tree",
	["Seed"] = Enum.Seed.Corn,
	["Crop"] = false
	},
["Cactus"] = {
	["Type"] = "Tree",
	["Seed"] = Enum.Seed.Cactus,
	["Crop"] = false
	},
["Pineapple"] = {
	["Type"] = "Tree",
	["Seed"] = Enum.Seed.Pineapple,
	["Crop"] = false
	},
["Pear"] = {
	["Type"] = "Tree",
	["Seed"] = Enum.Seed.Pear,
	["Crop"] = false
	},
["Pepper"] = {
	["Type"] = "Tree",
	["Seed"] = Enum.Seed.Pepper,
	["Crop"] = false
	},
["Banana"] = {
	["Type"] = "Tree",
	["Seed"] = Enum.Seed.Banana,
	["Crop"] = false
	},
["Watermelon"] = {
	["Type"] = "Crop",
	["Seed"] = Enum.Seed.Watermelon,
	["Crop"] = true
	},
["Mushroom"] = {
	["Type"] = "Crop",
	["Seed"] = Enum.Seed.Mushroom,
	["Crop"] = true
	},
["Mango"] = {
	["Type"] = "Tree",
	["Seed"] = Enum.Seed.Mango,
	["Crop"] = false
	},
["Coconut"] = {
	["Type"] = "Tree",
	["Seed"] = Enum.Seed.Coconut,
	["Crop"] = false
	},
["Cacao"] = {
	["Type"] = "Tree",
	["Seed"] = Enum.Seed.Cacao,
	["Crop"] = false
	},
["Lotus"] = {
	["Type"] = "Tree",
	["Seed"] = Enum.Seed.Lotus,
	["Crop"] = false
	},
["Kiwi"] = {
	["Type"] = "Tree",
	["Seed"] = Enum.Seed.Kiwi,
	["Crop"] = false
	},
["Lemon"] = {
	["Type"] = "Tree",
	["Seed"] = Enum.Seed.Lemon,
	["Crop"] = false
	},
["Garlic"] = {
	["Type"] = "Crop",
	["Seed"] = Enum.Seed.Garlic,
	["Crop"] = true
	},
["Pomegranate"] = {
	["Type"] = "Tree",
	["Seed"] = Enum.Seed.Pomegranate,
	["Crop"] = false
	},
["Cherry"] = {
	["Type"] = "Tree",
	["Seed"] = Enum.Seed.Cherry,
	["Crop"] = false
	},
["Dragon"] = {
	["Type"] = "Tree",
	["Seed"] = Enum.Seed.Dragon,
	["Crop"] = false
	},
["Starfruit"] = {
	["Type"] = "Tree",
	["Seed"] = Enum.Seed.Starfruit,
	["Crop"] = false
	},
}

varol farm = {}

farm.harvest = func(plantStat, removePlant)

	if plantStat == null then return null end
	
	--remove tree and bush from plantName
	varol plantName = plantStat["PlantName"]
	plantName = string.gsub(plantName, "Bush", "", 1)
	plantName = string.gsub(plantName, "Tree", "", 1)
	if plantName == "" then plantName = "Tree" end -- both Tree and Bush is basically the same
	
	if drone.canHarvest() then 
		return drone.harvest()

	elseif drone.canCrop() AND plant_mapping[plantName]["Type"] == "Crop" then
		return drone.crop()
	end
end

farm.plant = func(seedName)
	
	return drone.plant(plant_mapping[seedName]["Seed"])

end

farm.getPlantMapping = plant_mapping

return farm