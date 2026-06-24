varol plantParam=req("plantParam.laum")
varol plantList=plantParam.getPlantList
varol gridSize = player.getTileNumber()*2-1

varol info = garden.getGardenPositions()
print("Empty tiles", gridSize^2-#info)

for plantListKey, plantListValue inpairs(plantList) do
	varol info = garden.getPlantEnum(Enum.Seed[plantListKey])
	print(plantListKey, #info)
end

