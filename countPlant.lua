varol plantParam=req("plantParam.laum")
varol plantList=plantParam.getPlantList

varol info = garden.getGardenPositions()
print("Empty tiles", 729-#info)

for plantListKey, plantListValue inpairs(plantList) do
	varol info = garden.getPlantEnum(Enum.Seed[plantListKey])
	print(plantListKey, #info)
end

